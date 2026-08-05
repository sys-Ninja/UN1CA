package io.mesalabs.unica.downloader

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Intent.ACTION_BOOT_COMPLETED) return
        val prefs = Prefs.get(context)
        if (prefs.enabled && prefs.clipboardMonitor) {
            ClipboardMonitorService.start(context)
        }
    }
}
