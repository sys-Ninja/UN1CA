package io.mesalabs.unica.screentranslator

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.media.projection.MediaProjectionManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.preference.ListPreference
import androidx.preference.PreferenceFragmentCompat
import androidx.preference.SwitchPreferenceCompat
import io.mesalabs.unica.screentranslator.data.TranslatorPrefs
import io.mesalabs.unica.screentranslator.service.ScreenTranslatorService

class ScreenTranslatorSettingsActivity : AppCompatActivity() {

    private val mediaProjectionLauncher = registerForActivityResult(
        ActivityResultContracts.StartActivityForResult()
    ) { result ->
        if (result.resultCode == Activity.RESULT_OK && result.data != null) {
            val startServiceIntent = Intent(this, ScreenTranslatorService::class.java).apply {
                putExtra(ScreenTranslatorService.EXTRA_RESULT_CODE, result.resultCode)
                putExtra(ScreenTranslatorService.EXTRA_RESULT_DATA, result.data)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(startServiceIntent)
            } else {
                startService(startServiceIntent)
            }
            Toast.makeText(this, R.string.service_started, Toast.LENGTH_SHORT).show()
        } else {
            Toast.makeText(this, R.string.permission_denied, Toast.LENGTH_SHORT).show()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        supportFragmentManager
            .beginTransaction()
            .replace(android.R.id.content, ScreenTranslatorFragment { checkAndStartService() })
            .commit()
    }

    private fun checkAndStartService() {
        if (!Settings.canDrawOverlays(this)) {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName")
            )
            startActivity(intent)
            Toast.makeText(this, R.string.grant_overlay_permission, Toast.LENGTH_LONG).show()
            return
        }

        val mpManager = getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
        mediaProjectionLauncher.launch(mpManager.createScreenCaptureIntent())
    }
}

class ScreenTranslatorFragment(private val onStartRequested: () -> Unit) : PreferenceFragmentCompat() {

    override fun onCreatePreferences(savedInstanceState: Bundle?, rootKey: String?) {
        preferenceManager.preferenceDataStore = null
        setPreferencesFromResource(R.xml.translator_preferences, rootKey)
        bindPreferences()
    }

    private fun bindPreferences() {
        val prefs = TranslatorPrefs.get(requireContext())

        findPreference<SwitchPreferenceCompat>("pref_service_enabled")?.apply {
            isChecked = prefs.isServiceEnabled
            setOnPreferenceChangeListener { _, newValue ->
                val enabled = newValue as Boolean
                if (enabled) {
                    onStartRequested()
                } else {
                    val stopIntent = Intent(requireContext(), ScreenTranslatorService::class.java).apply {
                        action = ScreenTranslatorService.ACTION_STOP
                    }
                    requireContext().startService(stopIntent)
                    prefs.isServiceEnabled = false
                }
                true
            }
        }

        findPreference<ListPreference>("pref_target_language")?.apply {
            value = prefs.targetLanguage
            summary = entry
            setOnPreferenceChangeListener { _, newValue ->
                prefs.targetLanguage = newValue as String
                val idx = findIndexOfValue(newValue)
                if (idx >= 0) summary = entries[idx]
                true
            }
        }

        findPreference<ListPreference>("pref_source_language")?.apply {
            value = prefs.sourceLanguage
            summary = entry
            setOnPreferenceChangeListener { _, newValue ->
                prefs.sourceLanguage = newValue as String
                val idx = findIndexOfValue(newValue)
                if (idx >= 0) summary = entries[idx]
                true
            }
        }

        findPreference<SwitchPreferenceCompat>("pref_floating_bubble")?.apply {
            isChecked = prefs.showFloatingBubble
            setOnPreferenceChangeListener { _, newValue ->
                prefs.showFloatingBubble = newValue as Boolean
                true
            }
        }

        findPreference<SwitchPreferenceCompat>("pref_auto_games")?.apply {
            isChecked = prefs.autoTranslateGames
            setOnPreferenceChangeListener { _, newValue ->
                prefs.autoTranslateGames = newValue as Boolean
                true
            }
        }
    }
}