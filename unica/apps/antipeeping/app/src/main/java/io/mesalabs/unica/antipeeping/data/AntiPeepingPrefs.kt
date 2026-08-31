package io.mesalabs.unica.antipeeping.data

import android.content.Context
import android.provider.Settings

class AntiPeepingPrefs private constructor(private val context: Context) {

    var isEnabled: Boolean
        get() = Settings.System.getInt(context.contentResolver, KEY_ENABLED, 0) == 1
        set(value) {
            Settings.System.putInt(context.contentResolver, KEY_ENABLED, if (value) 1 else 0)
        }

    var actionType: String
        get() = Settings.System.getString(context.contentResolver, KEY_ACTION) ?: ACTION_ALERT
        set(value) {
            Settings.System.putString(context.contentResolver, KEY_ACTION, value)
        }

    var coWatchUntil: Long
        get() = Settings.System.getLong(context.contentResolver, KEY_COWATCH_UNTIL, 0L)
        set(value) {
            Settings.System.putLong(context.contentResolver, KEY_COWATCH_UNTIL, value)
        }

    var isCoWatchActive: Boolean
        get() = System.currentTimeMillis() < coWatchUntil
        set(active) {
            if (active) {
                // Enable for 15 minutes by default
                coWatchUntil = System.currentTimeMillis() + (15 * 60 * 1000L)
            } else {
                coWatchUntil = 0L
            }
        }

    var isAutoPauseVideo: Boolean
        get() = Settings.System.getInt(context.contentResolver, KEY_AUTO_PAUSE_VIDEO, 1) == 1
        set(value) {
            Settings.System.putInt(context.contentResolver, KEY_AUTO_PAUSE_VIDEO, if (value) 1 else 0)
        }

    companion object {
        const val KEY_ENABLED = "unica_anti_peeping_enabled"
        const val KEY_ACTION = "unica_anti_peeping_action"
        const val KEY_COWATCH_UNTIL = "unica_anti_peeping_cowatch_until"
        const val KEY_AUTO_PAUSE_VIDEO = "unica_anti_peeping_auto_pause_video"

        const val ACTION_ALERT = "alert"
        const val ACTION_BLUR = "blur"
        const val ACTION_HAPTIC = "haptic"

        @Volatile
        private var instance: AntiPeepingPrefs? = null

        fun get(context: Context): AntiPeepingPrefs {
            return instance ?: synchronized(this) {
                instance ?: AntiPeepingPrefs(context.applicationContext).also { instance = it }
            }
        }
    }
}