package io.mesalabs.unica.prayertimes

import android.app.AlertDialog
import android.content.Intent
import android.location.Geocoder
import android.media.RingtoneManager
import android.net.Uri
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import androidx.preference.Preference
import androidx.preference.PreferenceFragmentCompat
import androidx.preference.SwitchPreferenceCompat
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale

class PrayerTimesSettingsActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        supportFragmentManager
            .beginTransaction()
            .replace(android.R.id.content, PrayerTimesFragment())
            .commit()
    }
}

class PrayerTimesFragment : PreferenceFragmentCompat() {

    // Request codes for ringtone pickers
    private val SOUND_REQUEST = mapOf(
        "Fajr" to 100, "Dhuhr" to 101, "Asr" to 102, "Maghrib" to 103, "Isha" to 104
    )
    private var currentSoundPicker: String? = null

    /** Coroutine job for the live countdown ticker. */
    private var countdownJob: Job? = null

    override fun onCreatePreferences(savedInstanceState: Bundle?, rootKey: String?) {
        preferenceManager.preferenceDataStore = null
        setPreferencesFromResource(R.xml.prayer_preferences, rootKey)
        bindPreferences()
    }

    override fun onResume() {
        super.onResume()
        startCountdown()
    }

    override fun onPause() {
        super.onPause()
        countdownJob?.cancel()
        countdownJob = null
    }

    // ── Countdown helpers ────────────────────────────────────────────────────

    private fun startCountdown() {
        countdownJob?.cancel()
        countdownJob = lifecycleScope.launch(Dispatchers.IO) {
            while (isActive) {
                val (name, millis) = findNextPrayerNow()
                withContext(Dispatchers.Main) {
                    updateCountdownPref(name, millis)
                }
                delay(1_000L)
            }
        }
    }

    /**
     * Returns Pair(prayerName, millisUntilPrayer) for the next upcoming prayer,
     * or Pair(null, -1) when nothing is found (no location / timings cached).
     */
    private fun findNextPrayerNow(): Pair<String?, Long> {
        val prefs = Prefs.get(requireContext())
        if (prefs.cachedTimings.isEmpty()) return null to -1L

        return try {
            val json = JSONObject(prefs.cachedTimings)
            val dataArray = json.optJSONArray("data") ?: return null to -1L
            val prayers = listOf("Fajr", "Dhuhr", "Asr", "Maghrib", "Isha")
            val sdf = SimpleDateFormat("dd-MM-yyyy HH:mm", Locale.US)
            val now = System.currentTimeMillis()

            for (offset in 0..1) {
                val cal = Calendar.getInstance()
                cal.add(Calendar.DAY_OF_MONTH, offset)
                val day = cal.get(Calendar.DAY_OF_MONTH)
                val dayData = dataArray.optJSONObject(day - 1) ?: continue
                val timings = dayData.optJSONObject("timings") ?: continue
                val dateStr = dayData.optJSONObject("date")
                    ?.optJSONObject("gregorian")?.optString("date") ?: continue

                for (p in prayers) {
                    val timeStr = timings.optString(p).substringBefore(" ")
                    val dateObj = sdf.parse("$dateStr $timeStr") ?: continue
                    if (dateObj.time > now) return p to (dateObj.time - now)
                }
            }
            null to -1L
        } catch (e: Exception) {
            null to -1L
        }
    }

    private fun updateCountdownPref(prayerName: String?, millisUntil: Long) {
        val pref = findPreference<Preference>("pref_next_prayer") ?: return
        if (prayerName == null || millisUntil < 0) {
            pref.summary = getString(R.string.pref_next_prayer_unknown)
            return
        }

        // Localised prayer name
        val nameRes = when (prayerName) {
            "Fajr"    -> R.string.prayer_fajr
            "Dhuhr"   -> R.string.prayer_dhuhr
            "Asr"     -> R.string.prayer_asr
            "Maghrib" -> R.string.prayer_maghrib
            "Isha"    -> R.string.prayer_isha
            else      -> null
        }
        val localName = if (nameRes != null) getString(nameRes) else prayerName

        // Format HH:MM:SS
        val totalSec = millisUntil / 1000
        val h = totalSec / 3600
        val m = (totalSec % 3600) / 60
        val s = totalSec % 60
        val timeStr = String.format(Locale.US, "%02d:%02d:%02d", h, m, s)

        pref.summary = getString(R.string.pref_next_prayer_sum_format, localName, timeStr)
    }

    // ── Existing preference binding ──────────────────────────────────────────

    private fun bindPreferences() {
        val prefs = Prefs.get(requireContext())

        // Enable switch
        findPreference<SwitchPreferenceCompat>("pref_enabled")?.apply {
            isChecked = prefs.isEnabled
            setOnPreferenceChangeListener { _, newValue ->
                prefs.isEnabled = newValue as Boolean
                if (prefs.isEnabled) {
                    PrayerManager.scheduleNextPrayer(requireContext())
                }
                true
            }
        }

        // Location picker
        findPreference<Preference>("pref_location")?.apply {
            summary = if (prefs.cityName.isNotEmpty()) prefs.cityName
                      else getString(R.string.pref_location_sum)
            setOnPreferenceClickListener {
                showLocationDialog()
                true
            }
        }

        // Sound pickers for each prayer
        for ((prayer, reqCode) in SOUND_REQUEST) {
            val key = "pref_sound_${prayer.lowercase()}"
            findPreference<Preference>(key)?.apply {
                val savedUri = prefs.getSoundForPrayer(prayer)
                summary = if (savedUri != null) resolveRingtoneName(Uri.parse(savedUri))
                          else getString(R.string.default_sound)
                setOnPreferenceClickListener {
                    currentSoundPicker = prayer
                    val intent = Intent(RingtoneManager.ACTION_RINGTONE_PICKER).apply {
                        putExtra(RingtoneManager.EXTRA_RINGTONE_TYPE, RingtoneManager.TYPE_ALL)
                        putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_SILENT, false)
                        putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_DEFAULT, true)
                        val cur = prefs.getSoundForPrayer(prayer)
                        if (cur != null) putExtra(RingtoneManager.EXTRA_RINGTONE_EXISTING_URI, Uri.parse(cur))
                    }
                    @Suppress("DEPRECATION")
                    startActivityForResult(intent, reqCode)
                    true
                }
            }
        }
    }

    @Suppress("DEPRECATION")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        val prayer = SOUND_REQUEST.entries.firstOrNull { it.value == requestCode }?.key ?: return
        val uri = data?.getParcelableExtra<Uri>(RingtoneManager.EXTRA_RINGTONE_PICKED_URI)
        val prefs = Prefs.get(requireContext())
        prefs.setSoundForPrayer(prayer, uri?.toString())
        findPreference<Preference>("pref_sound_${prayer.lowercase()}")?.summary =
            if (uri != null) resolveRingtoneName(uri) else getString(R.string.default_sound)
    }

    private fun resolveRingtoneName(uri: Uri): String {
        return try {
            val rt = RingtoneManager.getRingtone(requireContext(), uri)
            rt?.getTitle(requireContext()) ?: uri.lastPathSegment ?: ""
        } catch (e: Exception) { getString(R.string.default_sound) }
    }

    private fun showLocationDialog() {
        val editText = EditText(requireContext()).apply {
            hint = getString(R.string.location_hint)
            setPadding(48, 24, 48, 12)
        }

        val dialog = AlertDialog.Builder(requireContext())
            .setTitle(getString(R.string.location_dialog_title))
            .setView(editText)
            .setPositiveButton(android.R.string.ok) { _, _ ->
                val query = editText.text.toString().trim()
                if (query.isNotEmpty()) searchCity(query)
            }
            .setNegativeButton(android.R.string.cancel, null)
            .create()

        dialog.show()
    }

    private fun searchCity(query: String) {
        val locationPref = findPreference<Preference>("pref_location")
        locationPref?.summary = getString(R.string.location_searching)

        lifecycleScope.launch(Dispatchers.IO) {
            try {
                @Suppress("DEPRECATION")
                val geocoder = Geocoder(requireContext(), Locale.getDefault())
                val results = geocoder.getFromLocationName(query, 1)
                
                withContext(Dispatchers.Main) {
                    if (results.isNullOrEmpty()) {
                        locationPref?.summary = getString(R.string.location_not_found)
                        Toast.makeText(requireContext(), getString(R.string.location_not_found), Toast.LENGTH_SHORT).show()
                    } else {
                        val addr = results[0]
                        val cityName = addr.locality ?: addr.adminArea ?: query
                        val prefs = Prefs.get(requireContext())
                        prefs.latitude = addr.latitude.toFloat()
                        prefs.longitude = addr.longitude.toFloat()
                        prefs.cityName = cityName
                        locationPref?.summary = cityName

                        // Fetch timings for new location in background
                        launch(Dispatchers.IO) {
                            val ok = PrayerManager.fetchAndCacheTimings(requireContext())
                            if (ok) PrayerManager.scheduleNextPrayer(requireContext())
                            withContext(Dispatchers.Main) {
                                Toast.makeText(
                                    requireContext(),
                                    if (ok) cityName else getString(R.string.api_error),
                                    Toast.LENGTH_SHORT
                                ).show()
                            }
                        }
                    }
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    locationPref?.summary = getString(R.string.location_not_found)
                }
            }
        }
    }
}
