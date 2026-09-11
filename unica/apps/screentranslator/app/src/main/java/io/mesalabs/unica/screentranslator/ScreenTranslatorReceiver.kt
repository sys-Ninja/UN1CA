package io.mesalabs.unica.screentranslator

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.mesalabs.unica.screentranslator.service.ScreenTranslatorService

class ScreenTranslatorReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return

        when (action) {
            "io.mesalabs.unica.screentranslator.TOGGLE_SERVICE" -> {
                // Stop-only path from SecSettings toggle.
                // Starting requires MediaProjection user consent (system dialog),
                // which MUST come from an Activity — handled by ScreenTranslatorSettingsActivity
                // launched directly from SecSettings.
                val stop = intent.getBooleanExtra("stop", false)
                if (stop) {
                    val stopIntent = Intent(context, ScreenTranslatorService::class.java).apply {
                        this.action = ScreenTranslatorService.ACTION_STOP
                    }
                    context.startService(stopIntent)
                }
                // If start is requested, no-op here — SecSettings must open the Activity
            }
            // Note: BOOT_COMPLETED intentionally NOT handled.
            // FGS type mediaProjection CANNOT be started from BOOT_COMPLETED on Android 14.
            // The translator requires fresh MediaProjection consent on each new session.
        }
    }
}
