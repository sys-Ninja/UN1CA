package io.mesalabs.unica.prayertimes

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val prayerName = intent.getStringExtra("PRAYER_NAME") ?: return
        Log.i(PrayerManager.TAG, "Alarm triggered for $prayerName")

        val serviceIntent = Intent(context, AdhanService::class.java).apply {
            putExtra("PRAYER_NAME", prayerName)
        }
        
        try {
            context.startForegroundService(serviceIntent)
        } catch (e: Exception) {
            Log.e(PrayerManager.TAG, "Failed to start AdhanService", e)
        }

        // Schedule the next prayer immediately
        PrayerManager.scheduleNextPrayer(context)
    }
}
