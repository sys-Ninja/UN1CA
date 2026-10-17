package io.mesalabs.unica.ghostengine

import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.CheckBox
import android.widget.EditText
import android.widget.ImageView
import android.widget.ProgressBar
import android.widget.TextView
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
import io.mesalabs.unica.ghostengine.location.PlacePrediction
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class GhostEngineSettingsActivity : AppCompatActivity() {

    private var activePickerSlot = 1

    private val mediaPickerLauncher = registerForActivityResult(
        ActivityResultContracts.GetContent()
    ) { uri: Uri? ->
        if (uri != null) {
            val type = contentResolver.getType(uri) ?: ""
            val isVideo = type.startsWith("video/")
            val prefs = GhostEnginePrefs.get(this)
            val uriStr = uri.toString()
            if (activePickerSlot == 2) {
                prefs.mediaSlot2 = uriStr
            } else {
                prefs.mediaSlot1 = uriStr
                prefs.mediaUri = uriStr
            }
            prefs.isVideoMedia = isVideo
            Toast.makeText(this, R.string.media_selected, Toast.LENGTH_SHORT).show()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        supportFragmentManager
            .beginTransaction()
            .replace(android.R.id.content, GhostEngineFragment { slot -> pickMedia(slot) })
            .commit()
    }

    fun pickMedia(slot: Int) {
        activePickerSlot = slot
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

class GhostEngineFragment(private val onPickMediaRequested: (slot: Int) -> Unit) : PreferenceFragmentCompat() {

    override fun onCreatePreferences(savedInstanceState: Bundle?, rootKey: String?) {
        preferenceManager.preferenceDataStore = null
        setPreferencesFromResource(R.xml.ghost_engine_preferences, rootKey)
        bindPreferences()
    }

    private fun bindPreferences() {
        val prefs = GhostEnginePrefs.get(requireContext())
        val act = requireActivity() as GhostEngineSettingsActivity

        // Camera Section
        findPreference<SwitchPreferenceCompat>("pref_ghost_camera_enabled")?.apply {
            isChecked = prefs.isGhostCameraEnabled
            setOnPreferenceChangeListener { _, newValue ->
                val enabled = newValue as Boolean
                prefs.isGhostCameraEnabled = enabled
                if (enabled) act.startGhostService() else act.stopGhostService()
                true
            }
        }

        findPreference<Preference>("pref_select_media_slot1")?.apply {
            setOnPreferenceClickListener {
                onPickMediaRequested(1)
                true
            }
        }

        findPreference<Preference>("pref_select_media_slot2")?.apply {
            setOnPreferenceClickListener {
                onPickMediaRequested(2)
                true
            }
        }

        findPreference<SwitchPreferenceCompat>("pref_show_camera_tool")?.apply {
            isChecked = prefs.showCameraTool
            setOnPreferenceChangeListener { _, newValue ->
                prefs.showCameraTool = newValue as Boolean
                if (prefs.isGhostCameraEnabled) act.startGhostService()
                true
            }
        }

        val perAppCameraPref = findPreference<SwitchPreferenceCompat>("pref_per_app_camera")
        val targetCameraAppsPref = findPreference<Preference>("pref_select_camera_target_apps")

        perAppCameraPref?.apply {
            isChecked = prefs.isPerAppCamera
            setOnPreferenceChangeListener { _, newValue ->
                val perApp = newValue as Boolean
                prefs.isPerAppCamera = perApp
                targetCameraAppsPref?.isEnabled = perApp
                updateAppSummary(targetCameraAppsPref, perApp, prefs.cameraTargetPackages.size)
                true
            }
        }

        targetCameraAppsPref?.apply {
            isEnabled = prefs.isPerAppCamera
            updateAppSummary(this, prefs.isPerAppCamera, prefs.cameraTargetPackages.size)
            setOnPreferenceClickListener {
                showAppSelectionDialog(
                    titleRes = R.string.select_camera_apps_dialog_title,
                    currentSelected = prefs.cameraTargetPackages
                ) { newSelected ->
                    prefs.cameraTargetPackages = newSelected
                    updateAppSummary(targetCameraAppsPref, prefs.isPerAppCamera, newSelected.size)
                }
                true
            }
        }

        // Location Section
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

        val perAppGpsPref = findPreference<SwitchPreferenceCompat>("pref_per_app_gps")
        val targetGpsAppsPref = findPreference<Preference>("pref_select_target_apps")

        perAppGpsPref?.apply {
            isChecked = prefs.isPerAppGps
            setOnPreferenceChangeListener { _, newValue ->
                val perApp = newValue as Boolean
                prefs.isPerAppGps = perApp
                targetGpsAppsPref?.isEnabled = perApp
                updateAppSummary(targetGpsAppsPref, perApp, prefs.targetPackages.size)
                true
            }
        }

        targetGpsAppsPref?.apply {
            isEnabled = prefs.isPerAppGps
            updateAppSummary(this, prefs.isPerAppGps, prefs.targetPackages.size)
            setOnPreferenceClickListener {
                showAppSelectionDialog(
                    titleRes = R.string.select_apps_dialog_title,
                    currentSelected = prefs.targetPackages
                ) { newSelected ->
                    prefs.targetPackages = newSelected
                    updateAppSummary(targetGpsAppsPref, prefs.isPerAppGps, newSelected.size)
                }
                true
            }
        }
    }

    private fun updateAppSummary(pref: Preference?, isPerApp: Boolean, count: Int) {
        if (pref == null) return
        if (!isPerApp || count == 0) {
            pref.summary = getString(R.string.all_apps_selected)
        } else {
            pref.summary = getString(R.string.apps_selected_format, count)
        }
    }

    private fun showAppSelectionDialog(
        titleRes: Int,
        currentSelected: Set<String>,
        onSave: (Set<String>) -> Unit
    ) {
        val ctx = requireContext()
        val pm = ctx.packageManager
        val dialogView = LayoutInflater.from(ctx).inflate(R.layout.dialog_select_apps, null)
        val editSearch = dialogView.findViewById<EditText>(R.id.edit_search_app)
        val btnSelectAll = dialogView.findViewById<Button>(R.id.btn_select_all)
        val btnClearAll = dialogView.findViewById<Button>(R.id.btn_clear_all)
        val recycler = dialogView.findViewById<RecyclerView>(R.id.recycler_target_apps)

        val mainIntent = Intent(Intent.ACTION_MAIN, null).apply {
            addCategory(Intent.CATEGORY_LAUNCHER)
        }
        val appList = pm.queryIntentActivities(mainIntent, 0)
            .map { it.activityInfo.applicationInfo }
            .distinctBy { it.packageName }
            .map { info ->
                AppEntry(
                    label = pm.getApplicationLabel(info).toString(),
                    packageName = info.packageName,
                    icon = pm.getApplicationIcon(info),
                    isChecked = currentSelected.contains(info.packageName)
                )
            }
            .sortedBy { it.label.lowercase() }

        val selectedSet = currentSelected.toMutableSet()
        val adapter = AppListAdapter(appList) { entry, checked ->
            if (checked) selectedSet.add(entry.packageName) else selectedSet.remove(entry.packageName)
        }

        recycler.layoutManager = LinearLayoutManager(ctx)
        recycler.adapter = adapter

        btnSelectAll.setOnClickListener {
            adapter.selectAll()
            appList.forEach { selectedSet.add(it.packageName) }
        }

        btnClearAll.setOnClickListener {
            adapter.clearAll()
            selectedSet.clear()
        }

        editSearch.doAfterTextChanged { text ->
            adapter.filter(text?.toString() ?: "")
        }

        AlertDialog.Builder(ctx)
            .setTitle(titleRes)
            .setView(dialogView)
            .setPositiveButton(R.string.save) { _, _ ->
                onSave(selectedSet)
            }
            .setNegativeButton(R.string.cancel, null)
            .show()
    }

    private fun showLocationSearchDialog(pref: Preference) {
        val ctx = requireContext()
        val prefs = GhostEnginePrefs.get(ctx)
        val dialogView = LayoutInflater.from(ctx).inflate(R.layout.dialog_location_search, null)
        val editQuery = dialogView.findViewById<EditText>(R.id.edit_search_city)
        val progress = dialogView.findViewById<ProgressBar>(R.id.progress_searching)
        val recycler = dialogView.findViewById<RecyclerView>(R.id.recycler_predictions)

        recycler.layoutManager = LinearLayoutManager(ctx)
        val adapter = PlacesAdapter { prediction: PlacePrediction ->
            lifecycleScope.launch {
                progress.visibility = View.VISIBLE
                val details = GooglePlacesHelper.fetchPlaceDetails(prediction.placeId)
                progress.visibility = View.GONE
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
                    progress.visibility = View.VISIBLE
                    val results = GooglePlacesHelper.searchPlaces(ctx, query)
                    progress.visibility = View.GONE
                    adapter.submit(results)
                }
            } else {
                adapter.submit(emptyList())
            }
        }

        dialog.show()
    }
}

data class AppEntry(
    val label: String,
    val packageName: String,
    val icon: Drawable,
    var isChecked: Boolean
)

class AppListAdapter(
    private val allItems: List<AppEntry>,
    private val onCheckChanged: (AppEntry, Boolean) -> Unit
) : RecyclerView.Adapter<AppListAdapter.ViewHolder>() {

    private val filteredItems = mutableListOf<AppEntry>().apply { addAll(allItems) }

    fun filter(query: String) {
        val q = query.trim().lowercase()
        filteredItems.clear()
        if (q.isEmpty()) {
            filteredItems.addAll(allItems)
        } else {
            allItems.filterTo(filteredItems) {
                it.label.lowercase().contains(q) || it.packageName.lowercase().contains(q)
            }
        }
        notifyDataSetChanged()
    }

    fun selectAll() {
        allItems.forEach { it.isChecked = true }
        notifyDataSetChanged()
    }

    fun clearAll() {
        allItems.forEach { it.isChecked = false }
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.item_target_app, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = filteredItems[position]
        holder.icon.setImageDrawable(item.icon)
        holder.txtLabel.text = item.label
        holder.txtPkg.text = item.packageName
        holder.checkBox.isChecked = item.isChecked

        holder.itemView.setOnClickListener {
            val newChecked = !item.isChecked
            item.isChecked = newChecked
            holder.checkBox.isChecked = newChecked
            onCheckChanged(item, newChecked)
        }
    }

    override fun getItemCount(): Int = filteredItems.size

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val icon: ImageView = view.findViewById(R.id.img_app_icon)
        val txtLabel: TextView = view.findViewById(R.id.txt_app_label)
        val txtPkg: TextView = view.findViewById(R.id.txt_app_package)
        val checkBox: CheckBox = view.findViewById(R.id.chk_app_selected)
    }
}

class PlacesAdapter(
    private val onItemClick: (PlacePrediction) -> Unit
) : RecyclerView.Adapter<PlacesAdapter.ViewHolder>() {

    private val items = mutableListOf<PlacePrediction>()

    fun submit(newItems: List<PlacePrediction>) {
        items.clear()
        items.addAll(newItems)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_place_prediction, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = items[position]
        holder.primaryText.text = item.primaryText
        holder.secondaryText.text = item.secondaryText
        holder.itemView.setOnClickListener { onItemClick(item) }
    }

    override fun getItemCount(): Int = items.size

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val primaryText: TextView = view.findViewById(R.id.text_prediction_primary)
        val secondaryText: TextView = view.findViewById(R.id.text_prediction_secondary)
    }
}
