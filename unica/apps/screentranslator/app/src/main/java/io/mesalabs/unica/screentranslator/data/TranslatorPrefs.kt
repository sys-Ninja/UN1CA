package io.mesalabs.unica.screentranslator.data

import android.content.Context
import android.content.SharedPreferences
import android.graphics.Color

class TranslatorPrefs private constructor(context: Context) {
    private val prefs: SharedPreferences = context.getSharedPreferences("screen_translator_prefs", Context.MODE_PRIVATE)

    var isServiceEnabled: Boolean
        get() = prefs.getBoolean("service_enabled", false)
        set(value) = prefs.edit().putBoolean("service_enabled", value).apply()

    var sourceLanguage: String
        get() = prefs.getString("source_language", "auto") ?: "auto"
        set(value) = prefs.edit().putString("source_language", value).apply()

    var targetLanguage: String
        get() = prefs.getString("target_language", "ar") ?: "ar"
        set(value) = prefs.edit().putString("target_language", value).apply()

    var fontSizeSp: Float
        get() = prefs.getFloat("font_size_sp", 18f)
        set(value) = prefs.edit().putFloat("font_size_sp", value).apply()

    var textColor: Int
        get() = prefs.getInt("text_color", Color.WHITE)
        set(value) = prefs.edit().putInt("text_color", value).apply()

    var strokeColor: Int
        get() = prefs.getInt("stroke_color", Color.BLACK)
        set(value) = prefs.edit().putInt("stroke_color", value).apply()

    var strokeWidth: Float
        get() = prefs.getFloat("stroke_width", 7f)
        set(value) = prefs.edit().putFloat("stroke_width", value).apply()

    var showFloatingBubble: Boolean
        get() = prefs.getBoolean("show_floating_bubble", true)
        set(value) = prefs.edit().putBoolean("show_floating_bubble", value).apply()

    var autoTranslateGames: Boolean
        get() = prefs.getBoolean("auto_translate_games", true)
        set(value) = prefs.edit().putBoolean("auto_translate_games", value).apply()

    var fpsCap: Int
        get() = prefs.getInt("fps_cap", 8)
        set(value) = prefs.edit().putInt("fps_cap", value).apply()

    companion object {
        @Volatile private var instance: TranslatorPrefs? = null
        fun get(ctx: Context): TranslatorPrefs = instance ?: synchronized(this) {
            instance ?: TranslatorPrefs(ctx.applicationContext).also { instance = it }
        }
    }
}