package io.mesalabs.unica.prayertimes

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.util.Log
import io.mesalabs.unica.prayertimes.calc.Prayer
import io.mesalabs.unica.prayertimes.calc.PrayerTimesResult
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONObject
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import java.util.Calendar
import java.util.Date
import java.util.TimeZone

object PrayerManager {
    const val TAG = "PrayerManager"

    private val ONLINE_METHOD_MAP = mapOf(
        "egyptian" to 5,
        "umm_al_qura" to 4,
        "mwl" to 3,
        "karachi" to 1,
        "isna" to 2,
        "dubai" to 16,
        "kuwait" to 9,
        "qatar" to 10,
        "diyanet" to 13,
        "tehran" to 7,
        "moonsighting" to 15
    )

    fun getTodayPrayerTimes(ctx: Context): PrayerTimesResult? {
        return getPrayerTimesForDay(ctx, 0)
    }

    fun getPrayerTimesForDay(ctx: Context, dayOffset: Int): PrayerTimesResult? {
        val prefs = Prefs.get(ctx)
        if (prefs.cachedTimings.isEmpty()) return null

        try {
            val json = JSONObject(prefs.cachedTimings)
            val dataArray = json.optJSONArray("data") ?: return null

            val targetCal = Calendar.getInstance().apply {
                if (dayOffset != 0) add(Calendar.DAY_OF_MONTH, dayOffset)
            }
            val targetDay = targetCal.get(Calendar.DAY_OF_MONTH)
            val targetMonth = targetCal.get(Calendar.MONTH) + 1
            val targetYear = targetCal.get(Calendar.YEAR)

            // Find matching day object in data array
            var dayObj: JSONObject? = null
            for (i in 0 until dataArray.length()) {
                val item = dataArray.optJSONObject(i) ?: continue
                val greg = item.optJSONObject("date")?.optJSONObject("gregorian") ?: continue
                val day = greg.optString("day").toIntOrNull() ?: greg.optInt("day", -1)
                val month = greg.optJSONObject("month")?.optInt("number", -1) ?: -1
                val year = greg.optString("year").toIntOrNull() ?: greg.optInt("year", -1)

                if (day == targetDay && (month == -1 || month == targetMonth) && (year == -1 || year == targetYear)) {
                    dayObj = item
                    break
                }
            }

            // Fallback to index if exact date match not found
            if (dayObj == null && targetDay - 1 in 0 until dataArray.length()) {
                dayObj = dataArray.optJSONObject(targetDay - 1)
            }

            if (dayObj == null) return null
            val timings = dayObj.optJSONObject("timings") ?: return null

            fun parseMillis(prayerKey: String, offsetMinutes: Int = 0): Long {
                val rawStr = timings.optString(prayerKey, "").trim()
                if (rawStr.isEmpty()) return 0L
                val timeStr = rawStr.substringBefore(" ").trim()
                val parts = timeStr.split(":")
                if (parts.size < 2) return 0L

                val hour = parts[0].toIntOrNull() ?: return 0L
                val minute = parts[1].toIntOrNull() ?: return 0L

                val cal = Calendar.getInstance().apply {
                    if (dayOffset != 0) add(Calendar.DAY_OF_MONTH, dayOffset)
                    set(Calendar.HOUR_OF_DAY, hour)
                    set(Calendar.MINUTE, minute)
                    set(Calendar.SECOND, 0)
                    set(Calendar.MILLISECOND, 0)
                    if (offsetMinutes != 0) {
                        add(Calendar.MINUTE, offsetMinutes)
                    }
                }
                return cal.timeInMillis
            }

            val fajr = parseMillis("Fajr", prefs.fajrOffset)
            val sunrise = parseMillis("Sunrise", prefs.sunriseOffset)
            val dhuhr = parseMillis("Dhuhr", prefs.dhuhrOffset)
            val asr = parseMillis("Asr", prefs.asrOffset)
            val maghrib = parseMillis("Maghrib", prefs.maghribOffset)
            val isha = parseMillis("Isha", prefs.ishaOffset)

            if (fajr > 0L && dhuhr > 0L) {
                return PrayerTimesResult(
                    fajr = fajr,
                    sunrise = sunrise,
                    dhuhr = dhuhr,
                    asr = asr,
                    maghrib = maghrib,
                    isha = isha,
                    date = targetCal.time,
                    latitude = prefs.latitude.toDouble(),
                    longitude = prefs.longitude.toDouble(),
                    timeZone = TimeZone.getDefault()
                )
            }
        } catch (e: Exception) {
            Log.e(TAG, "Parsing online cache failed", e)
        }
        return null
    }

    suspend fun fetchAndCacheTimings(ctx: Context): Boolean = withContext(Dispatchers.IO) {
        val prefs = Prefs.get(ctx)
        var lat = prefs.latitude
        var lng = prefs.longitude

        // Default to Cairo coordinates if not set
        if (lat == 0f && lng == 0f) {
            lat = 30.0444f
            lng = 31.2357f
            prefs.latitude = lat
            prefs.longitude = lng
            prefs.cityName = "Cairo"
        }

        try {
            val cal = Calendar.getInstance()
            val year = cal.get(Calendar.YEAR)
            val month = cal.get(Calendar.MONTH) + 1
            val methodId = ONLINE_METHOD_MAP[prefs.calculationMethodKey.lowercase()] ?: 5
            val school = if (prefs.madhabKey.lowercase() == "hanafi") 1 else 0

            val urlString = "https://api.aladhan.com/v1/calendar/$year/$month?latitude=$lat&longitude=$lng&method=$methodId&school=$school"
            val url = URL(urlString)
            val conn = (url.openConnection() as HttpURLConnection).apply {
                requestMethod = "GET"
                connectTimeout = 12000
                readTimeout = 12000
            }

            if (conn.responseCode == 200) {
                val reader = BufferedReader(InputStreamReader(conn.inputStream))
                val response = reader.readText()
                reader.close()

                val json = JSONObject(response)
                if (json.optInt("code") == 200) {
                    prefs.cachedTimings = response
                    prefs.lastFetchTime = System.currentTimeMillis()
                    scheduleNextPrayer(ctx)
                    return@withContext true
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Online API fetch failed", e)
        }
        return@withContext false
    }

    fun scheduleNextPrayer(ctx: Context) {
        val prefs = Prefs.get(ctx)
        if (!prefs.isEnabled) {
            cancelAlarms(ctx)
            return
        }

        val now = System.currentTimeMillis()
        var nextPrayer: Pair<Prayer, Long>? = null

        // 1. Check today's upcoming prayers
        val todayResult = getTodayPrayerTimes(ctx)
        if (todayResult != null) {
            nextPrayer = todayResult.getNextPrayer(now)
        }

        // 2. If all prayers for today passed, schedule tomorrow's Fajr
        if (nextPrayer == null) {
            val tomorrowResult = getPrayerTimesForDay(ctx, 1)
            if (tomorrowResult != null) {
                nextPrayer = tomorrowResult.getNextPrayer(now)
            }
        }

        if (nextPrayer != null) {
            val (prayer, timeMillis) = nextPrayer
            try {
                val sdf = java.text.SimpleDateFormat("hh:mm a", java.util.Locale.getDefault())
                val timeStr = sdf.format(Date(timeMillis))
                val prayerLabel = prayer.name.lowercase().replaceFirstChar { it.uppercase() }
                android.provider.Settings.System.putString(
                    ctx.contentResolver,
                    "unica_prayer_times_city",
                    "$prayerLabel: $timeStr"
                )
            } catch (_: Exception) {}
            if (prayer != Prayer.SUNRISE) {
                Log.i(TAG, "Scheduling alarm for ${prayer.name} at ${Date(timeMillis)}")
                setExactAlarm(ctx, prayer.name, timeMillis)
            } else {
                // If sunrise is next, schedule for Dhuhr
                val dhuhrTime = todayResult?.dhuhr ?: 0L
                if (dhuhrTime > now) {
                    setExactAlarm(ctx, Prayer.DHUHR.name, dhuhrTime)
                }
            }
        }
    }

    private fun setExactAlarm(ctx: Context, prayerName: String, timeMillis: Long) {
        val am = ctx.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(ctx, AlarmReceiver::class.java).apply {
            putExtra("PRAYER_NAME", prayerName)
        }
        val pi = PendingIntent.getBroadcast(
            ctx,
            1001,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        try {
            am.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, timeMillis, pi)
        } catch (e: Exception) {
            Log.e(TAG, "Failed to set exact alarm", e)
        }
    }

    fun cancelAlarms(ctx: Context) {
        val am = ctx.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(ctx, AlarmReceiver::class.java)
        val pi = PendingIntent.getBroadcast(
            ctx,
            1001,
            intent,
            PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
        )
        if (pi != null) {
            am.cancel(pi)
        }
    }
}