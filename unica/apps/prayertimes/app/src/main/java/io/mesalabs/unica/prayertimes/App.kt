package io.mesalabs.unica.prayertimes

import android.app.Application
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import java.util.concurrent.TimeUnit

class App : Application() {

    override fun onCreate() {
        super.onCreate()

        // Immediate sync on startup
        val immediateRequest = OneTimeWorkRequestBuilder<RefreshWorker>().build()
        WorkManager.getInstance(this).enqueue(immediateRequest)

        // Schedule periodic refresh worker (every 24 hours)
        val refreshRequest = PeriodicWorkRequestBuilder<RefreshWorker>(24, TimeUnit.HOURS)
            .build()
        WorkManager.getInstance(this).enqueueUniquePeriodicWork(
            "PrayerTimesRefresh",
            ExistingPeriodicWorkPolicy.KEEP,
            refreshRequest
        )
    }
}
