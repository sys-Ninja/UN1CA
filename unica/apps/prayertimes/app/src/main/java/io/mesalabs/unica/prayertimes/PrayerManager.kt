package io.mesalabs.unica.prayertimes

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.util.Log
import org.json.JSONObject
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale
import java.util.TimeZone

data class PrayerTime(val name: String, val timeInMillis: Long)

object PrayerManager {
    const val TAG = "PrayerManager"

    private val PRAYERS = listOf("Fajr", "Dhuhr", "Asr", "Maghrib", "Isha")

    fun fetchAndCacheTimings(ctx: Context): Boolean {
        val prefs = Prefs.get(ctx)
        if (prefs.latitude == 0f || prefs.longitude == 0f) return false

        try {
            val cal = Calendar.getInstance()
            val year = cal.get(Calendar.YEAR)
            val month = cal.get(Calendar.MONTH) + 1
            
            // Method 4 is Umm al-Qura (commonly used in Arab world)
            val urlString = "https://api.aladhan.com/v1/calendar/$year/$month?latitude=${prefs.latitude}&longitude=${prefs.longitude}&method=4"
            val url = URL(urlString)
            val conn = url.openConnection() as HttpURLConnection
            conn.requestMethod = "GET"
            conn.connectTimeout = 15000
            conn.readTimeout = 15000

            if (conn.responseCode == 200) {
                val reader = BufferedReader(InputStreamReader(conn.inputStream))
                val response = reader.readText()
                reader.close()
                
                val json = JSONObject(response)
                if (json.optInt("code") == 200) {
                    prefs.cachedTimings = response
                    prefs.lastFetchTime = System.currentTimeMillis()
                    return true
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "API Fetch failed", e)
        }
        return false
    }

    fun scheduleNextPrayer(ctx: Context) {
        val prefs = Prefs.get(ctx)
        if (!prefs.isEnabled || prefs.cachedTimings.isEmpty()) return

        try {
            val json = JSONObject(prefs.cachedTimings)
            val dataArray = json.optJSONArray("data") ?: return

            val now = Calendar.getInstance()
            val todayDay = now.get(Calendar.DAY_OF_MONTH)
            
            var nextPrayer: PrayerTime? = null

            // Check today and tomorrow
            for (offset in 0..1) {
                val checkCal = Calendar.getInstance()
                checkCal.add(Calendar.DAY_OF_MONTH, offset)
                val checkDay = checkCal.get(Calendar.DAY_OF_MONTH)
                
                // Array is 0-indexed, so day 1 is at index 0
                val dayData = dataArray.optJSONObject(checkDay - 1) ?: continue
                val timings = dayData.optJSONObject("timings") ?: continue
                
                val sdf = SimpleDateFormat("dd-MM-yyyy HH:mm", Locale.US)
                val dateStr = dayData.optJSONObject("date")?.optJSONObject("gregorian")?.optString("date") ?: continue

                for (p in PRAYERS) {
                    // Time format is like "05:08 (EET)", extract just the time
                    val timeStr = timings.optString(p).substringBefore(" ")
                    val fullDateStr = "$dateStr $timeStr"
                    
                    val dateObj = sdf.parse(fullDateStr) ?: continue
                    if (dateObj.time > System.currentTimeMillis()) {
                        nextPrayer = PrayerTime(p, dateObj.time)
                        break
                    }
                }
                if (nextPrayer != null) break
            }

            if (nextPrayer != null) {
                Log.i(TAG, "Next prayer: ${nextPrayer.name} at ${Date(nextPrayer.timeInMillis)}")
                setAlarm(ctx, nextPrayer)
            } else {
                // End of month, need to fetch next month
                kotlinx.coroutines.GlobalScope.launch(kotlinx.coroutines.Dispatchers.IO) {
                    val success = fetchAndCacheTimings(ctx)
                    if (success) {
                        scheduleNextPrayer(ctx)
                    }
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Scheduling failed", e)
        }
    }

    private fun setAlarm(ctx: Context, prayer: PrayerTime) {
        val am = ctx.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(ctx, AlarmReceiver::class.java).apply {
            putExtra("PRAYER_NAME", prayer.name)
        }
        val pi = PendingIntent.getBroadcast(
            ctx, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        try {
            am.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, prayer.timeInMillis, pi)
        } catch (e: SecurityException) {
            Log.e(TAG, "Exact alarm permission missing", e)
        }
    }
}
