package io.mesalabs.unica.ghostengine.data

import android.content.Context
import android.provider.Settings

class GhostEnginePrefs private constructor(private val context: Context) {
    private val resolver = context.contentResolver
    private val sp = context.getSharedPreferences("ghost_engine_prefs", Context.MODE_PRIVATE)

    // Ghost Camera Settings
    var isGhostCameraEnabled: Boolean
        get() = Settings.System.getInt(resolver, "unica_ghost_camera_enabled", 0) == 1
        set(value) { Settings.System.putInt(resolver, "unica_ghost_camera_enabled", if (value) 1 else 0) }

    var mediaUri: String?
        get() = Settings.System.getString(resolver, "unica_ghost_media_uri") ?: sp.getString("ghost_media_uri", null)
        set(value) {
            Settings.System.putString(resolver, "unica_ghost_media_uri", value)
            sp.edit().putString("ghost_media_uri", value).apply()
        }

    var isVideoMedia: Boolean
        get() = Settings.System.getInt(resolver, "unica_ghost_is_video", 0) == 1
        set(value) { Settings.System.putInt(resolver, "unica_ghost_is_video", if (value) 1 else 0) }

    var showCameraTool: Boolean
        get() = Settings.System.getInt(resolver, "unica_ghost_camera_tool", 1) == 1
        set(value) { Settings.System.putInt(resolver, "unica_ghost_camera_tool", if (value) 1 else 0) }

    // Stealth GPS Settings
    var isStealthGpsEnabled: Boolean
        get() = Settings.System.getInt(resolver, "unica_ghost_gps_enabled", 0) == 1
        set(value) { Settings.System.putInt(resolver, "unica_ghost_gps_enabled", if (value) 1 else 0) }

    var spoofedLatitude: Double
        get() {
            val s = Settings.System.getString(resolver, "unica_ghost_lat")
            return s?.toDoubleOrNull() ?: 21.4225 // Makkah default
        }
        set(value) { Settings.System.putString(resolver, "unica_ghost_lat", value.toString()) }

    var spoofedLongitude: Double
        get() {
            val s = Settings.System.getString(resolver, "unica_ghost_lng")
            return s?.toDoubleOrNull() ?: 39.8262
        }
        set(value) { Settings.System.putString(resolver, "unica_ghost_lng", value.toString()) }

    var spoofedAltitude: Double
        get() {
            val s = Settings.System.getString(resolver, "unica_ghost_alt")
            return s?.toDoubleOrNull() ?: 300.0
        }
        set(value) { Settings.System.putString(resolver, "unica_ghost_alt", value.toString()) }

    var movementSpeed: Float
        get() = try { Settings.System.getFloat(resolver, "unica_ghost_speed") } catch (_: Exception) { 1.4f }
        set(value) { Settings.System.putFloat(resolver, "unica_ghost_speed", value) }

    var showFloatingJoystick: Boolean
        get() = Settings.System.getInt(resolver, "unica_ghost_joystick_enabled", 0) == 1
        set(value) { Settings.System.putInt(resolver, "unica_ghost_joystick_enabled", if (value) 1 else 0) }

    var isPerAppGps: Boolean
        get() = Settings.System.getInt(resolver, "unica_ghost_per_app", 0) == 1
        set(value) { Settings.System.putInt(resolver, "unica_ghost_per_app", if (value) 1 else 0) }

    var targetPackages: Set<String>
        get() = sp.getStringSet("target_packages", emptySet()) ?: emptySet()
        set(value) = sp.edit().putStringSet("target_packages", value).apply()

    var googlePlacesApiKey: String
        get() = Settings.System.getString(resolver, "google_places_api_key") ?: sp.getString("google_places_api_key", "") ?: ""
        set(value) = sp.edit().putString("google_places_api_key", value).apply()

    companion object {
        @Volatile private var instance: GhostEnginePrefs? = null
        fun get(ctx: Context): GhostEnginePrefs = instance ?: synchronized(this) {
            instance ?: GhostEnginePrefs(ctx.applicationContext).also { instance = it }
        }
    }
}