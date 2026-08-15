package io.mesalabs.unica.prayertimes

import android.content.Context
import android.content.SharedPreferences
import android.provider.Settings

class Prefs private constructor(private val ctx: Context) {
    private val prefs: SharedPreferences = ctx.getSharedPreferences("prayer_times_prefs", Context.MODE_PRIVATE)

    var isEnabled: Boolean
        get() = prefs.getBoolean("enabled", false)
        set(value) = prefs.edit().putBoolean("enabled", value).apply()

    var latitude: Float
        get() = prefs.getFloat("latitude", 0f)
        set(value) = prefs.edit().putFloat("latitude", value).apply()

    var longitude: Float
        get() = prefs.getFloat("longitude", 0f)
        set(value) = prefs.edit().putFloat("longitude", value).apply()

    var cityName: String
        get() = prefs.getString("city_name", "") ?: ""
        set(value) = prefs.edit().putString("city_name", value).apply()

    var cachedTimings: String
        get() = prefs.getString("cached_timings", "") ?: ""
        set(value) = prefs.edit().putString("cached_timings", value).apply()

    var lastFetchTime: Long
        get() = prefs.getLong("last_fetch", 0L)
        set(value) = prefs.edit().putLong("last_fetch", value).apply()

    fun getSoundForPrayer(prayerName: String): String? {
        return prefs.getString("sound_$prayerName", null)
    }

    fun setSoundForPrayer(prayerName: String, uri: String?) {
        prefs.edit().putString("sound_$prayerName", uri).apply()
    }

    companion object {
        @Volatile private var inst: Prefs? = null
        fun get(ctx: Context): Prefs = inst ?: synchronized(this) {
            inst ?: Prefs(ctx.applicationContext).also { inst = it }
        }
    }
}
