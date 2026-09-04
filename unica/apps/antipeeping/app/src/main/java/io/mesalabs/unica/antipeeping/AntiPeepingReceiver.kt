package io.mesalabs.unica.antipeeping

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import io.mesalabs.unica.antipeeping.data.AntiPeepingPrefs
import io.mesalabs.unica.antipeeping.service.AntiPeepingService
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class AntiPeepingReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        val prefs = AntiPeepingPrefs.get(context)

        if (action == "io.mesalabs.unica.antipeeping.TOGGLE_SERVICE" ||
            action == Intent.ACTION_BOOT_COMPLETED) {

            // goAsync() extends the BroadcastReceiver window beyond the 10 s ANR limit
            // and – crucially on Android 14+ – moves the startForegroundService() call
            // outside the strict "background-restricted" BroadcastReceiver context,
            // preventing ForegroundServiceStartNotAllowedException.
            val pendingResult = goAsync()
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    if (prefs.isEnabled) {
                        val serviceIntent = Intent(context, AntiPeepingService::class.java)
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            context.startForegroundService(serviceIntent)
                        } else {
                            context.startService(serviceIntent)
                        }
                    } else {
                        val stopIntent = Intent(context, AntiPeepingService::class.java)
                        context.stopService(stopIntent)
                    }
                } finally {
                    pendingResult.finish()
                }
            }
        }
    }
}
