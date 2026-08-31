package io.mesalabs.unica.screentranslator

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import io.mesalabs.unica.screentranslator.data.TranslatorPrefs
import io.mesalabs.unica.screentranslator.service.ScreenTranslatorService

class ScreenTranslatorReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        val prefs = TranslatorPrefs.get(context)

        if (action == "io.mesalabs.unica.screentranslator.TOGGLE_SERVICE" ||
            action == Intent.ACTION_BOOT_COMPLETED) {
            
            if (prefs.isServiceEnabled) {
                val serviceIntent = Intent(context, ScreenTranslatorService::class.java)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(serviceIntent)
                } else {
                    context.startService(serviceIntent)
                }
            } else {
                val stopIntent = Intent(context, ScreenTranslatorService::class.java).apply {
                    this.action = ScreenTranslatorService.ACTION_STOP
                }
                context.startService(stopIntent)
            }
        }
    }
}