package io.mesalabs.unica.antipeeping

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.mesalabs.unica.antipeeping.data.AntiPeepingPrefs
import io.mesalabs.unica.antipeeping.service.AntiPeepingService

class AntiPeepingReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        val prefs = AntiPeepingPrefs.get(context)

        when (action) {
            "io.mesalabs.unica.antipeeping.TOGGLE_SERVICE" -> {
                // Android 14+ camera FGS requires the app to be in foreground (allowWiu=true).
                // goAsync() + Dispatchers.IO still runs in background context → DENIED.
                // Solution: launch a transparent LaunchProxyActivity which IS in the foreground,
                // then starts the FGS immediately and finishes itself.
                val proxyIntent = Intent(context, LaunchProxyActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                    putExtra(LaunchProxyActivity.EXTRA_STOP, !prefs.isEnabled)
                }
                context.startActivity(proxyIntent)
            }
            Intent.ACTION_BOOT_COMPLETED -> {
                // On boot, only start the service if the user had it enabled.
                // Camera FGS from BOOT_COMPLETED is allowed for system priv-apps
                // when using startForegroundService directly (boot is an exemption).
                if (prefs.isEnabled) {
                    val svc = Intent(context, AntiPeepingService::class.java)
                    context.startForegroundService(svc)
                }
            }
        }
    }
}
