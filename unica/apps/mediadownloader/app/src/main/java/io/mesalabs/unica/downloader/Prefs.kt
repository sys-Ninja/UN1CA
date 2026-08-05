package io.mesalabs.unica.downloader

import android.content.Context
import android.content.SharedPreferences
import android.os.Environment
import java.io.File

class Prefs private constructor(private val sp: SharedPreferences) {

    var enabled: Boolean
        get() = sp.getBoolean("enabled", true)
        set(v) = sp.edit().putBoolean("enabled", v).apply()

    var autoUpdate: Boolean
        get() = sp.getBoolean("auto_update", true)
        set(v) = sp.edit().putBoolean("auto_update", v).apply()

    var clipboardMonitor: Boolean
        get() = sp.getBoolean("clipboard_monitor", true)
        set(v) = sp.edit().putBoolean("clipboard_monitor", v).apply()

    var organizePlaylists: Boolean
        get() = sp.getBoolean("organize_playlists", true)
        set(v) = sp.edit().putBoolean("organize_playlists", v).apply()

    /** "best", "1080", "720", "480" */
    var defaultQuality: String
        get() = sp.getString("default_quality", "best")!!
        set(v) = sp.edit().putString("default_quality", v).apply()

    /** "video" or "audio" */
    var defaultType: String
        get() = sp.getString("default_type", "video")!!
        set(v) = sp.edit().putString("default_type", v).apply()

    var downloadDir: String
        get() = sp.getString("download_dir", defaultDir())!!
        set(v) = sp.edit().putString("download_dir", v).apply()

    var lastUpdateCheck: Long
        get() = sp.getLong("last_update_check", 0L)
        set(v) = sp.edit().putLong("last_update_check", v).apply()

    var lastClipboardHash: Int
        get() = sp.getInt("last_clip_hash", 0)
        set(v) = sp.edit().putInt("last_clip_hash", v).apply()

    companion object {
        @Volatile private var inst: Prefs? = null

        fun get(ctx: Context): Prefs = inst ?: synchronized(this) {
            inst ?: Prefs(ctx.getSharedPreferences("downloader", Context.MODE_PRIVATE))
                .also { inst = it }
        }

        fun defaultDir(): String =
            File(Environment.getExternalStorageDirectory(), "MediaDownloads").absolutePath
    }
}
