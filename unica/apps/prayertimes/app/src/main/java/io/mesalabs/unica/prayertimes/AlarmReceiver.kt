package io.mesalabs.unica.prayertimes

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build

class AlarmReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val prayerName = intent.getStringExtra("PRAYER_NAME") ?: return

        // Start Foreground Service to play Adhan
        val serviceIntent = Intent(context, AdhanService::class.java).apply {
            putExtra("PRAYER_NAME", prayerName)
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(serviceIntent)
        } else {
            context.startService(serviceIntent)
        }

        // Immediately schedule next prayer
        PrayerManager.scheduleNextPrayer(context)
    }
}