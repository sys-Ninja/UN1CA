package io.mesalabs.unica.ghostengine.data

import android.content.Context
import android.content.SharedPreferences

class GhostEnginePrefs private constructor(context: Context) {
    private val prefs: SharedPreferences = context.getSharedPreferences("ghost_engine_prefs", Context.MODE_PRIVATE)

    // Ghost Camera Settings
    var isGhostCameraEnabled: Boolean
        get() = prefs.getBoolean("ghost_camera_enabled", false)
        set(value) = prefs.edit().putBoolean("ghost_camera_enabled", value).apply()

    var mediaUri: String?
        get() = prefs.getString("ghost_media_uri", null)
        set(value) = prefs.edit().putString("ghost_media_uri", value).apply()

    var isVideoMedia: Boolean
        get() = prefs.getBoolean("is_video_media", false)
        set(value) = prefs.edit().putBoolean("is_video_media", value).apply()

    var showCameraTool: Boolean
        get() = prefs.getBoolean("show_camera_tool", true)
        set(value) = prefs.edit().putBoolean("show_camera_tool", value).apply()

    // Stealth GPS Settings
    var isStealthGpsEnabled: Boolean
        get() = prefs.getBoolean("stealth_gps_enabled", false)
        set(value) = prefs.edit().putBoolean("stealth_gps_enabled", value).apply()

    var spoofedLatitude: Double
        get() = java.lang.Double.longBitsToDouble(prefs.getLong("spoofed_lat", java.lang.Double.doubleToRawLongBits(21.4225))) // Makkah default
        set(value) = prefs.edit().putLong("spoofed_lat", java.lang.Double.doubleToRawLongBits(value)).apply()

    var spoofedLongitude: Double
        get() = java.lang.Double.longBitsToDouble(prefs.getLong("spoofed_lng", java.lang.Double.doubleToRawLongBits(39.8262)))
        set(value) = prefs.edit().putLong("spoofed_lng", java.lang.Double.doubleToRawLongBits(value)).apply()

    var spoofedAltitude: Double
        get() = java.lang.Double.longBitsToDouble(prefs.getLong("spoofed_alt", java.lang.Double.doubleToRawLongBits(300.0)))
        set(value) = prefs.edit().putLong("spoofed_alt", java.lang.Double.doubleToRawLongBits(value)).apply()

    var movementSpeed: Float
        get() = prefs.getFloat("movement_speed", 1.4f)
        set(value) = prefs.edit().putFloat("movement_speed", value).apply()

    var showFloatingJoystick: Boolean
        get() = prefs.getBoolean("show_floating_joystick", false)
        set(value) = prefs.edit().putBoolean("show_floating_joystick", value).apply()

    var isPerAppGps: Boolean
        get() = prefs.getBoolean("per_app_gps", false)
        set(value) = prefs.edit().putBoolean("per_app_gps", value).apply()

    var targetPackages: Set<String>
        get() = prefs.getStringSet("target_packages", emptySet()) ?: emptySet()
        set(value) = prefs.edit().putStringSet("target_packages", value).apply()

    var googlePlacesApiKey: String
        get() = prefs.getString("google_places_api_key", "") ?: ""
        set(value) = prefs.edit().putString("google_places_api_key", value).apply()

    companion object {
        @Volatile private var instance: GhostEnginePrefs? = null
        fun get(ctx: Context): GhostEnginePrefs = instance ?: synchronized(this) {
            instance ?: GhostEnginePrefs(ctx.applicationContext).also { instance = it }
        }
    }
}