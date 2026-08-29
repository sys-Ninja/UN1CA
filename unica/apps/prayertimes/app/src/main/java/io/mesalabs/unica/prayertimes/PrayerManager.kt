package io.mesalabs.unica.prayertimes

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.util.Log
import io.mesalabs.unica.prayertimes.calc.CalculationParameters
import io.mesalabs.unica.prayertimes.calc.Prayer
import io.mesalabs.unica.prayertimes.calc.PrayerCalculationEngine
import io.mesalabs.unica.prayertimes.calc.PrayerTimesResult
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
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
        val prefs = Prefs.get(ctx)
        if (prefs.latitude == 0f && prefs.longitude == 0f) return null

        if (prefs.useOnlineApi) {
            val onlineResult = parseTodayFromOnlineCache(ctx)
            if (onlineResult != null) return onlineResult
        }

        return calculateLocally(ctx, Calendar.getInstance())
    }

    fun calculateLocally(ctx: Context, cal: Calendar): PrayerTimesResult? {
        val prefs = Prefs.get(ctx)
        if (prefs.latitude == 0f && prefs.longitude == 0f) return null

        val tz = if (prefs.timeZoneId.isNotEmpty()) {
            TimeZone.getTimeZone(prefs.timeZoneId)
        } else {
            TimeZone.getDefault()
        }

        val params = CalculationParameters.getByKey(prefs.calculationMethodKey)
        val madhab = prefs.getMadhab()
        val highLat = prefs.getHighLatitudeRule()
        val offsets = prefs.getOffsetsMap()

        return PrayerCalculationEngine.calculate(
            latitude = prefs.latitude.toDouble(),
            longitude = prefs.longitude.toDouble(),
            calendar = cal,
            timeZone = tz,
            params = params,
            madhab = madhab,
            highLatRule = highLat,
            offsets = offsets
        )
    }

    suspend fun fetchAndCacheTimings(ctx: Context): Boolean = withContext(Dispatchers.IO) {
        val prefs = Prefs.get(ctx)
        if (prefs.latitude == 0f && prefs.longitude == 0f) return@withContext false

        try {
            val cal = Calendar.getInstance()
            val year = cal.get(Calendar.YEAR)
            val month = cal.get(Calendar.MONTH) + 1
            val methodId = ONLINE_METHOD_MAP[prefs.calculationMethodKey.lowercase()] ?: 5
            val school = if (prefs.madhabKey.lowercase() == "hanafi") 1 else 0

            val urlString = "https://api.aladhan.com/v1/calendar/$year/$month?latitude=${prefs.latitude}&longitude=${prefs.longitude}&method=$methodId&school=$school"
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
                    return@withContext true
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Online API fetch failed", e)
        }
        return@withContext false
    }

    private fun parseTodayFromOnlineCache(ctx: Context): PrayerTimesResult? {
        val prefs = Prefs.get(ctx)
        if (prefs.cachedTimings.isEmpty()) return null

        try {
            val json = JSONObject(prefs.cachedTimings)
            val dataArray = json.optJSONArray("data") ?: return null
            val now = Calendar.getInstance()
            val dayIndex = now.get(Calendar.DAY_OF_MONTH) - 1

            val dayObj = dataArray.optJSONObject(dayIndex) ?: return null
            val timings = dayObj.optJSONObject("timings") ?: return null
            val dateStr = dayObj.optJSONObject("date")?.optJSONObject("gregorian")?.optString("date") ?: return null

            val sdf = SimpleDateFormat("dd-MM-yyyy HH:mm", Locale.US).apply {
                timeZone = if (prefs.timeZoneId.isNotEmpty()) TimeZone.getTimeZone(prefs.timeZoneId) else TimeZone.getDefault()
            }

            fun parseMillis(prayerKey: String): Long {
                val timeStr = timings.optString(prayerKey).substringBefore(" ")
                return sdf.parse("$dateStr $timeStr")?.time ?: 0L
            }

            val fajr = parseMillis("Fajr")
            val sunrise = parseMillis("Sunrise")
            val dhuhr = parseMillis("Dhuhr")
            val asr = parseMillis("Asr")
            val maghrib = parseMillis("Maghrib")
            val isha = parseMillis("Isha")

            if (fajr > 0L && dhuhr > 0L) {
                return PrayerTimesResult(
                    fajr = fajr,
                    sunrise = sunrise,
                    dhuhr = dhuhr,
                    asr = asr,
                    maghrib = maghrib,
                    isha = isha,
                    date = now.time,
                    latitude = prefs.latitude.toDouble(),
                    longitude = prefs.longitude.toDouble(),
                    timeZone = sdf.timeZone
                )
            }
        } catch (e: Exception) {
            Log.e(TAG, "Parsing online cache failed", e)
        }
        return null
    }

    fun scheduleNextPrayer(ctx: Context) {
        val prefs = Prefs.get(ctx)
        if (!prefs.isEnabled) {
            cancelAlarms(ctx)
            return
        }

        val now = System.currentTimeMillis()
        var nextPrayer: Pair<Prayer, Long>? = null

        // Check today
        val todayResult = getTodayPrayerTimes(ctx)
        if (todayResult != null) {
            nextPrayer = todayResult.getNextPrayer(now)
        }

        // If no more prayers today, check tomorrow
        if (nextPrayer == null) {
            val tomorrowCal = Calendar.getInstance().apply { add(Calendar.DAY_OF_MONTH, 1) }
            val tomorrowResult = calculateLocally(ctx, tomorrowCal)
            if (tomorrowResult != null) {
                nextPrayer = tomorrowResult.getNextPrayer(now)
            }
        }

        if (nextPrayer != null) {
            val (prayer, timeMillis) = nextPrayer
            // Don't sound alarm for Sunrise
            if (prayer != Prayer.SUNRISE) {
                Log.i(TAG, "Scheduling alarm for ${prayer.name} at ${Date(timeMillis)}")
                setExactAlarm(ctx, prayer.name, timeMillis)
            } else {
                // If Sunrise is next, schedule for the one after sunrise (Dhuhr)
                val afterSunrise = todayResult?.getNextPrayer(timeMillis + 1000)
                if (afterSunrise != null && afterSunrise.first != Prayer.SUNRISE) {
                    setExactAlarm(ctx, afterSunrise.first.name, afterSunrise.second)
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
        } catch (e: SecurityException) {
            Log.e(TAG, "Exact alarm permission missing", e)
        }
    }

    fun cancelAlarms(ctx: Context) {
        val am = ctx.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(ctx, AlarmReceiver::class.java)
        val pi = PendingIntent.getBroadcast(
            ctx,
            1001,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        am.cancel(pi)
    }
}