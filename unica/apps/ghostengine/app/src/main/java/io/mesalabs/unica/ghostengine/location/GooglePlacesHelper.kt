package io.mesalabs.unica.ghostengine.location

import android.content.Context
import android.location.Geocoder
import android.os.Build
import android.util.Log
import com.google.android.gms.tasks.CancellationTokenSource
import com.google.android.libraries.places.api.Places
import com.google.android.libraries.places.api.model.AutocompleteSessionToken
import com.google.android.libraries.places.api.model.Place
import com.google.android.libraries.places.api.model.TypeFilter
import com.google.android.libraries.places.api.net.FetchPlaceRequest
import com.google.android.libraries.places.api.net.FindAutocompletePredictionsRequest
import com.google.android.libraries.places.api.net.PlacesClient
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.util.Locale

data class PlacePrediction(
    val placeId: String,
    val primaryText: String,
    val secondaryText: String,
    val fullText: String
)

data class PlaceDetails(
    val name: String,
    val latitude: Double,
    val longitude: Double
)

object GooglePlacesHelper {
    private const val TAG = "GooglePlacesHelper"
    private var placesClient: PlacesClient? = null
    private var sessionToken: AutocompleteSessionToken? = null
    private var cancellationTokenSource: CancellationTokenSource? = null

    fun isInitialized(): Boolean = Places.isInitialized()

    fun initialize(context: Context, apiKey: String) {
        if (apiKey.isBlank()) return
        try {
            if (!Places.isInitialized()) {
                Places.initializeWithNewPlacesApiEnabled(context.applicationContext, apiKey)
            }
            placesClient = Places.createClient(context.applicationContext)
            sessionToken = AutocompleteSessionToken.newInstance()
        } catch (e: Exception) {
            Log.e(TAG, "Failed to initialize Places SDK", e)
        }
    }

    suspend fun searchPlaces(
        context: Context,
        query: String
    ): List<PlacePrediction> = withContext(Dispatchers.IO) {
        if (query.trim().length < 2) return@withContext emptyList()

        if (placesClient != null && isInitialized()) {
            try {
                cancellationTokenSource?.cancel()
                val token = CancellationTokenSource()
                cancellationTokenSource = token

                val request = FindAutocompletePredictionsRequest.builder()
                    .setTypeFilter(TypeFilter.CITIES)
                    .setSessionToken(sessionToken)
                    .setCancellationToken(token.token)
                    .setQuery(query)
                    .build()

                val response = kotlinx.coroutines.tasks.await(placesClient!!.findAutocompletePredictions(request))
                return@withContext response.autocompletePredictions.map { p ->
                    PlacePrediction(
                        placeId = p.placeId,
                        primaryText = p.getPrimaryText(null).toString(),
                        secondaryText = p.getSecondaryText(null).toString(),
                        fullText = p.getFullText(null).toString()
                    )
                }
            } catch (e: Exception) {
                Log.w(TAG, "Places API error, falling back to Geocoder", e)
            }
        }

        // Fallback: Android Geocoder
        try {
            val geocoder = Geocoder(context, Locale.getDefault())
            val addresses = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                var result: List<android.location.Address> = emptyList()
                geocoder.getFromLocationName(query, 5) { addrs -> result = addrs }
                result
            } else {
                @Suppress("DEPRECATION")
                geocoder.getFromLocationName(query, 5) ?: emptyList()
            }

            return@withContext addresses.map { addr ->
                val name = addr.locality ?: addr.featureName ?: addr.adminArea ?: query
                val country = addr.countryName ?: ""
                PlacePrediction(
                    placeId = "geo_${addr.latitude}_${addr.longitude}",
                    primaryText = name,
                    secondaryText = country,
                    fullText = if (country.isNotEmpty()) "$name, $country" else name
                )
            }
        } catch (e: Exception) {
            Log.e(TAG, "Geocoder fallback failed", e)
            return@withContext emptyList()
        }
    }

    suspend fun fetchPlaceDetails(
        placeId: String
    ): PlaceDetails? = withContext(Dispatchers.IO) {
        if (placeId.startsWith("geo_")) {
            val parts = placeId.removePrefix("geo_").split("_")
            if (parts.size == 2) {
                val lat = parts[0].toDoubleOrNull() ?: 0.0
                val lng = parts[1].toDoubleOrNull() ?: 0.0
                return@withContext PlaceDetails("Location", lat, lng)
            }
        }

        val client = placesClient ?: return@withContext null
        val placeFields = listOf(Place.Field.NAME, Place.Field.LAT_LNG)
        val request = FetchPlaceRequest.builder(placeId, placeFields)
            .setSessionToken(sessionToken)
            .build()

        return@withContext try {
            val response = kotlinx.coroutines.tasks.await(client.fetchPlace(request))
            val place = response.place
            val latLng = place.latLng ?: return@withContext null
            PlaceDetails(
                name = place.name ?: "Unknown Place",
                latitude = latLng.latitude,
                longitude = latLng.longitude
            )
        } catch (e: Exception) {
            Log.e(TAG, "Failed to fetch place details", e)
            null
        }
    }
}