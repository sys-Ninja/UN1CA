package io.mesalabs.unica.downloader

import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import androidx.preference.ListPreference
import androidx.preference.Preference
import androidx.preference.PreferenceFragmentCompat
import androidx.preference.SwitchPreferenceCompat
import com.yausername.youtubedl_android.YoutubeDL
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.text.DateFormat
import java.util.Date

class SettingsActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        if (savedInstanceState == null) {
            supportFragmentManager.beginTransaction()
                .replace(android.R.id.content, SettingsFragment())
                .commit()
        }
    }

    override fun onSupportNavigateUp(): Boolean {
        finish(); return true
    }

    class SettingsFragment : PreferenceFragmentCompat() {

        override fun onCreatePreferences(savedInstanceState: Bundle?, rootKey: String?) {
            val ctx = requireContext()
            val prefs = Prefs.get(ctx)
            val screen = preferenceManager.createPreferenceScreen(ctx)

                        screen.addPreference(SwitchPreferenceCompat(ctx).apply {
                key = "universal_extractor"
                setTitle(R.string.pref_universal_extractor)
                setSummary(R.string.pref_universal_extractor_sum)
                isChecked = prefs.universalExtractor
                setOnPreferenceChangeListener { _, v ->
                    prefs.universalExtractor = v as Boolean
                    true
                }
            })

            screen.addPreference(SwitchPreferenceCompat(ctx).apply {
                key = "enabled"
                setTitle(R.string.pref_enabled)
                setSummary(R.string.pref_enabled_sum)
                isChecked = prefs.enabled
                setOnPreferenceChangeListener { _, v ->
                    prefs.enabled = v as Boolean
                    if (!v) ClipboardMonitorService.stop(ctx)
                    else if (prefs.clipboardMonitor) ClipboardMonitorService.start(ctx)
                    true
                }
            })

            // --- library status ---
            val versionPref = Preference(ctx).apply {
                setTitle(R.string.pref_ytdlp_version)
                summary = try {
                    YoutubeDL.getInstance().version(ctx) ?: getString(R.string.unknown)
                } catch (e: Exception) {
                    getString(R.string.unknown)
                }
                isSelectable = false
            }
            screen.addPreference(versionPref)

            screen.addPreference(Preference(ctx).apply {
                setTitle(R.string.pref_last_update)
                summary = if (prefs.lastUpdateCheck > 0)
                    DateFormat.getDateTimeInstance().format(Date(prefs.lastUpdateCheck))
                else getString(R.string.never)
                isSelectable = false
            })

            screen.addPreference(Preference(ctx).apply {
                setTitle(R.string.pref_check_now)
                setOnPreferenceClickListener {
                    summary = getString(R.string.updating)
                    viewLifecycleOwner.lifecycleScope.launch(Dispatchers.IO) {
                        val ok = try {
                            YoutubeDL.getInstance()
                                .updateYoutubeDL(ctx, YoutubeDL.UpdateChannel.NIGHTLY)
                            prefs.lastUpdateCheck = System.currentTimeMillis()
                            true
                        } catch (e: Exception) { false }
                        withContext(Dispatchers.Main) {
                            summary = null
                            versionPref.summary = try {
                                YoutubeDL.getInstance().version(ctx)
                            } catch (e: Exception) { null } ?: getString(R.string.unknown)
                            Toast.makeText(
                                ctx,
                                if (ok) R.string.update_ok else R.string.update_failed,
                                Toast.LENGTH_SHORT
                            ).show()
                        }
                    }
                    true
                }
            })

            // --- defaults ---
            screen.addPreference(ListPreference(ctx).apply {
                key = "default_type"
                setTitle(R.string.pref_default_type)
                entries = arrayOf(getString(R.string.type_video), getString(R.string.type_audio))
                entryValues = arrayOf("video", "audio")
                value = prefs.defaultType
                summaryProvider = ListPreference.SimpleSummaryProvider.getInstance()
                setOnPreferenceChangeListener { _, v ->
                    prefs.defaultType = v as String; true
                }
            })

            screen.addPreference(ListPreference(ctx).apply {
                key = "default_quality"
                setTitle(R.string.pref_default_quality)
                entries = arrayOf(
                    getString(R.string.quality_best), "1080p", "720p", "480p"
                )
                entryValues = arrayOf("best", "1080", "720", "480")
                value = prefs.defaultQuality
                summaryProvider = ListPreference.SimpleSummaryProvider.getInstance()
                setOnPreferenceChangeListener { _, v ->
                    prefs.defaultQuality = v as String; true
                }
            })

            screen.addPreference(Preference(ctx).apply {
                setTitle(R.string.pref_download_dir)
                summary = prefs.downloadDir
                isSelectable = false
            })

                        screen.addPreference(SwitchPreferenceCompat(ctx).apply {
                key = "universal_extractor"
                setTitle(R.string.pref_universal_extractor)
                setSummary(R.string.pref_universal_extractor_sum)
                isChecked = prefs.universalExtractor
                setOnPreferenceChangeListener { _, v ->
                    prefs.universalExtractor = v as Boolean
                    true
                }
            })

            screen.addPreference(SwitchPreferenceCompat(ctx).apply {
                key = "organize_playlists"
                setTitle(R.string.pref_organize_playlists)
                setSummary(R.string.pref_organize_playlists_sum)
                isChecked = prefs.organizePlaylists
                setOnPreferenceChangeListener { _, v ->
                    prefs.organizePlaylists = v as Boolean; true
                }
            })

                        screen.addPreference(SwitchPreferenceCompat(ctx).apply {
                key = "universal_extractor"
                setTitle(R.string.pref_universal_extractor)
                setSummary(R.string.pref_universal_extractor_sum)
                isChecked = prefs.universalExtractor
                setOnPreferenceChangeListener { _, v ->
                    prefs.universalExtractor = v as Boolean
                    true
                }
            })

            screen.addPreference(SwitchPreferenceCompat(ctx).apply {
                key = "auto_update"
                setTitle(R.string.pref_auto_update)
                setSummary(R.string.pref_auto_update_sum)
                isChecked = prefs.autoUpdate
                setOnPreferenceChangeListener { _, v ->
                    prefs.autoUpdate = v as Boolean
                    if (v) App.instance.scheduleUpdate() else App.instance.cancelUpdate()
                    true
                }
            })

                        screen.addPreference(SwitchPreferenceCompat(ctx).apply {
                key = "universal_extractor"
                setTitle(R.string.pref_universal_extractor)
                setSummary(R.string.pref_universal_extractor_sum)
                isChecked = prefs.universalExtractor
                setOnPreferenceChangeListener { _, v ->
                    prefs.universalExtractor = v as Boolean
                    true
                }
            })

            screen.addPreference(SwitchPreferenceCompat(ctx).apply {
                key = "clipboard_monitor"
                setTitle(R.string.pref_clipboard)
                setSummary(R.string.pref_clipboard_sum)
                isChecked = prefs.clipboardMonitor
                setOnPreferenceChangeListener { _, v ->
                    prefs.clipboardMonitor = v as Boolean
                    if (v && prefs.enabled) ClipboardMonitorService.start(ctx)
                    else ClipboardMonitorService.stop(ctx)
                    true
                }
            })

            screen.addPreference(Preference(ctx).apply {
                setTitle(R.string.downloads_title)
                setOnPreferenceClickListener {
                    startActivity(
                        android.content.Intent(ctx, DownloadsActivity::class.java)
                    )
                    true
                }
            })

            preferenceScreen = screen
        }
    }
}
