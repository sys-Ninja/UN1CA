package io.mesalabs.unica.secretspace

import android.content.Context
import android.content.SharedPreferences

class Prefs private constructor(context: Context) {

    private val prefs: SharedPreferences =
        context.applicationContext.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    var isEnabled: Boolean
        get() = prefs.getBoolean(KEY_ENABLED, false)
        set(value) = prefs.edit().putBoolean(KEY_ENABLED, value).apply()

    var secretUserId: Int
        get() = prefs.getInt(KEY_SECRET_USER_ID, -1)
        set(value) = prefs.edit().putInt(KEY_SECRET_USER_ID, value).apply()

    var selectedFingerprintId: Int
        get() = prefs.getInt(KEY_FINGERPRINT_ID, -1)
        set(value) = prefs.edit().putInt(KEY_FINGERPRINT_ID, value).apply()

    var selectedFingerprintName: String
        get() = prefs.getString(KEY_FINGERPRINT_NAME, "") ?: ""
        set(value) = prefs.edit().putString(KEY_FINGERPRINT_NAME, value).apply()

    var isolateNetwork: Boolean
        get() = prefs.getBoolean(KEY_ISOLATE_NETWORK, false)
        set(value) = prefs.edit().putBoolean(KEY_ISOLATE_NETWORK, value).apply()

    var lockOnScreenOff: Boolean
        get() = prefs.getBoolean(KEY_LOCK_ON_SCREEN_OFF, true)
        set(value) = prefs.edit().putBoolean(KEY_LOCK_ON_SCREEN_OFF, value).apply()

    companion object {
        private const val PREFS_NAME = "unica_secret_space_prefs"
        private const val KEY_ENABLED = "key_enabled"
        private const val KEY_SECRET_USER_ID = "key_secret_user_id"
        private const val KEY_FINGERPRINT_ID = "key_fingerprint_id"
        private const val KEY_FINGERPRINT_NAME = "key_fingerprint_name"
        private const val KEY_ISOLATE_NETWORK = "key_isolate_network"
        private const val KEY_LOCK_ON_SCREEN_OFF = "key_lock_on_screen_off"

        @Volatile
        private var instance: Prefs? = null

        fun get(context: Context): Prefs =
            instance ?: synchronized(this) {
                instance ?: Prefs(context).also { instance = it }
            }
    }
}
