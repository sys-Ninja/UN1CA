package io.mesalabs.unica.downloader

import android.content.Context
import android.content.SharedPreferences
import android.os.Environment
import android.provider.Settings
import java.io.File

class Prefs private constructor(private val ctx: Context) {

    private val resolver = ctx.contentResolver

    // App-private SharedPreferences for values that must NOT go through
    // Settings.System (avoids WRITE_SETTINGS SecurityException on Android 14+)
    private val sp: SharedPreferences =
        ctx.getSharedPreferences("unica_dl_prefs", Context.MODE_PRIVATE)

    var enabled: Boolean
        get() = Settings.System.getInt(resolver, "unica_dl_enabled", 1) == 1
        set(v) = Settings.System.putInt(resolver, "unica_dl_enabled", if (v) 1 else 0).let { }

    var autoUpdate: Boolean
        get() = Settings.System.getInt(resolver, "unica_dl_auto_update", 1) == 1
        set(v) = Settings.System.putInt(resolver, "unica_dl_auto_update", if (v) 1 else 0).let { }

    var clipboardMonitor: Boolean
        get() = Settings.System.getInt(resolver, "unica_dl_clipboard", 1) == 1
        set(v) = Settings.System.putInt(resolver, "unica_dl_clipboard", if (v) 1 else 0).let { }

    var organizePlaylists: Boolean
        get() = Settings.System.getInt(resolver, "unica_dl_organize_playlists", 1) == 1
        set(v) = Settings.System.putInt(resolver, "unica_dl_organize_playlists", if (v) 1 else 0).let { }

    /** "best", "1080", "720", "480" */
    var defaultQuality: String
        get() = Settings.System.getString(resolver, "unica_dl_default_quality") ?: "best"
        set(v) = Settings.System.putString(resolver, "unica_dl_default_quality", v).let { }

    /** "video" or "audio" */
    var defaultType: String
        get() = Settings.System.getString(resolver, "unica_dl_default_type") ?: "video"
        set(v) = Settings.System.putString(resolver, "unica_dl_default_type", v).let { }

    var downloadDir: String
        get() = Settings.System.getString(resolver, "unica_dl_download_dir") ?: defaultDir()
        set(v) = Settings.System.putString(resolver, "unica_dl_download_dir", v).let { }

    var lastUpdateCheck: Long
        get() = Settings.System.getLong(resolver, "unica_dl_last_update_check", 0L)
        set(v) = Settings.System.putLong(resolver, "unica_dl_last_update_check", v).let { }

    // Stored in private SharedPreferences — NOT Settings.System — to avoid
    // WRITE_SETTINGS SecurityException that silently aborts the clipboard listener.
    var lastClipboardHash: Int
        get() = sp.getInt("last_clip_hash", 0)
        set(v) = sp.edit().putInt("last_clip_hash", v).apply()

    companion object {
        @Volatile private var inst: Prefs? = null

        fun get(ctx: Context): Prefs = inst ?: synchronized(this) {
            inst ?: Prefs(ctx.applicationContext).also { inst = it }
        }

        fun defaultDir(): String =
            File(Environment.getExternalStorageDirectory(), "MediaDownloads").absolutePath
    }
}
