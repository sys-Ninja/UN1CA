package io.mesalabs.unica.prayertimes

import android.content.Context
import android.util.Log
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class RefreshWorker(ctx: Context, params: WorkerParameters) : CoroutineWorker(ctx, params) {
    override suspend fun doWork(): Result {
        return withContext(Dispatchers.IO) {
            val success = PrayerManager.fetchAndCacheTimings(applicationContext)
            if (success) {
                // Re-schedule next prayer with the fresh data
                PrayerManager.scheduleNextPrayer(applicationContext)
                Log.i(PrayerManager.TAG, "Midnight refresh: timings fetched and next alarm set")
                Result.success()
            } else {
                Log.w(PrayerManager.TAG, "Midnight refresh failed, retrying later")
                Result.retry()
            }
        }
    }
}
