package io.mesalabs.unica.downloader

import android.app.Notification
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.graphics.drawable.toBitmap
import coil.ImageLoader
import coil.request.ErrorResult
import coil.request.ImageRequest
import coil.request.SuccessResult
import com.yausername.youtubedl_android.YoutubeDL
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File
import java.util.concurrent.atomic.AtomicBoolean

class DownloadService : Service() {

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)
    private val working = AtomicBoolean(false)
    private lateinit var nm: NotificationManager

    override fun onCreate() {
        super.onCreate()
        nm = getSystemService(NotificationManager::class.java)
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_CANCEL -> {
                intent.getStringExtra(EXTRA_ID)?.let { id ->
                    try {
                        YoutubeDL.getInstance().destroyProcessById(id)
                    } catch (e: Exception) {
                        Log.w(App.TAG, "cancel failed", e)
                    }
                    DownloadRepo.update(id) { it.status = DlStatus.CANCELLED }
                    nm.cancel(id.hashCode())
                }
            }
            else -> {
                startForeground(FG_ID, baseNotification(getString(R.string.notif_preparing)))
                pump()
            }
        }
        return START_NOT_STICKY
    }

    private fun pump() {
        if (!working.compareAndSet(false, true)) return
        scope.launch {
            try {
                while (true) {
                    val item = DownloadRepo.nextQueued() ?: break
                    runDownload(item)
                }
            } finally {
                working.set(false)
                stopForeground(STOP_FOREGROUND_REMOVE)
                stopSelf()
            }
        }
    }

    /** Load thumbnail bitmap from URL using Coil (best-effort, null on failure). */
    private suspend fun loadThumbnail(url: String?): Bitmap? {
        if (url.isNullOrBlank()) return null
        return try {
            val loader = ImageLoader(this@DownloadService)
            val req = ImageRequest.Builder(this@DownloadService)
                .data(url)
                .allowHardware(false)
                .size(256, 256)
                .build()
            when (val result = loader.execute(req)) {
                is SuccessResult -> result.drawable.toBitmap()
                is ErrorResult -> null
            }
        } catch (e: Exception) {
            Log.w(App.TAG, "thumbnail load failed", e)
            null
        }
    }

    private fun runDownload(item: DownloadItem) {
        DownloadRepo.update(item.id) { it.status = DlStatus.RUNNING }
        notifyProgress(item.id, item.title, 0f, "", null)

        // Load thumbnail once before download starts (IO dispatcher already active)
        var thumb: Bitmap? = null
        scope.launch {
            thumb = loadThumbnail(item.thumbnail)
            notifyProgress(item.id, item.title, 0f, "", thumb)
        }

        var attempt = 0
        while (true) {
            try {
                val request = DownloadRepo.buildRequest(this, item)
                val resp = YoutubeDL.getInstance()
                    .execute(request, item.id) { progress, etaSec, line ->
                        DownloadRepo.update(item.id) {
                            it.progress = progress
                            it.etaSeconds = etaSec
                            it.line = line
                        }
                        notifyProgress(item.id, item.title, progress, line, thumb)
                    }
                Log.i(App.TAG, "done ${item.id}: ${resp.elapsedTime}ms")
                DownloadRepo.update(item.id) {
                    it.status = DlStatus.DONE
                    it.progress = 100f
                    it.filePath = guessFile(item)
                }
                notifyDone(item, thumb)
                return
            } catch (e: YoutubeDL.CanceledException) {
                DownloadRepo.update(item.id) { it.status = DlStatus.CANCELLED }
                nm.cancel(item.id.hashCode())
                return
            } catch (e: Exception) {
                Log.e(App.TAG, "download failed (attempt $attempt)", e)
                if (attempt == 0) {
                    attempt = 1
                    try {
                        YoutubeDL.getInstance()
                            .updateYoutubeDL(this, YoutubeDL.UpdateChannel.NIGHTLY)
                        Prefs.get(this).lastUpdateCheck = System.currentTimeMillis()
                        continue
                    } catch (u: Exception) {
                        Log.w(App.TAG, "recovery update failed", u)
                    }
                }
                DownloadRepo.update(item.id) {
                    it.status = DlStatus.FAILED
                    it.error = e.message
                }
                notifyFailed(item)
                return
            }
        }
    }

    private fun guessFile(item: DownloadItem): String? {
        val prefs = Prefs.get(this)
        val dir = if (item.playlistTitle != null && prefs.organizePlaylists)
            File(prefs.downloadDir, DownloadRepo.sanitize(item.playlistTitle))
        else File(prefs.downloadDir)
        return dir.listFiles()?.maxByOrNull { it.lastModified() }?.absolutePath
    }

    private fun baseNotification(text: String): Notification =
        NotificationCompat.Builder(this, App.CHANNEL_PROGRESS)
            .setSmallIcon(android.R.drawable.stat_sys_download)
            .setContentTitle(getString(R.string.app_name))
            .setContentText(text)
            .setOngoing(true)
            .build()

    private fun notifyProgress(id: String, title: String, progress: Float, line: String, thumb: Bitmap?) {
        val cancelIntent = PendingIntent.getService(
            this, id.hashCode(),
            Intent(this, DownloadService::class.java)
                .setAction(ACTION_CANCEL).putExtra(EXTRA_ID, id),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val indeterminate = progress < 0f
        val builder = NotificationCompat.Builder(this, App.CHANNEL_PROGRESS)
            .setSmallIcon(android.R.drawable.stat_sys_download)
            .setContentTitle(title)
            .setContentText(line.take(60))
            .setProgress(100, progress.toInt().coerceIn(0, 100), indeterminate)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .addAction(0, getString(R.string.cancel), cancelIntent)
        if (thumb != null) {
            builder.setLargeIcon(thumb)
        }
        nm.notify(id.hashCode(), builder.build())
    }

    private fun notifyDone(item: DownloadItem, thumb: Bitmap?) {
        val open = PendingIntent.getActivity(
            this, item.id.hashCode(),
            Intent(this, DownloadsActivity::class.java),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val builder = NotificationCompat.Builder(this, App.CHANNEL_DONE)
            .setSmallIcon(android.R.drawable.stat_sys_download_done)
            .setContentTitle(getString(R.string.notif_done))
            .setContentText(item.title)
            .setContentIntent(open)
            .setAutoCancel(true)
        if (thumb != null) {
            builder.setLargeIcon(thumb)
        }
        nm.notify(item.id.hashCode(), builder.build())
    }

    private fun notifyFailed(item: DownloadItem) {
        val open = PendingIntent.getActivity(
            this, item.id.hashCode(),
            Intent(this, DownloadsActivity::class.java),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val n = NotificationCompat.Builder(this, App.CHANNEL_DONE)
            .setSmallIcon(android.R.drawable.stat_notify_error)
            .setContentTitle(getString(R.string.notif_failed))
            .setContentText(getString(R.string.extract_failed))
            .setContentIntent(open)
            .setAutoCancel(true)
            .build()
        nm.notify(item.id.hashCode(), n)
    }

    companion object {
        private const val FG_ID = 1001
        const val ACTION_CANCEL = "io.mesalabs.unica.downloader.CANCEL"
        const val EXTRA_ID = "id"

        fun enqueue(ctx: Context, item: DownloadItem) {
            DownloadRepo.add(item)
            ctx.startForegroundService(Intent(ctx, DownloadService::class.java))
        }
    }
}