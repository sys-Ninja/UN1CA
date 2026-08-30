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
    // In-memory cache of the last seen URL hash — avoids any Settings.System writes
    // and ensures the listener never crashes with a SecurityException.
    private var lastHashInMemory: Int = 0

    private val listener = ClipboardManager.OnPrimaryClipChangedListener {
        try {
            val clip = cm?.primaryClip ?: return@OnPrimaryClipChangedListener
            if (clip.itemCount == 0) return@OnPrimaryClipChangedListener
            val text = clip.getItemAt(0).coerceToText(this).toString()
            val url = firstMediaUrl(text) ?: return@OnPrimaryClipChangedListener
            val hash = url.hashCode()
            // Use in-memory hash first; also check persisted hash to survive service restarts
            val prefs = Prefs.get(this)
            if (hash == lastHashInMemory || hash == prefs.lastClipboardHash) return@OnPrimaryClipChangedListener
            lastHashInMemory = hash
            prefs.lastClipboardHash = hash   // SharedPreferences write — safe, no SecurityException
            offerDownload(url)
        } catch (e: Exception) {
            Log.w(App.TAG, "clipboard read failed", e)
        }
    }

    override fun onCreate() {
        super.onCreate()
        // Run as foreground on the SILENT service channel so Android doesn't kill us,
        // but without making any noise or showing a heads-up.
        val stopIntent = PendingIntent.getService(
            this, 0,
            Intent(this, ClipboardMonitorService::class.java).setAction(ACTION_STOP),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val n = NotificationCompat.Builder(this, App.CHANNEL_CLIPBOARD_SERVICE)
            .setSmallIcon(android.R.drawable.stat_sys_download)
            .setContentTitle(getString(R.string.app_name))
            .setContentText(getString(R.string.clip_monitor_running))
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_MIN)
            .addAction(0, getString(R.string.clip_monitor_stop), stopIntent)
            .build()
        startForeground(FOREGROUND_ID, n)
        cm = getSystemService(ClipboardManager::class.java)
        try {
            cm?.addPrimaryClipChangedListener(listener)
        } catch (e: Exception) {
            Log.w(App.TAG, "clipboard listener failed", e)
            stopSelf()
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP) {
            // User tapped "Stop" in the notification — honour it and update the pref
            Prefs.get(this).clipboardMonitor = false
            stopSelf()
            return START_NOT_STICKY
        }
        return START_STICKY
    }

    override fun onDestroy() {
        try {
            cm?.removePrimaryClipChangedListener(listener)
        } catch (e: Exception) {
            Log.w(App.TAG, "listener remove failed", e)
        }
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

        private fun firstMediaUrl(text: String): String? {
        val prefs = Prefs.get(this)
        val m = Patterns.WEB_URL.matcher(text)
        while (m.find()) {
            var u = m.group() ?: continue
            if (!u.startsWith("http")) continue
            u = u.trimEnd('.', ',', '!', '?', ';', ')', ']')
            if (prefs.universalExtractor) return u
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
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val n: Notification = NotificationCompat.Builder(this, App.CHANNEL_CLIPBOARD_PROMPT)
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
        private const val FOREGROUND_ID = 1002
        const val ACTION_STOP = "io.mesalabs.unica.downloader.STOP_CLIPBOARD_MONITOR"

        val MEDIA_HOSTS = listOf(
            // Google / YouTube
            "youtube.com", "youtu.be", "m.youtube.com",
            // Meta
            "facebook.com", "fb.watch", "m.facebook.com", "instagram.com",
            // TikTok — all known short-link and regional domains
            "tiktok.com", "vm.tiktok.com", "vt.tiktok.com",
            // Twitter / X
            "twitter.com", "x.com",
            // Dailymotion
            "dailymotion.com", "dai.ly",
            // Vimeo
            "vimeo.com",
            // Reddit
            "reddit.com", "v.redd.it",
            // Twitch
            "twitch.tv",
            // Pornhub
            "pornhub.com",
            // XVideos
            "xvideos.com",
            // XNXX
            "xnxx.com",
            // RedTube
            "redtube.com",
            // xHamster
            "xhamster.com",
            // YouPorn
            "youporn.com",
            // SoundCloud (audio)
            "soundcloud.com",
            // Bilibili
            "bilibili.com",
        )

        fun start(ctx: Context) {
            try {
                ctx.startForegroundService(Intent(ctx, ClipboardMonitorService::class.java))
            } catch (e: Exception) {
                Log.w(App.TAG, "clipboard service start failed", e)
            }
        }

        fun stop(ctx: Context) {
            ctx.stopService(Intent(ctx, ClipboardMonitorService::class.java))
        }
    }
}
