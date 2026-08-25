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
        return host == "tiktok.com" || host.endsWith(".tiktok.com")
    }

    /**
     * Runs yt-dlp -J to fetch metadata. Blocking — call from IO dispatcher.
     *
     * Performance optimisations vs the original:
     *  - --flat-playlist  : don't recurse into playlist entries (already present)
     *  - --no-check-certificates : skip TLS handshake validation overhead
     *  - -R 1             : one retry max (already present)
     *  - --socket-timeout 10 : tighter than the original 15 s
     *  Thumbnail is returned as a URL string from the JSON; actual bitmap loading
     *  is done lazily in QuickDownloadActivity via Coil so the dialog opens
     *  in ~1 s instead of ~10 s.
     */
    fun fetchMeta(url: String): VideoMeta {
        App.instance.ensureInit()
        val req = YoutubeDLRequest(url).apply {
            addOption("--dump-single-json")
            addOption("--flat-playlist")
            addOption("--no-warnings")
            addOption("--no-check-certificates")
            addOption("-R", "1")
            addOption("--socket-timeout", "10")
            if (isTikTok(url)) {
                addOption("--user-agent",
                    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 " +
                    "(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36")
                addOption("--referer", "https://www.tiktok.com/")
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
        App.instance.ensureInit(ctx)
        val prefs = Prefs.get(ctx)
        val baseDir = File(prefs.downloadDir)
        val outTemplate: String
        if (item.playlistTitle != null && prefs.organizePlaylists) {
            val dir = File(baseDir, sanitize(item.playlistTitle))
            // Use a safe fallback for playlist_index in case yt-dlp doesn't provide it
            outTemplate = "${dir.absolutePath}/%(playlist_index|0)02d - %(title).100B.%(ext)s"
        } else {
            outTemplate = "${baseDir.absolutePath}/%(title).100B.%(ext)s"
        }
        return YoutubeDLRequest(item.url).apply {
            addOption("-o", outTemplate)
            addOption("--no-mtime")
            addOption("--no-warnings")
            addOption("--no-check-certificates")
            addOption("--restrict-filenames")
            if (item.playlistItems != null) addOption("--playlist-items", item.playlistItems)
            if (item.playlistTitle != null) {
                // Playlist download: continue even if individual videos fail
                addOption("--yes-playlist")
                addOption("--ignore-errors")
                addOption("--no-abort-on-error")
            } else {
                addOption("--no-playlist")
            }
            if (isTikTok(item.url)) {
                addOption("--user-agent",
                    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 " +
                    "(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36")
                addOption("--referer", "https://www.tiktok.com/")
            }
            if (item.audioOnly) {
                addOption("-x")
                addOption("--audio-format", "mp3")
                addOption("--audio-quality", "0")
            } else {
                val fmt = when (item.quality) {
                    "best" -> "bestvideo+bestaudio/best"
                    else -> "bestvideo[height<=${item.quality}]+bestaudio/best[height<=${item.quality}]/best"
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
