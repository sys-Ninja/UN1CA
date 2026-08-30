package io.mesalabs.unica.screentranslator.data

import android.content.Context
import android.graphics.Color
import android.provider.Settings

class TranslatorPrefs private constructor(private val context: Context) {
    private val resolver = context.contentResolver
    private val sp = context.getSharedPreferences("screen_translator_prefs", Context.MODE_PRIVATE)

    var isServiceEnabled: Boolean
        get() = Settings.System.getInt(resolver, "unica_st_service_enabled", 0) == 1
        set(value) { Settings.System.putInt(resolver, "unica_st_service_enabled", if (value) 1 else 0) }

    var sourceLanguage: String
        get() = Settings.System.getString(resolver, "unica_st_source_lang") ?: "auto"
        set(value) { Settings.System.putString(resolver, "unica_st_source_lang", value) }

    var targetLanguage: String
        get() = Settings.System.getString(resolver, "unica_st_target_lang") ?: "ar"
        set(value) { Settings.System.putString(resolver, "unica_st_target_lang", value) }

    var fontSizeSp: Float
        get() = try { Settings.System.getFloat(resolver, "unica_st_font_size") } catch (_: Exception) { 18f }
        set(value) { Settings.System.putFloat(resolver, "unica_st_font_size", value) }

    var textColor: Int
        get() = Settings.System.getInt(resolver, "unica_st_text_color", Color.WHITE)
        set(value) { Settings.System.putInt(resolver, "unica_st_text_color", value) }

    var strokeColor: Int
        get() = Settings.System.getInt(resolver, "unica_st_stroke_color", Color.BLACK)
        set(value) { Settings.System.putInt(resolver, "unica_st_stroke_color", value) }

    var strokeWidth: Float
        get() = try { Settings.System.getFloat(resolver, "unica_st_stroke_width") } catch (_: Exception) { 7f }
        set(value) { Settings.System.putFloat(resolver, "unica_st_stroke_width", value) }

    var showFloatingBubble: Boolean
        get() = Settings.System.getInt(resolver, "unica_st_floating_bubble", 1) == 1
        set(value) { Settings.System.putInt(resolver, "unica_st_floating_bubble", if (value) 1 else 0) }

    var autoTranslateGames: Boolean
        get() = Settings.System.getInt(resolver, "unica_st_auto_games", 1) == 1
        set(value) { Settings.System.putInt(resolver, "unica_st_auto_games", if (value) 1 else 0) }

    var fpsCap: Int
        get() = Settings.System.getInt(resolver, "unica_st_fps_cap", 8)
        set(value) { Settings.System.putInt(resolver, "unica_st_fps_cap", value) }

    companion object {
        @Volatile private var instance: TranslatorPrefs? = null
        fun get(ctx: Context): TranslatorPrefs = instance ?: synchronized(this) {
            instance ?: TranslatorPrefs(ctx.applicationContext).also { instance = it }
        }
    }
}