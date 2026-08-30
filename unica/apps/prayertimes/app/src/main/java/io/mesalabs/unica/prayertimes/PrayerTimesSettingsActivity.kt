package io.mesalabs.unica.prayertimes

import android.app.AlertDialog
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.Uri
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.ProgressBar
import android.widget.TextView
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import androidx.preference.ListPreference
import androidx.preference.Preference
import androidx.preference.PreferenceFragmentCompat
import androidx.preference.SwitchPreferenceCompat
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import io.mesalabs.unica.prayertimes.audio.AdhanSoundManager
import io.mesalabs.unica.prayertimes.calc.Prayer
import io.mesalabs.unica.prayertimes.location.GooglePlacesHelper
import io.mesalabs.unica.prayertimes.location.PlaceSuggestion
import io.mesalabs.unica.prayertimes.ui.AdhanSoundPickerDialog
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
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

    private var countdownJob: Job? = null
    private var currentSoundPrayer: Prayer? = null

    private val timeChangeReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            PrayerManager.scheduleNextPrayer(requireContext())
            startCountdown()
        }
    }

    private val customAudioLauncher = registerForActivityResult(
        ActivityResultContracts.OpenDocument()
    ) { uri: Uri? ->
        if (uri != null) {
            val prayer = currentSoundPrayer ?: return@registerForActivityResult
            val ctx = requireContext()
            try {
                ctx.contentResolver.takePersistableUriPermission(
                    uri,
                    Intent.FLAG_GRANT_READ_URI_PERMISSION
                )
            } catch (_: Exception) {}

            val prefs = Prefs.get(ctx)
            prefs.setCustomAdhanUri(prayer.name, uri.toString())
            prefs.setAdhanSoundKey(prayer.name, "custom")
            updateAllSoundSummaries()
        }
    }

    override fun onCreatePreferences(savedInstanceState: Bundle?, rootKey: String?) {
        preferenceManager.preferenceDataStore = null
        setPreferencesFromResource(R.xml.prayer_preferences, rootKey)

        val prefs = Prefs.get(requireContext())
        if (prefs.googlePlacesApiKey.isNotEmpty()) {
            GooglePlacesHelper.initialize(requireContext(), prefs.googlePlacesApiKey)
        }

        bindPreferences()
    }

    override fun onResume() {
        super.onResume()
        startCountdown()
        updateAllSoundSummaries()

        val filter = IntentFilter().apply {
            addAction(Intent.ACTION_TIME_CHANGED)
            addAction(Intent.ACTION_TIMEZONE_CHANGED)
            addAction(Intent.ACTION_DATE_CHANGED)
            addAction("android.intent.action.TIME_SET")
        }
        requireContext().registerReceiver(timeChangeReceiver, filter)
    }

    override fun onPause() {
        super.onPause()
        countdownJob?.cancel()
        countdownJob = null
        AdhanSoundManager.stopPreview()
        try {
            requireContext().unregisterReceiver(timeChangeReceiver)
        } catch (_: Exception) {}
    }

    // ── Live Countdown ───────────────────────────────────────────────────────

    private fun startCountdown() {
        countdownJob?.cancel()
        countdownJob = lifecycleScope.launch(Dispatchers.IO) {
            while (isActive) {
                val nextPrayer = findNextPrayer()
                withContext(Dispatchers.Main) {
                    updateHeaderCountdown(nextPrayer)
                }
                delay(1_000L)
            }
        }
    }

    private fun findNextPrayer(): Pair<Prayer, Long>? {
        val result = PrayerManager.getTodayPrayerTimes(requireContext()) ?: return null
        val now = System.currentTimeMillis()
        var next = result.getNextPrayer(now)

        if (next == null) {
            val tomorrowResult = PrayerManager.getPrayerTimesForDay(requireContext(), 1)
            next = tomorrowResult?.getNextPrayer(now)
        }
        return next
    }

    private fun updateHeaderCountdown(next: Pair<Prayer, Long>?) {
        val pref = findPreference<Preference>("pref_next_prayer") ?: return
        if (next == null) {
            pref.summary = getString(R.string.pref_next_prayer_unknown)
            return
        }

        val (prayer, timeMillis) = next
        val millisRemaining = (timeMillis - System.currentTimeMillis()).coerceAtLeast(0L)

        val nameRes = when (prayer) {
            Prayer.FAJR -> R.string.prayer_fajr
            Prayer.SUNRISE -> R.string.prayer_sunrise
            Prayer.DHUHR -> R.string.prayer_dhuhr
            Prayer.ASR -> R.string.prayer_asr
            Prayer.MAGHRIB -> R.string.prayer_maghrib
            Prayer.ISHA -> R.string.prayer_isha
        }
        val localName = getString(nameRes)

        val totalSec = millisRemaining / 1000
        val h = totalSec / 3600
        val m = (totalSec % 3600) / 60
        val s = totalSec % 60
        val timeStr = String.format(Locale.US, "%02d:%02d:%02d", h, m, s)

        val sdf = SimpleDateFormat("hh:mm a", Locale.getDefault())
        val atTime = sdf.format(Date(timeMillis))

        pref.summary = "$localName ($atTime) · $timeStr"
    }

    // ── Preference Binding ───────────────────────────────────────────────────

    private fun bindPreferences() {
        val prefs = Prefs.get(requireContext())

        // Enable master switch
        findPreference<SwitchPreferenceCompat>("pref_enabled")?.apply {
            isChecked = prefs.isEnabled
            setOnPreferenceChangeListener { _, newValue ->
                val enabled = newValue as Boolean
                prefs.isEnabled = enabled
                if (enabled) {
                    PrayerManager.scheduleNextPrayer(requireContext())
                } else {
                    PrayerManager.cancelAlarms(requireContext())
                }
                true
            }
        }

        // Location Picker
        findPreference<Preference>("pref_location")?.apply {
            summary = if (prefs.cityName.isNotEmpty()) prefs.cityName else getString(R.string.pref_location_sum)
            setOnPreferenceClickListener {
                showLocationSearchDialog()
                true
            }
        }

        // Calculation Method List
        findPreference<ListPreference>("pref_method")?.apply {
            value = prefs.calculationMethodKey
            summary = entry ?: getString(R.string.pref_method_title)
            setOnPreferenceChangeListener { _, newValue ->
                val newKey = newValue as String
                prefs.calculationMethodKey = newKey
                val idx = findIndexOfValue(newKey)
                if (idx >= 0) summary = entries[idx]

                // Recalculate immediately
                if (prefs.useOnlineApi) {
                    syncOnlineTimings()
                } else {
                    PrayerManager.scheduleNextPrayer(requireContext())
                    startCountdown()
                }
                true
            }
        }

        // Madhab List (Shafi / Hanafi)
        findPreference<ListPreference>("pref_madhab")?.apply {
            value = prefs.madhabKey
            summary = entry ?: getString(R.string.pref_madhab_title)
            setOnPreferenceChangeListener { _, newValue ->
                val newKey = newValue as String
                prefs.madhabKey = newKey
                val idx = findIndexOfValue(newKey)
                if (idx >= 0) summary = entries[idx]

                if (prefs.useOnlineApi) {
                    syncOnlineTimings()
                } else {
                    PrayerManager.scheduleNextPrayer(requireContext())
                    startCountdown()
                }
                true
            }
        }

        // Online API Sync Toggle
        findPreference<SwitchPreferenceCompat>("pref_online_api")?.apply {
            isChecked = prefs.useOnlineApi
            summary = if (prefs.useOnlineApi) getString(R.string.pref_online_api_sum_on) else getString(R.string.pref_online_api_sum_off)
            setOnPreferenceChangeListener { _, newValue ->
                val enabled = newValue as Boolean
                prefs.useOnlineApi = enabled
                summary = if (enabled) getString(R.string.pref_online_api_sum_on) else getString(R.string.pref_online_api_sum_off)
                if (enabled) {
                    syncOnlineTimings()
                } else {
                    PrayerManager.scheduleNextPrayer(requireContext())
                    startCountdown()
                }
                true
            }
        }

        // Minute Offsets Dialog
        findPreference<Preference>("pref_offsets")?.apply {
            setOnPreferenceClickListener {
                showOffsetsDialog()
                true
            }
        }

        // Adhan Sound Pickers
        bindSoundPref("pref_sound_fajr", Prayer.FAJR)
        bindSoundPref("pref_sound_dhuhr", Prayer.DHUHR)
        bindSoundPref("pref_sound_asr", Prayer.ASR)
        bindSoundPref("pref_sound_maghrib", Prayer.MAGHRIB)
        bindSoundPref("pref_sound_isha", Prayer.ISHA)

        // Early warning
        findPreference<SwitchPreferenceCompat>("pref_early_warning")?.apply {
            isChecked = prefs.showEarlyWarning
            setOnPreferenceChangeListener { _, newValue ->
                prefs.showEarlyWarning = newValue as Boolean
                true
            }
        }

        findPreference<ListPreference>("pref_early_minutes")?.apply {
            value = prefs.earlyWarningMinutes.toString()
            summary = entry
            setOnPreferenceChangeListener { _, newValue ->
                prefs.earlyWarningMinutes = (newValue as String).toIntOrNull() ?: 10
                val idx = findIndexOfValue(newValue)
                if (idx >= 0) summary = entries[idx]
                true
            }
        }
    }

    private fun bindSoundPref(prefKey: String, prayer: Prayer) {
        findPreference<Preference>(prefKey)?.apply {
            val soundKey = Prefs.get(requireContext()).getAdhanSoundKey(prayer.name)
            summary = AdhanSoundManager.getSoundTitle(requireContext(), soundKey, prayer.name)
            setOnPreferenceClickListener {
                currentSoundPrayer = prayer
                AdhanSoundPickerDialog(
                    context = requireContext(),
                    prayer = prayer,
                    prefs = Prefs.get(requireContext()),
                    onCustomFileRequested = {
                        customAudioLauncher.launch(arrayOf("audio/*"))
                    },
                    onSoundSelected = {
                        updateAllSoundSummaries()
                    }
                ).show()
                true
            }
        }
    }

    private fun updateAllSoundSummaries() {
        val prefs = Prefs.get(requireContext())
        val map = mapOf(
            "pref_sound_fajr" to Prayer.FAJR,
            "pref_sound_dhuhr" to Prayer.DHUHR,
            "pref_sound_asr" to Prayer.ASR,
            "pref_sound_maghrib" to Prayer.MAGHRIB,
            "pref_sound_isha" to Prayer.ISHA
        )
        for ((key, prayer) in map) {
            val soundKey = prefs.getAdhanSoundKey(prayer.name)
            findPreference<Preference>(key)?.summary =
                AdhanSoundManager.getSoundTitle(requireContext(), soundKey, prayer.name)
        }
    }

    private fun syncOnlineTimings() {
        lifecycleScope.launch(Dispatchers.IO) {
            val ok = PrayerManager.fetchAndCacheTimings(requireContext())
            withContext(Dispatchers.Main) {
                if (ok) {
                    PrayerManager.scheduleNextPrayer(requireContext())
                    startCountdown()
                    Toast.makeText(requireContext(), R.string.ok, Toast.LENGTH_SHORT).show()
                } else {
                    Toast.makeText(requireContext(), R.string.api_error, Toast.LENGTH_LONG).show()
                }
            }
        }
    }

    // ── Location Search Dialog (Google Places Autocomplete) ─────────────────

    private fun showLocationSearchDialog() {
        val view = LayoutInflater.from(requireContext()).inflate(R.layout.dialog_location_search, null)
        val editQuery = view.findViewById<EditText>(R.id.edit_location_search)
        val progress = view.findViewById<ProgressBar>(R.id.progress_search)
        val recyclerView = view.findViewById<RecyclerView>(R.id.recycler_suggestions)

        val suggestions = mutableListOf<PlaceSuggestion>()
        var searchJob: Job? = null

        var dialog: AlertDialog? = null

        val adapter = SuggestionAdapter(suggestions) { selectedSuggestion ->
            progress.visibility = View.VISIBLE
            lifecycleScope.launch(Dispatchers.IO) {
                val resolved = GooglePlacesHelper.fetchPlaceDetails(requireContext(), selectedSuggestion)
                withContext(Dispatchers.Main) {
                    progress.visibility = View.GONE
                    if (resolved != null) {
                        val prefs = Prefs.get(requireContext())
                        prefs.latitude = resolved.latitude.toFloat()
                        prefs.longitude = resolved.longitude.toFloat()
                        prefs.cityName = resolved.name
                        prefs.timeZoneId = resolved.timeZoneId

                        findPreference<Preference>("pref_location")?.summary = resolved.name

                        if (prefs.useOnlineApi) {
                            syncOnlineTimings()
                        } else {
                            PrayerManager.scheduleNextPrayer(requireContext())
                            startCountdown()
                        }
                        dialog?.dismiss()
                    } else {
                        Toast.makeText(requireContext(), R.string.location_not_found, Toast.LENGTH_SHORT).show()
                    }
                }
            }
        }

        recyclerView.layoutManager = LinearLayoutManager(requireContext())
        recyclerView.adapter = adapter

        editQuery.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {
                val query = s?.toString()?.trim() ?: ""
                if (query.length < 2) {
                    suggestions.clear()
                    adapter.notifyDataSetChanged()
                    return
                }

                searchJob?.cancel()
                searchJob = lifecycleScope.launch(Dispatchers.IO) {
                    delay(300)
                    withContext(Dispatchers.Main) { progress.visibility = View.VISIBLE }
                    val results = GooglePlacesHelper.searchCities(requireContext(), query)
                    withContext(Dispatchers.Main) {
                        progress.visibility = View.GONE
                        suggestions.clear()
                        suggestions.addAll(results)
                        adapter.notifyDataSetChanged()
                    }
                }
            }
            override fun afterTextChanged(s: Editable?) {}
        })

        dialog = AlertDialog.Builder(requireContext())
            .setTitle(R.string.location_dialog_title)
            .setView(view)
            .setNegativeButton(R.string.cancel, null)
            .create()

        dialog.show()
    }

    // ── Offsets Dialog ───────────────────────────────────────────────────────

    private fun showOffsetsDialog() {
        val view = LayoutInflater.from(requireContext()).inflate(R.layout.dialog_offsets, null)
        val prefs = Prefs.get(requireContext())

        val editFajr = view.findViewById<EditText>(R.id.edit_offset_fajr).apply { setText(prefs.fajrOffset.toString()) }
        val editSunrise = view.findViewById<EditText>(R.id.edit_offset_sunrise).apply { setText(prefs.sunriseOffset.toString()) }
        val editDhuhr = view.findViewById<EditText>(R.id.edit_offset_dhuhr).apply { setText(prefs.dhuhrOffset.toString()) }
        val editAsr = view.findViewById<EditText>(R.id.edit_offset_asr).apply { setText(prefs.asrOffset.toString()) }
        val editMaghrib = view.findViewById<EditText>(R.id.edit_offset_maghrib).apply { setText(prefs.maghribOffset.toString()) }
        val editIsha = view.findViewById<EditText>(R.id.edit_offset_isha).apply { setText(prefs.ishaOffset.toString()) }

        AlertDialog.Builder(requireContext())
            .setTitle(R.string.pref_offsets_title)
            .setView(view)
            .setPositiveButton(R.string.save) { _, _ ->
                prefs.fajrOffset = editFajr.text.toString().toIntOrNull() ?: 0
                prefs.sunriseOffset = editSunrise.text.toString().toIntOrNull() ?: 0
                prefs.dhuhrOffset = editDhuhr.text.toString().toIntOrNull() ?: 0
                prefs.asrOffset = editAsr.text.toString().toIntOrNull() ?: 0
                prefs.maghribOffset = editMaghrib.text.toString().toIntOrNull() ?: 0
                prefs.ishaOffset = editIsha.text.toString().toIntOrNull() ?: 0

                PrayerManager.scheduleNextPrayer(requireContext())
                startCountdown()
            }
            .setNegativeButton(R.string.cancel, null)
            .show()
    }

    inner class SuggestionAdapter(
        private val list: List<PlaceSuggestion>,
        private val onItemClick: (PlaceSuggestion) -> Unit
    ) : RecyclerView.Adapter<SuggestionAdapter.SuggestionViewHolder>() {

        inner class SuggestionViewHolder(v: View) : RecyclerView.ViewHolder(v) {
            val textPrimary: TextView = v.findViewById(R.id.text_place_primary)
            val textSecondary: TextView = v.findViewById(R.id.text_place_secondary)
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SuggestionViewHolder {
            val v = LayoutInflater.from(parent.context).inflate(R.layout.item_place_suggestion, parent, false)
            return SuggestionViewHolder(v)
        }

        override fun getItemCount(): Int = list.size

        override fun onBindViewHolder(holder: SuggestionViewHolder, position: Int) {
            val item = list[position]
            holder.textPrimary.text = item.primaryText
            holder.textSecondary.text = item.secondaryText
            holder.itemView.setOnClickListener { onItemClick(item) }
        }
    }
}