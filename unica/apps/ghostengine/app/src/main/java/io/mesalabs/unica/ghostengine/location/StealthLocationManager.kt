package io.mesalabs.unica.ghostengine.location

import android.content.Context
import android.location.Location
import android.location.LocationManager
import android.os.Build
import android.os.SystemClock
import android.util.Log
import io.mesalabs.unica.ghostengine.data.GhostEnginePrefs
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone
import kotlin.random.Random

/**
 * Injects stealth GPS locations using two-tier strategy:
 *
 * TIER 1 (preferred, isMock=false):
 *   Calls the hidden [LocationManager.reportLocation] API which requires
 *   android.permission.LOCATION_HARDWARE (granted via privapp-permissions).
 *   Locations created this way are real system locations — isMock is NEVER set to true.
 *
 * TIER 2 (fallback, isMock=true):
 *   Standard TestProvider injection with reflection to attempt clearing the mock flag.
 *   system_server will re-apply isMock=true on delivery, but the spoof coords still work.
 */
object StealthLocationManager {
    private const val TAG = "StealthLocation"
    private var spoofJob: Job? = null
    private val scope = CoroutineScope(Dispatchers.Default)

    // Cached reflection method for LocationManager.reportLocation(Location)
    // Only works if LOCATION_HARDWARE permission is granted
    private val reportLocationMethod by lazy {
        try {
            LocationManager::class.java.getDeclaredMethod("reportLocation", Location::class.java)
                .also { it.isAccessible = true }
        } catch (_: Exception) { null }
    }

    fun startSpoofing(context: Context) {
        val lm = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager

        // Register test provider as fallback (no-op if already registered)
        try {
            lm.addTestProvider(
                LocationManager.GPS_PROVIDER,
                false, false, false, false, true, true, true, 1, 1
            )
            lm.setTestProviderEnabled(LocationManager.GPS_PROVIDER, true)
        } catch (_: Exception) {}

        spoofJob?.cancel()
        spoofJob = scope.launch {
            while (isActive) {
                try {
                    injectLocation(context, lm)
                } catch (e: Exception) {
                    Log.w(TAG, "Location inject error", e)
                }
                delay(1000)
            }
        }
    }

    private fun injectLocation(context: Context, lm: LocationManager) {
        val prefs = GhostEnginePrefs.get(context)
        val lat = prefs.spoofedLatitude + Random.nextDouble(-0.000001, 0.000001)
        val lng = prefs.spoofedLongitude + Random.nextDouble(-0.000001, 0.000001)
        val alt = prefs.spoofedAltitude + Random.nextDouble(-0.2, 0.2)

        val loc = Location(LocationManager.GPS_PROVIDER).apply {
            latitude  = lat
            longitude = lng
            altitude  = alt
            accuracy  = Random.nextFloat() * 1.5f + 2.0f
            time      = System.currentTimeMillis()
            elapsedRealtimeNanos = SystemClock.elapsedRealtimeNanos()
            speed     = prefs.movementSpeed
            bearing   = Random.nextFloat() * 360f
        }

        // ── TIER 1: reportLocation (isMock=false) ─────────────────────────
        val method = reportLocationMethod
        if (method != null) {
            try {
                method.invoke(lm, loc)
                return // success — isMock stays false
            } catch (_: Exception) {}
        }

        // ── TIER 2: TestProvider fallback (isMock=true, coords still work) ─
        try {
            // Attempt to clear mock flag via reflection before submission
            Location::class.java.getDeclaredMethod("setIsFromMockProvider", Boolean::class.javaPrimitiveType)
                .also { it.isAccessible = true }.invoke(loc, false)
        } catch (_: Exception) {}

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            try {
                Location::class.java.getDeclaredMethod("setMock", Boolean::class.javaPrimitiveType)
                    .also { it.isAccessible = true }.invoke(loc, false)
            } catch (_: Exception) {}
        }

        lm.setTestProviderLocation(LocationManager.GPS_PROVIDER, loc)
    }

    fun updateSpoofedLocation(context: Context, lat: Double, lng: Double) {
        val prefs = GhostEnginePrefs.get(context)
        prefs.spoofedLatitude  = lat
        prefs.spoofedLongitude = lng
        if (spoofJob?.isActive == true) {
            scope.launch {
                try {
                    val lm = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
                    injectLocation(context, lm)
                } catch (_: Exception) {}
            }
        }
    }

    fun stopSpoofing(context: Context) {
        spoofJob?.cancel()
        spoofJob = null
        try {
            val lm = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
            lm.removeTestProvider(LocationManager.GPS_PROVIDER)
        } catch (_: Exception) {}
    }

    fun generateAuthenticNmea(lat: Double, lng: Double, alt: Double): String {
        val sdf = SimpleDateFormat("HHmmss.SS", Locale.US).apply {
            timeZone = TimeZone.getTimeZone("UTC")
        }
        val utcTime = sdf.format(Date())
        val latDeg = Math.floor(Math.abs(lat)).toInt()
        val latMin = (Math.abs(lat) - latDeg) * 60.0
        val latStr = String.format(Locale.US, "%02d%07.4f,%s", latDeg, latMin, if (lat >= 0) "N" else "S")
        val lngDeg = Math.floor(Math.abs(lng)).toInt()
        val lngMin = (Math.abs(lng) - lngDeg) * 60.0
        val lngStr = String.format(Locale.US, "%03d%07.4f,%s", lngDeg, lngMin, if (lng >= 0) "E" else "W")
        return "\$GPGGA,$utcTime,$latStr,$lngStr,1,12,0.8,$alt,M,0.0,M,,*47"
    }
}