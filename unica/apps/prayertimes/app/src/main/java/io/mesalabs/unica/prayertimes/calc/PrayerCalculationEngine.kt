package io.mesalabs.unica.prayertimes.calc

import java.util.Calendar
import java.util.Date
import java.util.GregorianCalendar
import java.util.TimeZone
import kotlin.math.*

enum class Prayer {
    FAJR,
    SUNRISE,
    DHUHR,
    ASR,
    MAGHRIB,
    ISHA
}

enum class Madhab(val shadowMultiplier: Double) {
    SHAFI(1.0),
    HANAFI(2.0)
}

enum class HighLatitudeRule {
    MIDDLE_OF_THE_NIGHT,
    SEVENTH_OF_THE_NIGHT,
    TWILIGHT_ANGLE
}

data class CalculationParameters(
    val fajrAngle: Double,
    val ishaAngle: Double = 0.0,
    val ishaIntervalMinutes: Int = 0,
    val maghribAngle: Double = 0.0,
    val methodKey: String = "egyptian"
) {
    companion object {
        fun getByKey(key: String): CalculationParameters = when (key.lowercase()) {
            "egyptian" -> CalculationParameters(fajrAngle = 19.5, ishaAngle = 17.5, methodKey = "egyptian")
            "umm_al_qura" -> CalculationParameters(fajrAngle = 18.5, ishaIntervalMinutes = 90, methodKey = "umm_al_qura")
            "mwl" -> CalculationParameters(fajrAngle = 18.0, ishaAngle = 17.0, methodKey = "mwl")
            "karachi" -> CalculationParameters(fajrAngle = 18.0, ishaAngle = 18.0, methodKey = "karachi")
            "isna" -> CalculationParameters(fajrAngle = 15.0, ishaAngle = 15.0, methodKey = "isna")
            "dubai" -> CalculationParameters(fajrAngle = 18.2, ishaAngle = 18.2, methodKey = "dubai")
            "kuwait" -> CalculationParameters(fajrAngle = 18.0, ishaAngle = 17.5, methodKey = "kuwait")
            "qatar" -> CalculationParameters(fajrAngle = 18.0, ishaIntervalMinutes = 90, methodKey = "qatar")
            "diyanet" -> CalculationParameters(fajrAngle = 18.0, ishaAngle = 17.0, methodKey = "diyanet")
            "tehran" -> CalculationParameters(fajrAngle = 17.7, ishaAngle = 14.0, maghribAngle = 4.5, methodKey = "tehran")
            "moonsighting" -> CalculationParameters(fajrAngle = 18.0, ishaAngle = 18.0, methodKey = "moonsighting")
            else -> CalculationParameters(fajrAngle = 19.5, ishaAngle = 17.5, methodKey = "egyptian")
        }
    }
}

data class PrayerTimesResult(
    val fajr: Long,
    val sunrise: Long,
    val dhuhr: Long,
    val asr: Long,
    val maghrib: Long,
    val isha: Long,
    val date: Date,
    val latitude: Double,
    val longitude: Double,
    val timeZone: TimeZone
) {
    fun getTimeForPrayer(prayer: Prayer): Long = when (prayer) {
        Prayer.FAJR -> fajr
        Prayer.SUNRISE -> sunrise
        Prayer.DHUHR -> dhuhr
        Prayer.ASR -> asr
        Prayer.MAGHRIB -> maghrib
        Prayer.ISHA -> isha
    }

    fun getNextPrayer(nowMillis: Long = System.currentTimeMillis()): Pair<Prayer, Long>? {
        val list = listOf(
            Prayer.FAJR to fajr,
            Prayer.SUNRISE to sunrise,
            Prayer.DHUHR to dhuhr,
            Prayer.ASR to asr,
            Prayer.MAGHRIB to maghrib,
            Prayer.ISHA to isha
        )
        return list.firstOrNull { it.second > nowMillis }
    }
}

object PrayerCalculationEngine {

    fun calculate(
        latitude: Double,
        longitude: Double,
        calendar: Calendar = Calendar.getInstance(),
        timeZone: TimeZone = calendar.timeZone,
        params: CalculationParameters = CalculationParameters.getByKey("egyptian"),
        madhab: Madhab = Madhab.SHAFI,
        highLatRule: HighLatitudeRule = HighLatitudeRule.MIDDLE_OF_THE_NIGHT,
        offsets: Map<Prayer, Int> = emptyMap()
    ): PrayerTimesResult {
        val year = calendar.get(Calendar.YEAR)
        val month = calendar.get(Calendar.MONTH) + 1
        val day = calendar.get(Calendar.DAY_OF_MONTH)

        val jd = julianDay(year, month, day)
        val timezoneOffset = timeZone.getOffset(calendar.timeInMillis) / 3600000.0

        val d = jd - 2451545.0
        val solarCoords = getSolarCoordinates(d)
        val transit = getTransit(longitude, timezoneOffset, solarCoords.equationOfTime)

        val sunriseHourAngle = getHourAngle(latitude, solarCoords.declination, 0.833)
        var sunrise = transit - sunriseHourAngle
        var sunset = transit + sunriseHourAngle

        var fajrHourAngle = getHourAngle(latitude, solarCoords.declination, params.fajrAngle)
        var fajr = transit - fajrHourAngle

        val asrAltitude = atan(1.0 / (madhab.shadowMultiplier + tan(abs(latitude.toRadians() - solarCoords.declination.toRadians())))).toDegrees()
        val asrHourAngle = getHourAngle(latitude, solarCoords.declination, -asrAltitude)
        var asr = transit + asrHourAngle

        var maghrib = if (params.maghribAngle > 0.0) {
            val maghribAngle = getHourAngle(latitude, solarCoords.declination, params.maghribAngle)
            transit + maghribAngle
        } else {
            sunset
        }

        var isha = if (params.ishaIntervalMinutes > 0) {
            maghrib + (params.ishaIntervalMinutes / 60.0)
        } else {
            val ishaHourAngle = getHourAngle(latitude, solarCoords.declination, params.ishaAngle)
            transit + ishaHourAngle
        }

        val nightDuration = 24.0 - sunset + sunrise
        when (highLatRule) {
            HighLatitudeRule.MIDDLE_OF_THE_NIGHT -> {
                val halfNight = nightDuration / 2.0
                if (sunset - fajr > halfNight) fajr = sunrise - halfNight
                if (isha - sunset > halfNight) isha = sunset + halfNight
            }
            HighLatitudeRule.SEVENTH_OF_THE_NIGHT -> {
                val portion = nightDuration / 7.0
                if (sunset - fajr > portion * 3) fajr = sunrise - portion * 3
                if (isha - sunset > portion * 3) isha = sunset + portion * 3
            }
            HighLatitudeRule.TWILIGHT_ANGLE -> {
                val portionFajr = (params.fajrAngle / 60.0) * nightDuration
                val portionIsha = (params.ishaAngle / 60.0) * nightDuration
                if (sunset - fajr > portionFajr) fajr = sunrise - portionFajr
                if (isha - sunset > portionIsha) isha = sunset + portionIsha
            }
        }

        fun toMillis(hours: Double, prayer: Prayer): Long {
            val offsetMin = offsets[prayer] ?: 0
            val cal = GregorianCalendar(timeZone).apply {
                time = calendar.time
                set(Calendar.HOUR_OF_DAY, 0)
                set(Calendar.MINUTE, 0)
                set(Calendar.SECOND, 0)
                set(Calendar.MILLISECOND, 0)
            }
            val totalSeconds = (hours * 3600.0).roundToInt() + (offsetMin * 60)
            return cal.timeInMillis + (totalSeconds * 1000L)
        }

        return PrayerTimesResult(
            fajr = toMillis(fajr, Prayer.FAJR),
            sunrise = toMillis(sunrise, Prayer.SUNRISE),
            dhuhr = toMillis(transit, Prayer.DHUHR),
            asr = toMillis(asr, Prayer.ASR),
            maghrib = toMillis(maghrib, Prayer.MAGHRIB),
            isha = toMillis(isha, Prayer.ISHA),
            date = calendar.time,
            latitude = latitude,
            longitude = longitude,
            timeZone = timeZone
        )
    }

    private data class SolarCoordinates(val declination: Double, val equationOfTime: Double)

    private fun getSolarCoordinates(d: Double): SolarCoordinates {
        val q = fixAngle(280.459 + 0.98564736 * d)
        val g = fixAngle(357.529 + 0.98560028 * d).toRadians()
        val l = fixAngle(q + 1.915 * sin(g) + 0.020 * sin(2.0 * g)).toRadians()
        val e = (23.439 - 0.00000036 * d).toRadians()

        val sinDec = sin(e) * sin(l)
        val dec = asin(sinDec).toDegrees()

        val ra = atan2(cos(e) * sin(l), cos(l)).toDegrees() / 15.0
        val eqT = q / 15.0 - fixHour(ra)

        return SolarCoordinates(declination = dec, equationOfTime = eqT)
    }

    private fun getTransit(longitude: Double, timezone: Double, eqT: Double): Double {
        return fixHour(12.0 + timezone - (longitude / 15.0) - eqT)
    }

    private fun getHourAngle(latitude: Double, declination: Double, angle: Double): Double {
        val latRad = latitude.toRadians()
        val decRad = declination.toRadians()
        val cosHA = (sin((-angle).toRadians()) - sin(latRad) * sin(decRad)) / (cos(latRad) * cos(decRad))
        val clamped = cosHA.coerceIn(-1.0, 1.0)
        return acos(clamped).toDegrees() / 15.0
    }

    private fun julianDay(year: Int, month: Int, day: Int): Double {
        var y = year
        var m = month
        if (m <= 2) {
            y -= 1
            m += 12
        }
        val a = floor(y / 100.0)
        val b = 2 - a + floor(a / 4.0)
        return floor(365.25 * (y + 4716)) + floor(30.6001 * (m + 1)) + day + b - 1524.5
    }

    private fun fixAngle(a: Double): Double {
        var res = a - 360.0 * floor(a / 360.0)
        if (res < 0.0) res += 360.0
        return res
    }

    private fun fixHour(h: Double): Double {
        var res = h - 24.0 * floor(h / 24.0)
        if (res < 0.0) res += 24.0
        return res
    }

    private fun Double.toRadians(): Double = Math.toRadians(this)
    private fun Double.toDegrees(): Double = Math.toDegrees(this)
}