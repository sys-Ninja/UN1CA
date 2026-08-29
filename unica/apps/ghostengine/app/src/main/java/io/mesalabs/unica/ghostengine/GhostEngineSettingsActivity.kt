package io.mesalabs.unica.ghostengine

import android.app.Activity
import android.content.Context
import android.content.Intent
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
                if (enabled || prefs.isStealthGpsEnabled) {
                    act.startGhostService()
                } else {
                    act.stopGhostService()
                }
                true
            }
        }

        findPreference<Preference>("pref_select_media")?.apply {
            setOnPreferenceClickListener {
                onPickMediaRequested()
                true
            }
        }

        findPreference<SwitchPreferenceCompat>("pref_stealth_gps_enabled")?.apply {
            isChecked = prefs.isStealthGpsEnabled
            setOnPreferenceChangeListener { _, newValue ->
                val enabled = newValue as Boolean
                prefs.isStealthGpsEnabled = enabled
                if (enabled || prefs.isGhostCameraEnabled) {
                    act.startGhostService()
                } else {
                    act.stopGhostService()
                }
                true
            }
        }

        findPreference<Preference>("pref_search_location")?.apply {
            summary = "${prefs.spoofedLatitude}, ${prefs.spoofedLongitude}"
            setOnPreferenceClickListener {
                showLocationSearchDialog()
                true
            }
        }

        findPreference<SwitchPreferenceCompat>("pref_floating_joystick")?.apply {
            isChecked = prefs.showFloatingJoystick
            setOnPreferenceChangeListener { _, newValue ->
                prefs.showFloatingJoystick = newValue as Boolean
                if (prefs.isStealthGpsEnabled) {
                    act.startGhostService()
                }
                true
            }
        }
    }

    private fun showLocationSearchDialog() {
        val ctx = requireContext()
        val prefs = GhostEnginePrefs.get(ctx)
        val dialogView = LayoutInflater.from(ctx).inflate(R.layout.dialog_location_search, null)
        val editSearch = dialogView.findViewById<EditText>(R.id.edit_search_city)
        val progress = dialogView.findViewById<ProgressBar>(R.id.progress_searching)
        val recycler = dialogView.findViewById<RecyclerView>(R.id.recycler_predictions)

        var searchJob: Job? = null

        val dialog = AlertDialog.Builder(ctx)
            .setTitle(R.string.search_location_title)
            .setView(dialogView)
            .setNegativeButton(R.string.cancel, null)
            .create()

        recycler.layoutManager = LinearLayoutManager(ctx)

        editSearch.doAfterTextChanged { text ->
            searchJob?.cancel()
            val query = text?.toString() ?: ""
            if (query.length >= 2) {
                progress.visibility = android.view.View.VISIBLE
                searchJob = viewLifecycleOwner.lifecycleScope.launch {
                    delay(300)
                    val results = GooglePlacesHelper.searchPlaces(ctx, query)
                    progress.visibility = android.view.View.GONE
                    // Simple adapter
                    recycler.adapter = SimplePlaceAdapter(results) { prediction ->
                        viewLifecycleOwner.lifecycleScope.launch {
                            val details = GooglePlacesHelper.fetchPlaceDetails(prediction.placeId)
                            if (details != null) {
                                prefs.spoofedLatitude = details.latitude
                                prefs.spoofedLongitude = details.longitude
                                findPreference<Preference>("pref_search_location")?.summary =
                                    "${details.latitude}, ${details.longitude}"
                                Toast.makeText(ctx, details.name, Toast.LENGTH_SHORT).show()
                                dialog.dismiss()
                            }
                        }
                    }
                }
            } else {
                progress.visibility = android.view.View.GONE
            }
        }

        dialog.show()
    }
}

class SimplePlaceAdapter(
    private val items: List<io.mesalabs.unica.ghostengine.location.PlacePrediction>,
    private val onClick: (io.mesalabs.unica.ghostengine.location.PlacePrediction) -> Unit
) : RecyclerView.Adapter<SimplePlaceAdapter.ViewHolder>() {

    class ViewHolder(v: android.view.View) : RecyclerView.ViewHolder(v) {
        val textPrimary: android.widget.TextView = v.findViewById(R.id.text_prediction_primary)
        val textSecondary: android.widget.TextView = v.findViewById(R.id.text_prediction_secondary)
    }

    override fun onCreateViewHolder(parent: android.view.ViewGroup, viewType: Int): ViewHolder {
        val v = LayoutInflater.from(parent.context).inflate(R.layout.item_place_prediction, parent, false)
        return ViewHolder(v)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = items[position]
        holder.textPrimary.text = item.primaryText
        holder.textSecondary.text = item.secondaryText
        holder.itemView.setOnClickListener { onClick(item) }
    }

    override fun getItemCount(): Int = items.size
}