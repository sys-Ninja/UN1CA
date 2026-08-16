package io.mesalabs.unica.downloader

import android.content.Context
import android.net.Uri
import android.util.Log
import com.yausername.youtubedl_android.YoutubeDL
import com.yausername.youtubedl_android.YoutubeDLRequest
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import org.json.JSONArray
import org.json.JSONObject
import java.io.File

enum class DlStatus { QUEUED, RUNNING, DONE, FAILED, CANCELLED }

data class DownloadItem(
    val id: String,
    val url: String,
    val title: String,
    val audioOnly: Boolean,
    val quality: String,
    val thumbnail: String? = null,
    val playlistTitle: String? = null,
    val playlistItems: String? = null,
    var status: DlStatus = DlStatus.QUEUED,
    var progress: Float = 0f,
    var etaSeconds: Long = 0,
    var line: String = "",
    var filePath: String? = null,
    var error: String? = null,
)

data class VideoMeta(
    val url: String,
    val title: String,
    val thumbnail: String?,
    val isPlaylist: Boolean,
    val playlistTitle: String?,
    val entries: List<Pair<Int, String>>,
)

object DownloadRepo {

    private val items = LinkedHashMap<String, DownloadItem>()
    private val _flow = MutableStateFlow<List<DownloadItem>>(emptyList())
    val flow: StateFlow<List<DownloadItem>> = _flow

    @Synchronized fun add(item: DownloadItem) { items[item.id] = item; publish() }

    @Synchronized
    fun update(id: String, block: (DownloadItem) -> Unit) {
        items[id]?.let { block(it) }; publish()
    }

    @Synchronized fun get(id: String): DownloadItem? = items[id]
    @Synchronized fun all(): List<DownloadItem> = items.values.toList()
    @Synchronized fun nextQueued(): DownloadItem? = items.values.firstOrNull { it.status == DlStatus.QUEUED }
    @Synchronized fun remove(id: String) { items.remove(id); publish() }

    private fun publish() { _flow.value = items.values.toList() }

    private fun isTikTok(url: String): Boolean {
        val host = try { Uri.parse(url).host?.lowercase() ?: "" } catch (e: Exception) { "" }
        return host == "tiktok.com" || host.endsWith(".tiktok.com") || host == "vm.tiktok.com"
    }

    /** Runs yt-dlp -J to fetch metadata. Blocking — call from IO dispatcher. */
    fun fetchMeta(url: String): VideoMeta {
        val req = YoutubeDLRequest(url).apply {
            addOption("--dump-single-json")
            addOption("--flat-playlist")
            addOption("--no-warnings")
            addOption("-R", "1")
            addOption("--socket-timeout", "15")
            // TikTok requires a realistic browser User-Agent to avoid 403/empty results
            if (isTikTok(url)) {
                addOption("--user-agent",
                    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 " +
                    "(KHTML, like Gecko) Chrome/125.0.6422.141 Safari/537.36")
                addOption("--extractor-args",
                    "tiktok:app_name=tiktok_web;app_version=1.0.0;manifest_app_version=1.0.0")
            }
        }
        val out = YoutubeDL.getInstance().execute(req).out
        val json = JSONObject(out.substring(out.indexOf('{')))
        val isPlaylist = json.optString("_type") == "playlist"
        val entries = mutableListOf<Pair<Int, String>>()
        if (isPlaylist) {
            val arr: JSONArray = json.optJSONArray("entries") ?: JSONArray()
            for (i in 0 until arr.length()) {
                val e = arr.optJSONObject(i) ?: continue
                entries.add(i + 1 to e.optString("title", "#${i + 1}"))
            }
        }
        return VideoMeta(
            url = url,
            title = json.optString("title", url),
            thumbnail = json.optString("thumbnail").takeIf { it.isNotBlank() },
            isPlaylist = isPlaylist,
            playlistTitle = if (isPlaylist) json.optString("title") else null,
            entries = entries,
        )
    }

    fun sanitize(name: String): String =
        name.replace(Regex("[\\\\/:*?\"<>|]"), "_").trim().take(120).ifBlank { "playlist" }

    fun buildRequest(ctx: Context, item: DownloadItem): YoutubeDLRequest {
        val prefs = Prefs.get(ctx)
        val baseDir = File(prefs.downloadDir)
        val outTemplate: String
        if (item.playlistTitle != null && prefs.organizePlaylists) {
            val dir = File(baseDir, sanitize(item.playlistTitle))
            outTemplate = "${dir.absolutePath}/%(playlist_index)02d - %(title)s.%(ext)s"
        } else {
            outTemplate = "${baseDir.absolutePath}/%(title)s.%(ext)s"
        }
        return YoutubeDLRequest(item.url).apply {
            addOption("-o", outTemplate)
            addOption("--no-mtime")
            addOption("--no-warnings")
            addOption("--restrict-filenames")
            if (item.playlistItems != null) addOption("--playlist-items", item.playlistItems)
            if (item.playlistTitle == null) addOption("--no-playlist")
            // TikTok-specific: needs desktop UA + app_name workaround
            if (isTikTok(item.url)) {
                addOption("--user-agent",
                    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 " +
                    "(KHTML, like Gecko) Chrome/125.0.6422.141 Safari/537.36")
                addOption("--extractor-args",
                    "tiktok:app_name=tiktok_web;app_version=1.0.0;manifest_app_version=1.0.0")
            }
            if (item.audioOnly) {
                addOption("-x")
                addOption("--audio-format", "mp3")
                addOption("--audio-quality", "0")
            } else {
                val fmt = when (item.quality) {
                    "best" -> "bestvideo+bestaudio/best"
                    else -> "bestvideo[height<=${item.quality}]+bestaudio/best[height<=${item.quality}]"
                }
                addOption("-f", fmt)
                addOption("--merge-output-format", "mp4")
            }
        }
    }

    fun hasSpace(ctx: Context): Boolean {
        return try {
            File(Prefs.get(ctx).downloadDir).apply { mkdirs() }.usableSpace > 500L * 1024 * 1024
        } catch (e: Exception) {
            Log.w(App.TAG, "space check failed", e)
            true
        }
    }
}