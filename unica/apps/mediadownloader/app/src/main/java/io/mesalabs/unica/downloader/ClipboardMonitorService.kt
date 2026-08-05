package io.mesalabs.unica.downloader

import android.app.Notification
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.IBinder
import android.util.Log
import android.util.Patterns
import androidx.core.app.NotificationCompat

class ClipboardMonitorService : Service() {

    private var cm: ClipboardManager? = null

    private val listener = ClipboardManager.OnPrimaryClipChangedListener {
        try {
            val clip = cm?.primaryClip ?: return@OnPrimaryClipChangedListener
            if (clip.itemCount == 0) return@OnPrimaryClipChangedListener
            val text = clip.getItemAt(0).coerceToText(this).toString()
            val url = firstMediaUrl(text) ?: return@OnPrimaryClipChangedListener
            val prefs = Prefs.get(this)
            val hash = url.hashCode()
            if (hash == prefs.lastClipboardHash) return@OnPrimaryClipChangedListener
            prefs.lastClipboardHash = hash
            offerDownload(url)
        } catch (e: Exception) {
            Log.w(App.TAG, "clipboard read failed", e)
        }
    }

    override fun onCreate() {
        super.onCreate()
        cm = getSystemService(ClipboardManager::class.java)
        try {
            cm?.addPrimaryClipChangedListener(listener)
        } catch (e: Exception) {
            Log.w(App.TAG, "clipboard listener failed", e)
            stopSelf()
        }
    }

    override fun onDestroy() {
        try {
            cm?.removePrimaryClipChangedListener(listener)
        } catch (e: Exception) {
            Log.w(App.TAG, "listener remove failed", e)
        }
        super.onDestroy()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int = START_STICKY

    override fun onBind(intent: Intent?): IBinder? = null

    private fun firstMediaUrl(text: String): String? {
        val m = Patterns.WEB_URL.matcher(text)
        while (m.find()) {
            val u = m.group()
            if (!u.startsWith("http")) continue
            val host = try { Uri.parse(u).host?.lowercase() ?: "" } catch (e: Exception) { "" }
            if (MEDIA_HOSTS.any { host == it || host.endsWith(".$it") }) return u
        }
        return null
    }

    private fun offerDownload(url: String) {
        val pi = PendingIntent.getActivity(
            this, url.hashCode(),
            Intent(this, QuickDownloadActivity::class.java)
                .setAction(Intent.ACTION_VIEW)
                .setData(Uri.parse(url))
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val n: Notification = NotificationCompat.Builder(this, App.CHANNEL_CLIPBOARD)
            .setSmallIcon(android.R.drawable.stat_sys_download)
            .setContentTitle(getString(R.string.clip_notif_title))
            .setContentText(url)
            .setContentIntent(pi)
            .setAutoCancel(true)
            .setTimeoutAfter(60_000)
            .build()
        getSystemService(NotificationManager::class.java).notify(url.hashCode(), n)
    }

    companion object {
        private val MEDIA_HOSTS = listOf(
            "youtube.com", "youtu.be", "m.youtube.com",
            "tiktok.com", "vm.tiktok.com",
            "facebook.com", "fb.watch", "m.facebook.com",
            "instagram.com",
            "twitter.com", "x.com",
        )

        fun start(ctx: Context) {
            try {
                ctx.startService(Intent(ctx, ClipboardMonitorService::class.java))
            } catch (e: Exception) {
                Log.w(App.TAG, "clipboard service start failed", e)
            }
        }

        fun stop(ctx: Context) {
            ctx.stopService(Intent(ctx, ClipboardMonitorService::class.java))
        }
    }
}
