package io.mesalabs.unica.prayertimes

import android.app.Application
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import java.util.Calendar
import java.util.concurrent.TimeUnit

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        instance = this
        createChannels()
        scheduleMidnightRefresh()
    }

    /** Schedule a WorkManager job to refresh timings every night at midnight */
    private fun scheduleMidnightRefresh() {
        // Calculate delay until next midnight + 5 min buffer
        val now = Calendar.getInstance()
        val midnight = Calendar.getInstance().apply {
            add(Calendar.DAY_OF_MONTH, 1)
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 5)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }
        val initialDelay = midnight.timeInMillis - now.timeInMillis

        val req = PeriodicWorkRequestBuilder<RefreshWorker>(1, TimeUnit.DAYS)
            .setInitialDelay(initialDelay, TimeUnit.MILLISECONDS)
            .build()

        WorkManager.getInstance(this).enqueueUniquePeriodicWork(
            "prayer_refresh",
            ExistingPeriodicWorkPolicy.KEEP,
            req
        )
    }

    private fun createChannels() {
        val nm = getSystemService(NotificationManager::class.java)
        nm.createNotificationChannel(
            NotificationChannel(
                "prayer_adhan_channel",
                getString(R.string.channel_adhan),
                NotificationManager.IMPORTANCE_HIGH
            ).apply { setSound(null, null) }
        )
    }

    companion object {
        lateinit var instance: App
            private set
    }
}
