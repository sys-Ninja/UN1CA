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

object StealthLocationManager {
    private const val TAG = "StealthLocation"
    private var spoofJob: Job? = null
    private val scope = CoroutineScope(Dispatchers.Default)

    fun startSpoofing(context: Context) {
        val lm = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        val prefs = GhostEnginePrefs.get(context)

        // Ensure GPS provider test mock is registered if needed
        try {
            lm.addTestProvider(
                LocationManager.GPS_PROVIDER,
                false, false, false, false, true, true, true,
                1, 1
            )
            lm.setTestProviderEnabled(LocationManager.GPS_PROVIDER, true)
        } catch (_: Exception) {}

        spoofJob?.cancel()
        spoofJob = scope.launch {
            while (isActive) {
                try {
                    val lat = prefs.spoofedLatitude
                    val lng = prefs.spoofedLongitude
                    val alt = prefs.spoofedAltitude

                    // Add subtle natural GPS micro-jitter (~0.1m) to simulate authentic satellite drift
                    val jitterLat = lat + (Random.nextDouble(-0.000001, 0.000001))
                    val jitterLng = lng + (Random.nextDouble(-0.000001, 0.000001))
                    val jitterAlt = alt + (Random.nextDouble(-0.2, 0.2))

                    val loc = Location(LocationManager.GPS_PROVIDER).apply {
                        latitude = jitterLat
                        longitude = jitterLng
                        altitude = jitterAlt
                        accuracy = Random.nextFloat() * 1.5f + 2.0f // 2.0 - 3.5m high accuracy
                        time = System.currentTimeMillis()
                        elapsedRealtimeNanos = SystemClock.elapsedRealtimeNanos()
                        speed = prefs.movementSpeed
                        bearing = Random.nextFloat() * 360f

                        // CRITICAL ANTI-DETECTION: Clear isMock flag completely
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            mock = false
                        }
                    }

                    // Bypass mock indicator through reflection on older frameworks as well
                    try {
                        val setIsMockMethod = Location::class.java.getDeclaredMethod("setIsFromMockProvider", Boolean::class.javaPrimitiveType)
                        setIsMockMethod.isAccessible = true
                        setIsMockMethod.invoke(loc, false)
                    } catch (_: Exception) {}

                    lm.setTestProviderLocation(LocationManager.GPS_PROVIDER, loc)

                } catch (e: Exception) {
                    Log.e(TAG, "Error injecting stealth location", e)
                }

                delay(1000) // 1Hz authentic GPS update rate
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

    // Synthesizes authentic NMEA sentences with 12 active GPS satellites in view
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