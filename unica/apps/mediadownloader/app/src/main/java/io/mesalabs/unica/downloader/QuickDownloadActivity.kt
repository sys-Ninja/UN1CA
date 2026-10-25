package io.mesalabs.unica.downloader

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Patterns
import android.view.View
import android.widget.CheckBox
import android.widget.LinearLayout
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import coil.load
import com.google.android.material.bottomsheet.BottomSheetDialog
import io.mesalabs.unica.downloader.databinding.SheetQuickDownloadBinding
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.util.UUID

class QuickDownloadActivity : AppCompatActivity() {

    private lateinit var binding: SheetQuickDownloadBinding
    private lateinit var dialog: BottomSheetDialog
    private var meta: VideoMeta? = null
    private var fastMeta: FastMeta? = null
    private var url: String? = null
    private val checkboxes = mutableListOf<CheckBox>()

    private var selectedQuality: String = "best"
    private var selectedAudioOnly: Boolean = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val prefs = Prefs.get(this)
        if (!prefs.enabled) {
            finish()
            return
        }

        url = extractUrl(intent)
        if (url == null) {
            Toast.makeText(this, R.string.no_link_found, Toast.LENGTH_SHORT).show()
            finish()
            return
        }

        binding = SheetQuickDownloadBinding.inflate(layoutInflater)
        dialog = BottomSheetDialog(this)
        dialog.setContentView(binding.root)
        dialog.setOnDismissListener { finish() }

        // Open Bottom Sheet IMMEDIATELY (0 ms delay)
        dialog.show()

        // Display initial domain / title
        val host = try { Uri.parse(url).host?.removePrefix("www.")?.removePrefix("m.") ?: "" } catch (_: Exception) { "" }
        binding.title.text = if (host.isNotBlank()) host.uppercase() else url
        binding.subtitle.text = url
        binding.progress.visibility = View.VISIBLE
        binding.actions.visibility = View.VISIBLE

        // Configure default quality from settings
        selectedAudioOnly = (prefs.defaultType == "audio")
        selectedQuality = prefs.defaultQuality

        if (selectedAudioOnly) {
            binding.chipAudio.isChecked = true
        } else {
            when (selectedQuality) {
                "1080" -> binding.chip1080.isChecked = true
                "720"  -> binding.chip720.isChecked = true
                "480"  -> binding.chip480.isChecked = true
                else   -> binding.chipBest.isChecked = true
            }
        }
        updateDownloadButtonText()

        // Direct chip click listeners (safe, no SAM resolution issues)
        binding.chipBest.setOnClickListener {
            selectedQuality = "best"
            selectedAudioOnly = false
            updateDownloadButtonText()
        }
        binding.chip1080.setOnClickListener {
            selectedQuality = "1080"
            selectedAudioOnly = false
            updateDownloadButtonText()
        }
        binding.chip720.setOnClickListener {
            selectedQuality = "720"
            selectedAudioOnly = false
            updateDownloadButtonText()
        }
        binding.chip480.setOnClickListener {
            selectedQuality = "480"
            selectedAudioOnly = false
            updateDownloadButtonText()
        }
        binding.chipAudio.setOnClickListener {
            selectedQuality = "best"
            selectedAudioOnly = true
            updateDownloadButtonText()
        }

        binding.btnDownload.setOnClickListener { start() }
        binding.btnDownloads.setOnClickListener {
            startActivity(Intent(this, DownloadsActivity::class.java))
            dialog.dismiss()
        }

        // 1. Instant extraction (100-200ms like SnapTube)
        fastExtract(url!!)

        // 2. Full metadata extraction for playlists and streams
        loadMeta(url!!)
    }

    private fun fastExtract(targetUrl: String) {
        lifecycleScope.launch {
            val quickThumb = FastMetaExtractor.getQuickThumbnail(targetUrl)
            if (quickThumb != null) {
                binding.thumbnail.load(quickThumb) { crossfade(200) }
            }
            val fMeta = FastMetaExtractor.extract(targetUrl)
            if (fMeta != null && !isFinishing) {
                fastMeta = fMeta
                binding.title.text = fMeta.title
                binding.subtitle.text = fMeta.siteName
                if (!fMeta.thumbnail.isNullOrBlank()) {
                    binding.thumbnail.load(fMeta.thumbnail) { crossfade(200) }
                }
                binding.progress.visibility = View.GONE
            }
        }
    }

    private fun updateDownloadButtonText() {
        binding.btnDownload.text = when {
            selectedAudioOnly -> getString(R.string.btn_audio_only)
            selectedQuality == "best" -> getString(R.string.btn_best_video)
            else -> getString(R.string.btn_download_now) + " (" + selectedQuality + "p)"
        }
        binding.btnDownload.setIconResource(
            if (selectedAudioOnly) android.R.drawable.ic_media_play else android.R.drawable.stat_sys_download
        )
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val newUrl = extractUrl(intent) ?: return
        if (newUrl == url) return
        url = newUrl

        meta = null
        fastMeta = null
        checkboxes.clear()
        binding.playlistGroup.visibility = View.GONE
        binding.progress.visibility = View.VISIBLE

        val host = try { Uri.parse(newUrl).host?.removePrefix("www.")?.removePrefix("m.") ?: "" } catch (_: Exception) { "" }
        binding.title.text = if (host.isNotBlank()) host.uppercase() else newUrl
        binding.subtitle.text = newUrl
        binding.thumbnail.setImageDrawable(null)

        fastExtract(newUrl)
        loadMeta(newUrl)
    }

    private fun extractUrl(intent: Intent): String? {
        val text = when (intent.action) {
            Intent.ACTION_SEND -> intent.getStringExtra(Intent.EXTRA_TEXT)
            Intent.ACTION_VIEW -> intent.dataString
            else -> intent.getStringExtra(Intent.EXTRA_TEXT) ?: intent.dataString
        } ?: return null
        val m = Patterns.WEB_URL.matcher(text)
        while (m.find()) {
            val u = m.group() ?: continue
            if (u.startsWith("http")) return u
        }
        return null
    }

    private fun loadMeta(url: String) {
        lifecycleScope.launch(Dispatchers.IO) {
            try {
                var tries = 0
                while (!App.instance.libReady && tries < 100) {
                    Thread.sleep(50); tries++
                }
                val m = DownloadRepo.fetchMeta(url)

                withContext(Dispatchers.Main) {
                    if (isFinishing) return@withContext
                    meta = m
                    binding.progress.visibility = View.GONE
                    binding.title.text = m.title
                    val host = try { Uri.parse(url).host?.removePrefix("www.")?.removePrefix("m.") ?: "" } catch (_: Exception) { "" }
                    binding.subtitle.text = host.uppercase()

                    if (m.isPlaylist) setupPlaylistUi(m)
                }

                // Load high quality thumbnail smoothly via Coil
                if (!m.thumbnail.isNullOrBlank()) {
                    withContext(Dispatchers.Main) {
                        if (!isFinishing) {
                            binding.thumbnail.load(m.thumbnail) {
                                crossfade(300)
                            }
                        }
                    }
                }
            } catch (_: Exception) {
                withContext(Dispatchers.Main) {
                    if (isFinishing) return@withContext
                    binding.progress.visibility = View.GONE
                }
            }
        }
    }

    private fun setupPlaylistUi(m: VideoMeta) {
        binding.playlistGroup.visibility = View.VISIBLE
        binding.playlistLabel.text =
            getString(R.string.playlist_detected, m.entries.size)
        binding.optSelect.setOnCheckedChangeListener { _, checked ->
            binding.itemsContainer.visibility = if (checked) View.VISIBLE else View.GONE
        }
        checkboxes.clear()
        binding.itemsContainer.removeAllViews()
        m.entries.forEach { (idx, title) ->
            val cb = CheckBox(this).apply {
                text = "$idx - $title"
                isChecked = true
                tag = idx
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                )
            }
            checkboxes.add(cb)
            binding.itemsContainer.addView(cb)
        }
    }

    private fun start() {
        val u = url ?: return
        if (!DownloadRepo.hasSpace(this)) {
            Toast.makeText(this, R.string.low_space, Toast.LENGTH_LONG).show()
            return
        }
        val m = meta
        val fMeta = fastMeta
        var playlistTitle: String? = null
        var playlistItems: String? = null

        if (m?.isPlaylist == true) {
            when {
                binding.optAll.isChecked -> playlistTitle = m.playlistTitle
                binding.optRange.isChecked -> {
                    playlistTitle = m.playlistTitle
                    val from = binding.rangeFrom.text.toString().toIntOrNull() ?: 1
                    val to = binding.rangeTo.text.toString().toIntOrNull() ?: m.entries.size
                    playlistItems = "$from:$to"
                }
                binding.optSelect.isChecked -> {
                    playlistTitle = m.playlistTitle
                    val sel = checkboxes.filter { it.isChecked }.map { it.tag as Int }
                    if (sel.isEmpty()) {
                        Toast.makeText(this, R.string.select_at_least_one, Toast.LENGTH_SHORT).show()
                        return
                    }
                    playlistItems = sel.joinToString(",")
                }
            }
        }

        val finalTitle = m?.title ?: fMeta?.title ?: u
        val finalThumb = m?.thumbnail ?: fMeta?.thumbnail ?: FastMetaExtractor.getQuickThumbnail(u)

        val item = DownloadItem(
            id = UUID.randomUUID().toString(),
            url = u,
            title = finalTitle,
            audioOnly = selectedAudioOnly,
            quality = selectedQuality,
            thumbnail = finalThumb,
            playlistTitle = playlistTitle,
            playlistItems = playlistItems,
        )
        DownloadService.enqueue(this, item)
        Toast.makeText(this, R.string.download_started, Toast.LENGTH_SHORT).show()
        dialog.dismiss()
    }
}
