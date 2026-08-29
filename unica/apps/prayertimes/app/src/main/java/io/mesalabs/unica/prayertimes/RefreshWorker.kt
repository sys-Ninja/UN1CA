package io.mesalabs.unica.prayertimes

import android.content.Context
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters

class RefreshWorker(ctx: Context, params: WorkerParameters) : CoroutineWorker(ctx, params) {

    override suspend fun doWork(): Result {
        val prefs = Prefs.get(applicationContext)
        if (prefs.isEnabled && prefs.useOnlineApi) {
            PrayerManager.fetchAndCacheTimings(applicationContext)
        }
        PrayerManager.scheduleNextPrayer(applicationContext)
        return Result.success()
    }
}