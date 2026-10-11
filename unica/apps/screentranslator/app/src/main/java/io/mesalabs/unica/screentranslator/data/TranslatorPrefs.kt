package io.mesalabs.unica.screentranslator.data

import android.content.Context
import android.graphics.Color
import android.provider.Settings

class TranslatorPrefs private constructor(private val context: Context) {
    private val resolver = context.contentResolver
    private val sp = context.getSharedPreferences("screen_translator_prefs", Context.MODE_PRIVATE)

    var isServiceEnabled: Boolean
        get() = try { Settings.System.getInt(resolver, "unica_st_service_enabled", 0) == 1 } catch (_: Exception) { sp.getBoolean("unica_st_service_enabled", false) }
        set(value) { try { Settings.System.putInt(resolver, "unica_st_service_enabled", if (value) 1 else 0) } catch (_: Exception) { sp.edit().putBoolean("unica_st_service_enabled", value).apply() } }

    var sourceLanguage: String
        get() = try { Settings.System.getString(resolver, "unica_st_source_lang") ?: "auto" } catch (_: Exception) { sp.getString("unica_st_source_lang", "auto") ?: "auto" }
        set(value) { try { Settings.System.putString(resolver, "unica_st_source_lang", value) } catch (_: Exception) { sp.edit().putString("unica_st_source_lang", value).apply() } }

    var targetLanguage: String
        get() = try { Settings.System.getString(resolver, "unica_st_target_lang") ?: "ar" } catch (_: Exception) { sp.getString("unica_st_target_lang", "ar") ?: "ar" }
        set(value) { try { Settings.System.putString(resolver, "unica_st_target_lang", value) } catch (_: Exception) { sp.edit().putString("unica_st_target_lang", value).apply() } }

    var fontSizeSp: Float
        get() = try { Settings.System.getFloat(resolver, "unica_st_font_size") } catch (_: Exception) { sp.getFloat("unica_st_font_size", 18f) }
        set(value) { try { Settings.System.putFloat(resolver, "unica_st_font_size", value) } catch (_: Exception) { sp.edit().putFloat("unica_st_font_size", value).apply() } }

    var textColor: Int
        get() = try { Settings.System.getInt(resolver, "unica_st_text_color", Color.WHITE) } catch (_: Exception) { sp.getInt("unica_st_text_color", Color.WHITE) }
        set(value) { try { Settings.System.putInt(resolver, "unica_st_text_color", value) } catch (_: Exception) { sp.edit().putInt("unica_st_text_color", value).apply() } }

    var strokeColor: Int
        get() = try { Settings.System.getInt(resolver, "unica_st_stroke_color", Color.BLACK) } catch (_: Exception) { sp.getInt("unica_st_stroke_color", Color.BLACK) }
        set(value) { try { Settings.System.putInt(resolver, "unica_st_stroke_color", value) } catch (_: Exception) { sp.edit().putInt("unica_st_stroke_color", value).apply() } }

    var strokeWidth: Float
        get() = try { Settings.System.getFloat(resolver, "unica_st_stroke_width") } catch (_: Exception) { sp.getFloat("unica_st_stroke_width", 7f) }
        set(value) { try { Settings.System.putFloat(resolver, "unica_st_stroke_width", value) } catch (_: Exception) { sp.edit().putFloat("unica_st_stroke_width", value).apply() } }

    var showFloatingBubble: Boolean
        get() = try { Settings.System.getInt(resolver, "unica_st_floating_bubble", 1) == 1 } catch (_: Exception) { sp.getBoolean("unica_st_floating_bubble", true) }
        set(value) { try { Settings.System.putInt(resolver, "unica_st_floating_bubble", if (value) 1 else 0) } catch (_: Exception) { sp.edit().putBoolean("unica_st_floating_bubble", value).apply() } }

    var autoTranslateGames: Boolean
        get() = try { Settings.System.getInt(resolver, "unica_st_auto_games", 1) == 1 } catch (_: Exception) { sp.getBoolean("unica_st_auto_games", true) }
        set(value) { try { Settings.System.putInt(resolver, "unica_st_auto_games", if (value) 1 else 0) } catch (_: Exception) { sp.edit().putBoolean("unica_st_auto_games", value).apply() } }

    var fpsCap: Int
        get() = try { Settings.System.getInt(resolver, "unica_st_fps_cap", 8) } catch (_: Exception) { sp.getInt("unica_st_fps_cap", 8) }
        set(value) { try { Settings.System.putInt(resolver, "unica_st_fps_cap", value) } catch (_: Exception) { sp.edit().putInt("unica_st_fps_cap", value).apply() } }

    companion object {
        @Volatile private var instance: TranslatorPrefs? = null
        fun get(ctx: Context): TranslatorPrefs = instance ?: synchronized(this) {
            instance ?: TranslatorPrefs(ctx.applicationContext).also { instance = it }
        }
    }
}
