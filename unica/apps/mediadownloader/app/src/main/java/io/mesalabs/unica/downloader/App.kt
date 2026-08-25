package io.mesalabs.unica.downloader

import android.app.Application
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.provider.Settings
import android.util.Log
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import com.yausername.ffmpeg.FFmpeg
import com.yausername.youtubedl_android.YoutubeDL
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import java.util.concurrent.TimeUnit

class App : Application() {

    val appScope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

    @Volatile
    var libReady = false
        private set

    fun ensureInit(context: Context = this) {
        if (!libReady) {
            synchronized(this) {
                if (!libReady) {
                    try {
                        YoutubeDL.getInstance().init(context.applicationContext)
                        FFmpeg.getInstance().init(context.applicationContext)
                        libReady = true
                        saveYtdlpVersion(context.applicationContext)
                        Log.i(TAG, "YoutubeDL and FFmpeg initialized successfully")
                    } catch (e: Exception) {
                        Log.e(TAG, "yt-dlp/ffmpeg init failed", e)
                    }
                }
            }
        }
    }

    override fun onCreate() {
        super.onCreate()
        instance = this
        createChannels()
        appScope.launch {
            ensureInit(this@App)
        }
        if (Prefs.get(this).autoUpdate) scheduleUpdate()
        if (Prefs.get(this).clipboardMonitor && Prefs.get(this).enabled) {
            ClipboardMonitorService.start(this)
        }
    }

    fun scheduleUpdate() {
        val req = PeriodicWorkRequestBuilder<UpdateWorker>(1, TimeUnit.DAYS).build()
        WorkManager.getInstance(this)
            .enqueueUniquePeriodicWork("ytdlp_update", ExistingPeriodicWorkPolicy.KEEP, req)
    }

    fun cancelUpdate() {
        WorkManager.getInstance(this).cancelUniqueWork("ytdlp_update")
    }

    private fun createChannels() {
        val nm = getSystemService(NotificationManager::class.java)
        nm.createNotificationChannel(
            NotificationChannel(
                CHANNEL_PROGRESS, getString(R.string.channel_progress),
                NotificationManager.IMPORTANCE_LOW
            )
        )
        nm.createNotificationChannel(
            NotificationChannel(
                CHANNEL_DONE, getString(R.string.channel_done),
                NotificationManager.IMPORTANCE_DEFAULT
            )
        )
        // Silent background channel — used for the ongoing "monitoring" notification.
        // Deliberately IMPORTANCE_MIN so it never makes noise or shows as a heads-up.
        nm.createNotificationChannel(
            NotificationChannel(
                CHANNEL_CLIPBOARD_SERVICE, getString(R.string.channel_clipboard_service),
                NotificationManager.IMPORTANCE_MIN
            ).apply { setShowBadge(false) }
        )
        // High-importance channel — used only for the one-shot "tap to download" prompt.
        nm.createNotificationChannel(
            NotificationChannel(
                CHANNEL_CLIPBOARD_PROMPT, getString(R.string.channel_clipboard),
                NotificationManager.IMPORTANCE_HIGH
            )
        )
    }

    companion object {
        const val TAG = "UnicaDownloader"
        const val CHANNEL_PROGRESS = "progress"
        const val CHANNEL_DONE = "done"
        /** Silent persistent channel for the clipboard monitor foreground notification. */
        const val CHANNEL_CLIPBOARD_SERVICE = "clipboard_service"
        /** High-importance channel for the "tap to download" offer notification. */
        const val CHANNEL_CLIPBOARD_PROMPT = "clipboard_prompt"
        // Keep old constant as alias so SettingsActivity string reference still compiles
        const val CHANNEL_CLIPBOARD = CHANNEL_CLIPBOARD_PROMPT
        lateinit var instance: App
            private set

        /** Write the current yt-dlp version to Settings.System for SecSettings to read. */
        fun saveYtdlpVersion(context: Context) {
            try {
                val version = YoutubeDL.getInstance().version(context)
                if (!version.isNullOrBlank()) {
                    Settings.System.putString(
                        context.contentResolver,
                        "unica_dl_ytdlp_version",
                        version
                    )
                }
            } catch (e: Exception) {
                Log.w(TAG, "Could not read yt-dlp version", e)
            }
        }
    }
}
