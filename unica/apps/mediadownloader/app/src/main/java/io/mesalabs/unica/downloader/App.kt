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

    override fun onCreate() {
        super.onCreate()
        instance = this
        createChannels()
        appScope.launch {
            try {
                YoutubeDL.getInstance().init(this@App)
                FFmpeg.getInstance().init(this@App)
                libReady = true
                // Persist current yt-dlp version so SecSettings can display it
                saveYtdlpVersion(this@App)
            } catch (e: Exception) {
                Log.e(TAG, "yt-dlp init failed", e)
            }
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
        nm.createNotificationChannel(
            NotificationChannel(
                CHANNEL_CLIPBOARD, getString(R.string.channel_clipboard),
                NotificationManager.IMPORTANCE_HIGH
            )
        )
    }

    companion object {
        const val TAG = "UnicaDownloader"
        const val CHANNEL_PROGRESS = "progress"
        const val CHANNEL_DONE = "done"
        const val CHANNEL_CLIPBOARD = "clipboard"
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
