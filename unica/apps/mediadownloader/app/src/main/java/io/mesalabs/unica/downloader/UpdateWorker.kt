package io.mesalabs.unica.downloader

import android.content.Context
import android.util.Log
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import com.yausername.youtubedl_android.YoutubeDL

class UpdateWorker(ctx: Context, params: WorkerParameters) : CoroutineWorker(ctx, params) {

    override suspend fun doWork(): Result {
        return try {
            YoutubeDL.getInstance()
                .updateYoutubeDL(applicationContext, YoutubeDL.UpdateChannel.NIGHTLY)
            Prefs.get(applicationContext).lastUpdateCheck = System.currentTimeMillis()
            Result.success()
        } catch (e: Exception) {
            Log.w(App.TAG, "yt-dlp update failed", e)
            Result.retry()
        }
    }
}
