package io.mesalabs.unica.ghostengine

import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.view.LayoutInflater
import android.widget.EditText
import android.widget.ProgressBar
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.core.widget.doAfterTextChanged
import androidx.lifecycle.lifecycleScope
import androidx.preference.Preference
import androidx.preference.PreferenceFragmentCompat
import androidx.preference.SwitchPreferenceCompat
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import io.mesalabs.unica.ghostengine.camera.GhostCameraService
import io.mesalabs.unica.ghostengine.data.GhostEnginePrefs
import io.mesalabs.unica.ghostengine.location.GooglePlacesHelper
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class GhostEngineSettingsActivity : AppCompatActivity() {

    private val mediaPickerLauncher = registerForActivityResult(
        ActivityResultContracts.GetContent()
    ) { uri: Uri? ->
        if (uri != null) {
            val type = contentResolver.getType(uri) ?: ""
            val isVideo = type.startsWith("video/")
            val prefs = GhostEnginePrefs.get(this)
            prefs.mediaUri = uri.toString()
            prefs.isVideoMedia = isVideo
            Toast.makeText(this, R.string.media_selected, Toast.LENGTH_SHORT).show()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        supportFragmentManager
            .beginTransaction()
            .replace(android.R.id.content, GhostEngineFragment { pickMedia() })
            .commit()
    }

    fun pickMedia() {
        mediaPickerLauncher.launch("*/*")
    }

    fun startGhostService() {
        if (!Settings.canDrawOverlays(this)) {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName")
            )
            startActivity(intent)
            Toast.makeText(this, R.string.grant_overlay_permission, Toast.LENGTH_LONG).show()
            return
        }

        val serviceIntent = Intent(this, GhostCameraService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(serviceIntent)
        } else {
            startService(serviceIntent)
        }
    }

    fun stopGhostService() {
        val stopIntent = Intent(this, GhostCameraService::class.java).apply {
            action = GhostCameraService.ACTION_STOP
        }
        startService(stopIntent)
    }
}

class GhostEngineFragment(private val onPickMediaRequested: () -> Unit) : PreferenceFragmentCompat() {

    override fun onCreatePreferences(savedInstanceState: Bundle?, rootKey: String?) {
        preferenceManager.preferenceDataStore = null
        setPreferencesFromResource(R.xml.ghost_engine_preferences, rootKey)
        bindPreferences()
    }

    private fun bindPreferences() {
        val prefs = GhostEnginePrefs.get(requireContext())
        val act = requireActivity() as GhostEngineSettingsActivity

        findPreference<SwitchPreferenceCompat>("pref_ghost_camera_enabled")?.apply {
            isChecked = prefs.isGhostCameraEnabled
            setOnPreferenceChangeListener { _, newValue ->
                val enabled = newValue as Boolean
                prefs.isGhostCameraEnabled = enabled
                if (enabled) act.startGhostService() else act.stopGhostService()
                true
            }
        }

        findPreference<Preference>("pref_select_media")?.apply {
            setOnPreferenceClickListener {
                onPickMediaRequested()
                true
            }
        }

        findPreference<SwitchPreferenceCompat>("pref_show_camera_tool")?.apply {
            isChecked = prefs.showCameraTool
            setOnPreferenceChangeListener { _, newValue ->
                prefs.showCameraTool = newValue as Boolean
                true
            }
        }

        findPreference<SwitchPreferenceCompat>("pref_stealth_gps_enabled")?.apply {
            isChecked = prefs.isStealthGpsEnabled
            setOnPreferenceChangeListener { _, newValue ->
                val enabled = newValue as Boolean
                prefs.isStealthGpsEnabled = enabled
                if (enabled) act.startGhostService() else act.stopGhostService()
                true
            }
        }

        findPreference<Preference>("pref_search_location")?.apply {
            summary = "${String.format("%.4f", prefs.spoofedLatitude)}, ${String.format("%.4f", prefs.spoofedLongitude)}"
            setOnPreferenceClickListener {
                showLocationSearchDialog(this)
                true
            }
        }

        findPreference<SwitchPreferenceCompat>("pref_floating_joystick")?.apply {
            isChecked = prefs.showFloatingJoystick
            setOnPreferenceChangeListener { _, newValue ->
                prefs.showFloatingJoystick = newValue as Boolean
                if (prefs.isStealthGpsEnabled) act.startGhostService()
                true
            }
        }

        val perAppPref = findPreference<SwitchPreferenceCompat>("pref_per_app_gps")
        val targetAppsPref = findPreference<Preference>("pref_select_target_apps")

        perAppPref?.apply {
            isChecked = prefs.isPerAppGps
            setOnPreferenceChangeListener { _, newValue ->
                val perApp = newValue as Boolean
                prefs.isPerAppGps = perApp
                targetAppsPref?.isEnabled = perApp
                updateTargetAppsSummary(targetAppsPref, prefs)
                true
            }
        }

        targetAppsPref?.apply {
            isEnabled = prefs.isPerAppGps
            updateTargetAppsSummary(this, prefs)
            setOnPreferenceClickListener {
                showTargetAppsDialog(this, prefs)
                true
            }
        }
    }

    private fun updateTargetAppsSummary(pref: Preference?, prefs: GhostEnginePrefs) {
        if (pref == null) return
        if (!prefs.isPerAppGps || prefs.targetPackages.isEmpty()) {
            pref.summary = getString(R.string.all_apps_selected)
        } else {
            pref.summary = getString(R.string.apps_selected_format, prefs.targetPackages.size)
        }
    }

    private fun showTargetAppsDialog(pref: Preference, prefs: GhostEnginePrefs) {
        val pm = requireContext().packageManager
        val mainIntent = Intent(Intent.ACTION_MAIN, null).apply {
            addCategory(Intent.CATEGORY_LAUNCHER)
        }
        val apps = pm.queryIntentActivities(mainIntent, 0)
            .map { it.activityInfo.applicationInfo }
            .distinctBy { it.packageName }
            .sortedBy { pm.getApplicationLabel(it).toString().lowercase() }

        val appNames = apps.map { pm.getApplicationLabel(it).toString() }.toTypedArray()
        val appPackages = apps.map { it.packageName }
        val checkedItems = BooleanArray(apps.size) { i ->
            prefs.targetPackages.contains(appPackages[i])
        }

        val selectedPackages = prefs.targetPackages.toMutableSet()

        AlertDialog.Builder(requireContext())
            .setTitle(R.string.select_apps_dialog_title)
            .setMultiChoiceItems(appNames, checkedItems) { _, which, isChecked ->
                val pkg = appPackages[which]
                if (isChecked) selectedPackages.add(pkg) else selectedPackages.remove(pkg)
            }
            .setPositiveButton(R.string.save) { _, _ ->
                prefs.targetPackages = selectedPackages
                updateTargetAppsSummary(pref, prefs)
            }
            .setNegativeButton(R.string.cancel, null)
            .show()
    }

    private fun showLocationSearchDialog(pref: Preference) {
        val ctx = requireContext()
        val prefs = GhostEnginePrefs.get(ctx)
        val dialogView = LayoutInflater.from(ctx).inflate(R.layout.dialog_location_search, null)
        val editQuery = dialogView.findViewById<EditText>(R.id.edit_search_query)
        val progress = dialogView.findViewById<ProgressBar>(R.id.search_progress)
        val recycler = dialogView.findViewById<RecyclerView>(R.id.recycler_places)

        recycler.layoutManager = LinearLayoutManager(ctx)
        val adapter = PlacesAdapter { prediction ->
            lifecycleScope.launch {
                progress.visibility = ProgressBar.VISIBLE
                val details = GooglePlacesHelper.fetchPlaceDetails(prediction.placeId)
                progress.visibility = ProgressBar.GONE
                if (details != null) {
                    prefs.spoofedLatitude = details.latitude
                    prefs.spoofedLongitude = details.longitude
                    pref.summary = "${String.format("%.4f", details.latitude)}, ${String.format("%.4f", details.longitude)}"
                    Toast.makeText(ctx, "Location: ${details.name}", Toast.LENGTH_SHORT).show()
                }
            }
        }
        recycler.adapter = adapter

        val dialog = AlertDialog.Builder(ctx)
            .setTitle(R.string.search_location_title)
            .setView(dialogView)
            .setNegativeButton(R.string.cancel, null)
            .create()

        var searchJob: Job? = null
        editQuery.doAfterTextChanged { text ->
            val query = text?.toString() ?: ""
            searchJob?.cancel()
            if (query.trim().length >= 2) {
                searchJob = lifecycleScope.launch {
                    delay(300)
                    progress.visibility = ProgressBar.VISIBLE
                    val results = GooglePlacesHelper.searchPlaces(ctx, query)
                    progress.visibility = ProgressBar.GONE
                    adapter.submit(results)
                }
            } else {
                adapter.submit(emptyList())
            }
        }

        dialog.show()
    }
}