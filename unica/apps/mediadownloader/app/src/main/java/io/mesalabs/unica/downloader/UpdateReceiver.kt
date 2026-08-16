package io.mesalabs.unica.downloader

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast
import com.yausername.youtubedl_android.YoutubeDL
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class UpdateReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == "io.mesalabs.unica.downloader.UPDATE_YTDLP") {
            val pendingResult = goAsync()
            CoroutineScope(Dispatchers.IO).launch {
                val ok = try {
                    YoutubeDL.getInstance().updateYoutubeDL(context, YoutubeDL.UpdateChannel.NIGHTLY)
                    Prefs.get(context).lastUpdateCheck = System.currentTimeMillis()
                    App.saveYtdlpVersion(context)
                    true
                } catch (e: Exception) {
                    false
                }
                withContext(Dispatchers.Main) {
                    Toast.makeText(context, if (ok) R.string.update_ok else R.string.update_failed, Toast.LENGTH_SHORT).show()
                    pendingResult.finish()
                }
            }
        }
    }
}
