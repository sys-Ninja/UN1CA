package io.mesalabs.unica.downloader

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.text.format.Formatter
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.PopupMenu
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.FileProvider
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import io.mesalabs.unica.downloader.databinding.ActivityDownloadsBinding
import io.mesalabs.unica.downloader.databinding.ItemDownloadBinding
import kotlinx.coroutines.launch
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class DownloadsActivity : AppCompatActivity() {

    private lateinit var binding: ActivityDownloadsBinding
    private val adapter = DownloadsAdapter()

    private enum class FilterType { ALL, VIDEO, AUDIO }
    private enum class SortType { DATE_DESC, SIZE_DESC, NAME_ASC }

    private var currentFilter = FilterType.ALL
    private var currentSort = SortType.DATE_DESC
    private var allItems = listOf<DownloadItem>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityDownloadsBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)

        binding.list.layoutManager = LinearLayoutManager(this)
        binding.list.adapter = adapter

        setupFilters()
        setupSort()

        lifecycleScope.launch {
            DownloadRepo.syncFromStorage(this@DownloadsActivity)
        }

        lifecycleScope.launch {
            DownloadRepo.flow.collect { items ->
                allItems = items
                applyFilterAndSort()
            }
        }
    }

    private fun setupFilters() {
        binding.chipGroupFilters.setOnCheckedStateChangeListener { _, checkedIds ->
            currentFilter = when {
                checkedIds.contains(R.id.chip_video) -> FilterType.VIDEO
                checkedIds.contains(R.id.chip_audio) -> FilterType.AUDIO
                else -> FilterType.ALL
            }
            applyFilterAndSort()
        }
    }

    private fun setupSort() {
        binding.btnSort.setOnClickListener { view ->
            val popup = PopupMenu(this, view)
            popup.menu.add(0, 1, 0, R.string.sort_date)
            popup.menu.add(0, 2, 1, R.string.sort_size)
            popup.menu.add(0, 3, 2, R.string.sort_name)
            popup.setOnMenuItemClickListener { menuItem ->
                currentSort = when (menuItem.itemId) {
                    1 -> SortType.DATE_DESC
                    2 -> SortType.SIZE_DESC
                    3 -> SortType.NAME_ASC
                    else -> SortType.DATE_DESC
                }
                applyFilterAndSort()
                true
            }
            popup.show()
        }
    }

    private fun applyFilterAndSort() {
        var filtered = when (currentFilter) {
            FilterType.ALL -> allItems
            FilterType.VIDEO -> allItems.filter { !it.audioOnly }
            FilterType.AUDIO -> allItems.filter { it.audioOnly }
        }

        filtered = when (currentSort) {
            SortType.DATE_DESC -> filtered.sortedByDescending { it.dateAdded }
            SortType.SIZE_DESC -> filtered.sortedByDescending {
                it.fileSize.takeIf { s -> s > 0 } ?: (it.filePath?.let { p -> File(p).length() } ?: 0L)
            }
            SortType.NAME_ASC -> filtered.sortedBy { it.title.lowercase(Locale.ROOT) }
        }

        adapter.submit(filtered)
        binding.empty.visibility = if (filtered.isEmpty()) View.VISIBLE else View.GONE

        // Update header stats
        var totalBytes = 0L
        for (item in allItems) {
            totalBytes += item.fileSize.takeIf { it > 0 } ?: (item.filePath?.let { File(it).length() } ?: 0L)
        }
        val formattedSize = Formatter.formatFileSize(this, totalBytes)
        binding.textHeaderStats.text = getString(R.string.items_stat, allItems.size, formattedSize)
    }

    override fun onSupportNavigateUp(): Boolean {
        finish()
        return true
    }

    inner class DownloadsAdapter : RecyclerView.Adapter<DownloadsAdapter.VH>() {
        private var data: List<DownloadItem> = emptyList()

        fun submit(items: List<DownloadItem>) {
            data = items
            notifyDataSetChanged()
        }

        inner class VH(val b: ItemDownloadBinding) : RecyclerView.ViewHolder(b.root)

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int) = VH(
            ItemDownloadBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        )

        override fun getItemCount() = data.size

        override fun onBindViewHolder(holder: VH, position: Int) {
            val item = data[position]
            val b = holder.b
            b.title.text = item.title

            // Icon & Media Badge
            if (item.audioOnly) {
                b.imageTypeIcon.setImageResource(android.R.drawable.ic_media_play)
            } else {
                b.imageTypeIcon.setImageResource(android.R.drawable.ic_menu_slideshow)
            }

            // File size & date
            val fileLength = item.fileSize.takeIf { it > 0 } ?: (item.filePath?.let { File(it).length() } ?: 0L)
            val sizeStr = if (fileLength > 0) Formatter.formatFileSize(this@DownloadsActivity, fileLength) else ""
            val dateStr = SimpleDateFormat("MMM d, HH:mm", Locale.getDefault()).format(Date(item.dateAdded))

            when (item.status) {
                DlStatus.QUEUED -> {
                    b.status.setText(R.string.status_queued)
                    b.progress.visibility = View.GONE
                    b.action.visibility = View.GONE
                    b.btnShare.visibility = View.GONE
                    b.btnDelete.visibility = View.GONE
                }
                DlStatus.RUNNING -> {
                    b.status.text = getString(R.string.status_running, item.progress.toInt())
                    b.progress.visibility = View.VISIBLE
                    b.progress.progress = item.progress.toInt().coerceIn(0, 100)
                    b.action.visibility = View.VISIBLE
                    b.action.setText(R.string.cancel)
                    b.btnShare.visibility = View.GONE
                    b.btnDelete.visibility = View.GONE
                    b.action.setOnClickListener {
                        startService(
                            Intent(this@DownloadsActivity, DownloadService::class.java)
                                .setAction(DownloadService.ACTION_CANCEL)
                                .putExtra(DownloadService.EXTRA_ID, item.id)
                        )
                    }
                }
                DlStatus.DONE -> {
                    b.status.text = if (sizeStr.isNotEmpty()) "$sizeStr • $dateStr" else dateStr
                    b.progress.visibility = View.GONE
                    b.action.visibility = View.VISIBLE
                    b.action.setText(R.string.open)
                    b.btnShare.visibility = View.VISIBLE
                    b.btnDelete.visibility = View.VISIBLE

                    b.action.setOnClickListener { openFile(item.filePath) }
                    b.btnShare.setOnClickListener { shareFile(item.filePath) }
                    b.btnDelete.setOnClickListener { confirmDelete(item) }
                }
                DlStatus.FAILED -> {
                    b.status.setText(R.string.status_failed)
                    b.progress.visibility = View.GONE
                    b.action.visibility = View.VISIBLE
                    b.action.setText(R.string.retry)
                    b.btnShare.visibility = View.GONE
                    b.btnDelete.visibility = View.VISIBLE
                    b.btnDelete.setOnClickListener { DownloadRepo.remove(item.id) }
                    b.action.setOnClickListener {
                        DownloadRepo.remove(item.id)
                        DownloadService.enqueue(
                            this@DownloadsActivity,
                            item.copy(status = DlStatus.QUEUED, progress = 0f, error = null)
                        )
                    }
                }
                DlStatus.CANCELLED -> {
                    b.status.setText(R.string.status_cancelled)
                    b.progress.visibility = View.GONE
                    b.action.visibility = View.VISIBLE
                    b.action.setText(R.string.retry)
                    b.btnShare.visibility = View.GONE
                    b.btnDelete.visibility = View.VISIBLE
                    b.btnDelete.setOnClickListener { DownloadRepo.remove(item.id) }
                    b.action.setOnClickListener {
                        DownloadRepo.remove(item.id)
                        DownloadService.enqueue(
                            this@DownloadsActivity,
                            item.copy(status = DlStatus.QUEUED, progress = 0f)
                        )
                    }
                }
            }
        }
    }

    private fun openFile(path: String?) {
        if (path == null) return
        val file = File(path)
        if (!file.exists()) {
            Toast.makeText(this, R.string.file_missing, Toast.LENGTH_SHORT).show()
            return
        }
        try {
            val uri: Uri = FileProvider.getUriForFile(this, "$packageName.files", file)
            val mime = if (path.endsWith(".mp3") || path.endsWith(".m4a")) "audio/*" else "video/*"
            startActivity(
                Intent(Intent.ACTION_VIEW)
                    .setDataAndType(uri, mime)
                    .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            )
        } catch (_: Exception) {
            Toast.makeText(this, R.string.no_player, Toast.LENGTH_SHORT).show()
        }
    }

    private fun shareFile(path: String?) {
        if (path == null) return
        val file = File(path)
        if (!file.exists()) return
        try {
            val uri: Uri = FileProvider.getUriForFile(this, "$packageName.files", file)
            val mime = if (path.endsWith(".mp3") || path.endsWith(".m4a")) "audio/*" else "video/*"
            val shareIntent = Intent(Intent.ACTION_SEND).apply {
                type = mime
                putExtra(Intent.EXTRA_STREAM, uri)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
            startActivity(Intent.createChooser(shareIntent, getString(R.string.share)))
        } catch (_: Exception) {}
    }

    private fun confirmDelete(item: DownloadItem) {
        AlertDialog.Builder(this)
            .setTitle(R.string.delete)
            .setMessage(R.string.delete_confirm)
            .setPositiveButton(R.string.delete) { _, _ ->
                DownloadRepo.delete(item)
            }
            .setNegativeButton(R.string.cancel, null)
            .show()
    }
}