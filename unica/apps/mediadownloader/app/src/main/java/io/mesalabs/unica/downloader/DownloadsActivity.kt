package io.mesalabs.unica.downloader

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.FileProvider
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import io.mesalabs.unica.downloader.databinding.ActivityDownloadsBinding
import io.mesalabs.unica.downloader.databinding.ItemDownloadBinding
import kotlinx.coroutines.launch
import java.io.File

class DownloadsActivity : AppCompatActivity() {

    private lateinit var binding: ActivityDownloadsBinding
    private val adapter = DownloadsAdapter()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityDownloadsBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)

        binding.list.layoutManager = LinearLayoutManager(this)
        binding.list.adapter = adapter

        lifecycleScope.launch {
            DownloadRepo.flow.collect { items ->
                adapter.submit(items.reversed())
                binding.empty.visibility =
                    if (items.isEmpty()) View.VISIBLE else View.GONE
            }
        }
    }

    override fun onSupportNavigateUp(): Boolean {
        finish(); return true
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
            when (item.status) {
                DlStatus.QUEUED -> {
                    b.status.setText(R.string.status_queued)
                    b.progress.visibility = View.GONE
                    b.action.visibility = View.GONE
                }
                DlStatus.RUNNING -> {
                    b.status.text = getString(R.string.status_running, item.progress.toInt())
                    b.progress.visibility = View.VISIBLE
                    b.progress.progress = item.progress.toInt().coerceIn(0, 100)
                    b.action.visibility = View.VISIBLE
                    b.action.setText(R.string.cancel)
                    b.action.setOnClickListener {
                        startService(
                            Intent(this@DownloadsActivity, DownloadService::class.java)
                                .setAction(DownloadService.ACTION_CANCEL)
                                .putExtra(DownloadService.EXTRA_ID, item.id)
                        )
                    }
                }
                DlStatus.DONE -> {
                    b.status.setText(R.string.status_done)
                    b.progress.visibility = View.GONE
                    b.action.visibility = View.VISIBLE
                    b.action.setText(R.string.open)
                    b.action.setOnClickListener { openFile(item.filePath) }
                }
                DlStatus.FAILED -> {
                    b.status.setText(R.string.status_failed)
                    b.progress.visibility = View.GONE
                    b.action.visibility = View.VISIBLE
                    b.action.setText(R.string.retry)
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
            val mime = if (path.endsWith(".mp3")) "audio/*" else "video/*"
            startActivity(
                Intent(Intent.ACTION_VIEW)
                    .setDataAndType(uri, mime)
                    .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            )
        } catch (e: Exception) {
            Toast.makeText(this, R.string.no_player, Toast.LENGTH_SHORT).show()
        }
    }
}
