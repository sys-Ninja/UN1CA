package io.mesalabs.unica.prayertimes.location

import android.content.Context
import android.location.Address
import android.location.Geocoder
import android.util.Log
import com.google.android.libraries.places.api.Places
import com.google.android.libraries.places.api.model.AutocompletePrediction
import com.google.android.libraries.places.api.model.AutocompleteSessionToken
import com.google.android.libraries.places.api.model.Place
import com.google.android.libraries.places.api.model.TypeFilter
import com.google.android.libraries.places.api.net.FetchPlaceRequest
import com.google.android.libraries.places.api.net.FindAutocompletePredictionsRequest
import com.google.android.libraries.places.api.net.PlacesClient
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.tasks.await
import kotlinx.coroutines.withContext
import java.util.Locale
import java.util.TimeZone

data class PlaceSuggestion(
    val placeId: String,
    val primaryText: String,
    val secondaryText: String,
    val fullText: String
)

data class PlaceResolvedLocation(
    val name: String,
    val latitude: Double,
    val longitude: Double,
    val timeZoneId: String
)

object GooglePlacesHelper {
    private const val TAG = "GooglePlacesHelper"
    private var placesClient: PlacesClient? = null
    private var sessionToken: AutocompleteSessionToken? = null

    fun initialize(context: Context, apiKey: String) {
        try {
            if (!Places.isInitialized() && apiKey.isNotBlank()) {
                Places.initializeWithNewPlacesApiEnabled(context.applicationContext, apiKey)
            }
            if (Places.isInitialized()) {
                placesClient = Places.createClient(context.applicationContext)
                sessionToken = AutocompleteSessionToken.newInstance()
            }
        } catch (e: Exception) {
            Log.e(TAG, "Places initialization error", e)
        }
    }

    fun isPlacesAvailable(): Boolean = Places.isInitialized() && placesClient != null

    suspend fun searchCities(
        context: Context,
        query: String
    ): List<PlaceSuggestion> = withContext(Dispatchers.IO) {
        if (query.trim().length < 2) return@withContext emptyList()

        if (isPlacesAvailable() && placesClient != null) {
            try {
                if (sessionToken == null) {
                    sessionToken = AutocompleteSessionToken.newInstance()
                }

                val request = FindAutocompletePredictionsRequest.builder()
                    .setQuery(query)
                    .setTypeFilter(TypeFilter.CITIES)
                    .setSessionToken(sessionToken)
                    .build()

                val response = placesClient!!.findAutocompletePredictions(request).await()
                return@withContext response.autocompletePredictions.map { p: AutocompletePrediction ->
                    PlaceSuggestion(
                        placeId = p.placeId,
                        primaryText = p.getPrimaryText(null).toString(),
                        secondaryText = p.getSecondaryText(null).toString(),
                        fullText = p.getFullText(null).toString()
                    )
                }
            } catch (e: Exception) {
                Log.w(TAG, "Places SDK search failed, falling back to Geocoder", e)
            }
        }

        // Fallback: Android Geocoder
        try {
            @Suppress("DEPRECATION")
            val geocoder = Geocoder(context, Locale.getDefault())
            val addresses = geocoder.getFromLocationName(query, 5) ?: emptyList()
            return@withContext addresses.map { addr: Address ->
                val primary = addr.locality ?: addr.subAdminArea ?: addr.adminArea ?: query
                val secondary = listOfNotNull(addr.adminArea, addr.countryName).distinct().joinToString(", ")
                PlaceSuggestion(
                    placeId = "geo_${addr.latitude}_${addr.longitude}",
                    primaryText = primary,
                    secondaryText = secondary,
                    fullText = if (secondary.isNotBlank()) "$primary, $secondary" else primary
                )
            }
        } catch (e: Exception) {
            Log.e(TAG, "Geocoder search failed", e)
            emptyList()
        }
    }

    suspend fun fetchPlaceDetails(
        context: Context,
        suggestion: PlaceSuggestion
    ): PlaceResolvedLocation? = withContext(Dispatchers.IO) {
        if (suggestion.placeId.startsWith("geo_")) {
            // Parsed from Geocoder fallback
            val parts = suggestion.placeId.removePrefix("geo_").split("_")
            val lat = parts.getOrNull(0)?.toDoubleOrNull() ?: 0.0
            val lng = parts.getOrNull(1)?.toDoubleOrNull() ?: 0.0
            return@withContext PlaceResolvedLocation(
                name = suggestion.primaryText,
                latitude = lat,
                longitude = lng,
                timeZoneId = TimeZone.getDefault().id
            )
        }

        if (isPlacesAvailable() && placesClient != null) {
            try {
                val placeFields = listOf(Place.Field.ID, Place.Field.NAME, Place.Field.LAT_LNG, Place.Field.UTC_OFFSET)
                val request = FetchPlaceRequest.builder(suggestion.placeId, placeFields)
                    .setSessionToken(sessionToken)
                    .build()

                val response = placesClient!!.fetchPlace(request).await()
                val place = response.place
                val latLng = place.latLng ?: return@withContext null
                val name = place.name ?: suggestion.primaryText

                sessionToken = AutocompleteSessionToken.newInstance()

                return@withContext PlaceResolvedLocation(
                    name = name,
                    latitude = latLng.latitude,
                    longitude = latLng.longitude,
                    timeZoneId = TimeZone.getDefault().id
                )
            } catch (e: Exception) {
                Log.e(TAG, "Fetch place details failed", e)
            }
        }

        // Geocoder fallback by name
        try {
            @Suppress("DEPRECATION")
            val geocoder = Geocoder(context, Locale.getDefault())
            val list = geocoder.getFromLocationName(suggestion.fullText, 1)
            if (!list.isNullOrEmpty()) {
                val addr = list[0]
                return@withContext PlaceResolvedLocation(
                    name = addr.locality ?: suggestion.primaryText,
                    latitude = addr.latitude,
                    longitude = addr.longitude,
                    timeZoneId = TimeZone.getDefault().id
                )
            }
        } catch (e: Exception) {
            Log.e(TAG, "Geocoder details fallback failed", e)
        }

        null
    }
}