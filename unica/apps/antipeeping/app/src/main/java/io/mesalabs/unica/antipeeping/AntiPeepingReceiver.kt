package io.mesalabs.unica.antipeeping

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import io.mesalabs.unica.antipeeping.data.AntiPeepingPrefs
import io.mesalabs.unica.antipeeping.service.AntiPeepingService

class AntiPeepingReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        val prefs = AntiPeepingPrefs.get(context)

        if (action == "io.mesalabs.unica.antipeeping.TOGGLE_SERVICE" ||
            action == Intent.ACTION_BOOT_COMPLETED) {

            if (prefs.isEnabled) {
                val serviceIntent = Intent(context, AntiPeepingService::class.java)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(serviceIntent)
                } else {
                    context.startService(serviceIntent)
                }
            } else {
                // stopService() works from background receivers (no restriction on Android 14+)
                // avoids BackgroundServiceStartNotAllowedException from startService()
                val stopIntent = Intent(context, AntiPeepingService::class.java)
                context.stopService(stopIntent)
            }
        }
    }
}
