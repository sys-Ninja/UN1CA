package io.mesalabs.unica.prayertimes

import android.content.Context
import android.content.SharedPreferences
import io.mesalabs.unica.prayertimes.calc.HighLatitudeRule
import io.mesalabs.unica.prayertimes.calc.Madhab
import io.mesalabs.unica.prayertimes.calc.Prayer
import java.util.TimeZone

class Prefs private constructor(ctx: Context) {
    private val prefs: SharedPreferences = ctx.getSharedPreferences("prayer_times_prefs", Context.MODE_PRIVATE)

    private val resolver = ctx.contentResolver

    var isEnabled: Boolean
        get() = Settings.System.getInt(resolver, "unica_prayer_times_enabled", 0) == 1
        set(value) {
            Settings.System.putInt(resolver, "unica_prayer_times_enabled", if (value) 1 else 0)
            prefs.edit().putBoolean("enabled", value).apply()
        }

    var latitude: Float
        get() = prefs.getFloat("latitude", 0f)
        set(value) = prefs.edit().putFloat("latitude", value).apply()

    var longitude: Float
        get() = prefs.getFloat("longitude", 0f)
        set(value) = prefs.edit().putFloat("longitude", value).apply()

    var cityName: String
        get() = prefs.getString("city_name", "") ?: ""
        set(value) = prefs.edit().putString("city_name", value).apply()

    var timeZoneId: String
        get() = prefs.getString("timezone_id", TimeZone.getDefault().id) ?: TimeZone.getDefault().id
        set(value) = prefs.edit().putString("timezone_id", value).apply()

    var useOnlineApi: Boolean
        get() = Settings.System.getInt(resolver, "unica_prayer_times_online_sync", 1) == 1
        set(value) {
            Settings.System.putInt(resolver, "unica_prayer_times_online_sync", if (value) 1 else 0)
            prefs.edit().putBoolean("use_online_api", value).apply()
        }

    var calculationMethodKey: String
        get() = Settings.System.getString(resolver, "unica_prayer_times_method") ?: prefs.getString("calculation_method", "egyptian") ?: "egyptian"
        set(value) {
            Settings.System.putString(resolver, "unica_prayer_times_method", value)
            prefs.edit().putString("calculation_method", value).apply()
        }

    var madhabKey: String
        get() = Settings.System.getString(resolver, "unica_prayer_times_madhab") ?: prefs.getString("madhab", "shafi") ?: "shafi"
        set(value) {
            Settings.System.putString(resolver, "unica_prayer_times_madhab", value)
            prefs.edit().putString("madhab", value).apply()
        }

    var highLatRuleKey: String
        get() = prefs.getString("high_lat_rule", "middle_of_the_night") ?: "middle_of_the_night"
        set(value) = prefs.edit().putString("high_lat_rule", value).apply()

    var fajrOffset: Int
        get() = prefs.getInt("offset_fajr", 0)
        set(value) = prefs.edit().putInt("offset_fajr", value).apply()

    var sunriseOffset: Int
        get() = prefs.getInt("offset_sunrise", 0)
        set(value) = prefs.edit().putInt("offset_sunrise", value).apply()

    var dhuhrOffset: Int
        get() = prefs.getInt("offset_dhuhr", 0)
        set(value) = prefs.edit().putInt("offset_dhuhr", value).apply()

    var asrOffset: Int
        get() = prefs.getInt("offset_asr", 0)
        set(value) = prefs.edit().putInt("offset_asr", value).apply()

    var maghribOffset: Int
        get() = prefs.getInt("offset_maghrib", 0)
        set(value) = prefs.edit().putInt("offset_maghrib", value).apply()

    var ishaOffset: Int
        get() = prefs.getInt("offset_isha", 0)
        set(value) = prefs.edit().putInt("offset_isha", value).apply()

    var showEarlyWarning: Boolean
        get() = Settings.System.getInt(resolver, "unica_prayer_times_early_warning", 0) == 1
        set(value) {
            Settings.System.putInt(resolver, "unica_prayer_times_early_warning", if (value) 1 else 0)
            prefs.edit().putBoolean("show_early_warning", value).apply()
        }

    var earlyWarningMinutes: Int
        get() = try {
            Settings.System.getString(resolver, "unica_prayer_times_early_minutes")?.toIntOrNull()
                ?: prefs.getInt("early_warning_minutes", 10)
        } catch (_: Exception) { 10 }
        set(value) {
            Settings.System.putString(resolver, "unica_prayer_times_early_minutes", value.toString())
            prefs.edit().putInt("early_warning_minutes", value).apply()
        }

    var googlePlacesApiKey: String
        get() = prefs.getString("google_places_key", "") ?: ""
        set(value) = prefs.edit().putString("google_places_key", value).apply()

    var cachedTimings: String
        get() = prefs.getString("cached_timings", "") ?: ""
        set(value) = prefs.edit().putString("cached_timings", value).apply()

    var lastFetchTime: Long
        get() = prefs.getLong("last_fetch", 0L)
        set(value) = prefs.edit().putLong("last_fetch", value).apply()

    fun getOffsetsMap(): Map<Prayer, Int> = mapOf(
        Prayer.FAJR to fajrOffset,
        Prayer.SUNRISE to sunriseOffset,
        Prayer.DHUHR to dhuhrOffset,
        Prayer.ASR to asrOffset,
        Prayer.MAGHRIB to maghribOffset,
        Prayer.ISHA to ishaOffset
    )

    fun getMadhab(): Madhab = when (madhabKey.lowercase()) {
        "hanafi" -> Madhab.HANAFI
        else -> Madhab.SHAFI
    }

    fun getHighLatitudeRule(): HighLatitudeRule = when (highLatRuleKey.lowercase()) {
        "seventh_of_the_night" -> HighLatitudeRule.SEVENTH_OF_THE_NIGHT
        "twilight_angle" -> HighLatitudeRule.TWILIGHT_ANGLE
        else -> HighLatitudeRule.MIDDLE_OF_THE_NIGHT
    }

    fun getAdhanSoundKey(prayer: String): String {
        return prefs.getString("adhan_sound_key_${prayer.lowercase()}", "makkah") ?: "makkah"
    }

    fun setAdhanSoundKey(prayer: String, key: String) {
        prefs.edit().putString("adhan_sound_key_${prayer.lowercase()}", key).apply()
    }

    fun getCustomAdhanUri(prayer: String): String? {
        return prefs.getString("custom_adhan_uri_${prayer.lowercase()}", null)
    }

    fun setCustomAdhanUri(prayer: String, uri: String?) {
        prefs.edit().putString("custom_adhan_uri_${prayer.lowercase()}", uri).apply()
    }

    // Compatibility methods for old sound APIs
    fun getSoundForPrayer(prayerName: String): String? {
        return getCustomAdhanUri(prayerName) ?: getAdhanSoundKey(prayerName)
    }

    fun setSoundForPrayer(prayerName: String, uri: String?) {
        setCustomAdhanUri(prayerName, uri)
    }

    companion object {
        @Volatile private var inst: Prefs? = null
        fun get(ctx: Context): Prefs = inst ?: synchronized(this) {
            inst ?: Prefs(ctx.applicationContext).also { inst = it }
        }
    }
}