package io.mesalabs.unica.prayertimes

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        Log.i(PrayerManager.TAG, "BootReceiver received action: $action")

        when (action) {
            Intent.ACTION_BOOT_COMPLETED,
            Intent.ACTION_MY_PACKAGE_REPLACED,
            Intent.ACTION_TIME_CHANGED,
            Intent.ACTION_TIMEZONE_CHANGED,
            Intent.ACTION_DATE_CHANGED,
            "android.intent.action.TIME_SET",
            "io.mesalabs.unica.prayertimes.TOGGLE_SERVICE" -> {
                val prefs = Prefs.get(context)
                if (prefs.isEnabled) {
                    PrayerManager.scheduleNextPrayer(context)
                } else {
                    PrayerManager.cancelAlarms(context)
                }
            }
        }
    }
}