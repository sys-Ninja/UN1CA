package io.mesalabs.unica.prayertimes

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.net.Uri
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat

class AdhanService : Service() {

    private var mediaPlayer: MediaPlayer? = null
    private val ACTION_STOP = "io.mesalabs.unica.prayertimes.STOP"

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP) {
            stopSelf()
            return START_NOT_STICKY
        }

        val prayerName = intent?.getStringExtra("PRAYER_NAME") ?: "Unknown"
        startForeground(1003, createNotification(prayerName))
        playAdhan(prayerName)

        return START_NOT_STICKY
    }

    private fun playAdhan(prayerName: String) {
        val prefs = Prefs.get(this)
        val soundUriStr = prefs.getSoundForPrayer(prayerName)

        try {
            mediaPlayer = MediaPlayer().apply {
                val uri = if (soundUriStr != null) Uri.parse(soundUriStr)
                          else android.provider.Settings.System.DEFAULT_ALARM_ALERT_URI
                setDataSource(this@AdhanService, uri)
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .build()
                )
                prepare()
                start()
                setOnCompletionListener {
                    stopSelf()
                }
            }
        } catch (e: Exception) {
            Log.e(PrayerManager.TAG, "Failed to play Adhan", e)
            stopSelf()
        }
    }

    private fun createNotification(prayerName: String): Notification {
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channelId = "prayer_adhan_channel"
        
        nm.createNotificationChannel(
            NotificationChannel(
                channelId,
                getString(R.string.channel_adhan),
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                setSound(null, null) // Handled by MediaPlayer
            }
        )

        val stopIntent = PendingIntent.getService(
            this, 0,
            Intent(this, AdhanService::class.java).setAction(ACTION_STOP),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val prayerLocalName = when(prayerName) {
            "Fajr" -> getString(R.string.prayer_fajr)
            "Dhuhr" -> getString(R.string.prayer_dhuhr)
            "Asr" -> getString(R.string.prayer_asr)
            "Maghrib" -> getString(R.string.prayer_maghrib)
            "Isha" -> getString(R.string.prayer_isha)
            else -> prayerName
        }

        return NotificationCompat.Builder(this, channelId)
            .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
            .setContentTitle(getString(R.string.notification_adhan_title, prayerLocalName))
            .setContentText(getString(R.string.notification_adhan_text))
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setOngoing(true)
            .addAction(0, getString(R.string.stop_adhan), stopIntent)
            .build()
    }

    override fun onDestroy() {
        mediaPlayer?.release()
        mediaPlayer = null
        super.onDestroy()
    }
}
