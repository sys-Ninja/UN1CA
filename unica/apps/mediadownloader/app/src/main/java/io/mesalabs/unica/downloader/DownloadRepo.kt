package io.mesalabs.unica.downloader

import android.content.Context
import android.net.Uri
import android.util.Log
import com.yausername.youtubedl_android.YoutubeDL
import com.yausername.youtubedl_android.YoutubeDLRequest
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.withContext
import org.json.JSONArray
import org.json.JSONObject
import java.io.File

enum class DlStatus {
    QUEUED, RUNNING, DONE, FAILED, CANCELLED
}

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
    var fileSize: Long = 0L,
    var dateAdded: Long = System.currentTimeMillis()
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

    @Synchronized fun add(item: DownloadItem) {
        items[item.id] = item
        publish()
    }

    @Synchronized
    fun update(id: String, block: (DownloadItem) -> Unit) {
        items[id]?.let { block(it) }
        publish()
    }

    @Synchronized fun get(id: String): DownloadItem? = items[id]
    @Synchronized fun all(): List<DownloadItem> = items.values.toList()
    @Synchronized fun nextQueued(): DownloadItem? = items.values.firstOrNull { it.status == DlStatus.QUEUED }
    @Synchronized fun remove(id: String) {
        items.remove(id)
        publish()
    }

    @Synchronized
    fun delete(item: DownloadItem) {
        item.filePath?.let { path ->
            try {
                val f = File(path)
                if (f.exists()) f.delete()
            } catch (_: Exception) {}
        }
        items.remove(item.id)
        publish()
    }

    private fun publish() {
        _flow.value = items.values.toList()
    }

    /**
     * Scans storage folder to ensure any downloaded file on disk is properly indexed and displayed!
     */
    suspend fun syncFromStorage(context: Context) = withContext(Dispatchers.IO) {
        val prefs = Prefs.get(context)
        val baseDir = File(prefs.downloadDir)
        if (!baseDir.exists()) return@withContext

        val foundFiles = mutableListOf<File>()
        fun scan(dir: File) {
            val list = dir.listFiles() ?: return
            for (f in list) {
                if (f.isDirectory) {
                    scan(f)
                } else {
                    val ext = f.extension.lowercase()
                    if (ext in listOf("mp4", "mp3", "m4a", "webm", "mkv", "mov", "flv")) {
                        foundFiles.add(f)
                    }
                }
            }
        }
        scan(baseDir)

        synchronized(DownloadRepo) {
            for (f in foundFiles) {
                val path = f.absolutePath
                val alreadyTracked = items.values.any { it.filePath == path }
                if (!alreadyTracked) {
                    val isAudio = f.extension.lowercase() in listOf("mp3", "m4a", "aac", "wav")
                    val item = DownloadItem(
                        id = "disk_${f.name}_${f.lastModified()}",
                        url = "",
                        title = f.nameWithoutExtension.replace('_', ' '),
                        audioOnly = isAudio,
                        quality = if (isAudio) "MP3" else "Video",
                        status = DlStatus.DONE,
                        progress = 100f,
                        filePath = path,
                        fileSize = f.length(),
                        dateAdded = f.lastModified()
                    )
                    items[item.id] = item
                }
            }
            publish()
        }
    }

    fun isTikTok(url: String): Boolean {
        val host = try { Uri.parse(url).host?.lowercase() ?: "" } catch (e: Exception) { "" }
        return host == "tiktok.com" || host.endsWith(".tiktok.com")
    }

    fun isPlaylistUrl(url: String): Boolean {
        val lower = url.lowercase()
        return lower.contains("list=") || lower.contains("/playlist") || lower.contains("/sets/")
    }

    fun getQuickThumbnail(url: String): String? {
        val ytRegex = Regex("(?:youtu\\.be/|youtube\\.com/(?:embed/|v/|watch\\?v=|watch\\?.+&v=))([\\w-]{11})")
        val match = ytRegex.find(url)
        if (match != null) {
            val id = match.groupValues[1]
            return "https://i.ytimg.com/vi/${id}/hqdefault.jpg"
        }
        return null
    }

    fun fetchMeta(url: String): VideoMeta {
        App.instance.ensureInit()
        val isPl = isPlaylistUrl(url)
        val req = YoutubeDLRequest(url).apply {
            addOption("--dump-single-json")
            addOption("--no-warnings")
            addOption("--no-check-certificates")
            addOption("-R", "2")
            addOption("--socket-timeout", "25")
            if (isPl) {
                addOption("--yes-playlist")
                addOption("--flat-playlist")
                addOption("--playlist-end", "100")
            } else {
                addOption("--no-playlist")
            }
            // Fast extractor arguments for YouTube to avoid JS engine bottlenecks
            addOption("--extractor-args", "youtube:player_client=android,web;skip=dash,translated_subs")
            addOption("--user-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36")
            if (isTikTok(url)) {
                addOption("--referer", "https://www.tiktok.com/")
            }
        }
        val out = YoutubeDL.getInstance().execute(req).out
        val json = JSONObject(out.substring(out.indexOf('{')))
        val isPlaylist = json.optString("_type") == "playlist" || json.has("entries")
        val entries = mutableListOf<Pair<Int, String>>()
        if (isPlaylist) {
            val arr: JSONArray = json.optJSONArray("entries") ?: JSONArray()
            for (i in 0 until arr.length()) {
                val e = arr.optJSONObject(i) ?: continue
                entries.add(i + 1 to e.optString("title", "#${i + 1}"))
            }
        }
        val thumb = json.optString("thumbnail").takeIf { it.isNotBlank() } ?: getQuickThumbnail(url)
        return VideoMeta(
            url = url,
            title = json.optString("title", url),
            thumbnail = thumb,
            isPlaylist = isPlaylist,
            playlistTitle = if (isPlaylist) json.optString("title") else null,
            entries = entries,
        )
    }

    fun sanitize(name: String): String =
        name.replace(Regex("[\\/:*?\"<>|]"), "_").trim().take(120).ifBlank { "playlist" }

    fun buildRequest(ctx: Context, item: DownloadItem): YoutubeDLRequest {
        App.instance.ensureInit(ctx)
        val prefs = Prefs.get(ctx)
        val baseDir = File(prefs.downloadDir)
        val isPl = item.playlistTitle != null || isPlaylistUrl(item.url)
        val outTemplate: String
        if (isPl && prefs.organizePlaylists) {
            val folderName = sanitize(item.playlistTitle ?: "Playlist")
            val dir = File(baseDir, folderName)
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
            addOption("--user-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36")
            // Anti-freeze, high-speed multi-threading and anti-throttling
            addOption("-N", "4")
            addOption("--http-chunk-size", "10M")
            addOption("--buffer-size", "64K")
            addOption("--retries", "10")
            addOption("--fragment-retries", "10")
            addOption("--file-access-retries", "5")
            addOption("--retry-sleep", "fragment:exp=1:10")
            addOption("--geo-bypass")
            addOption("--extractor-args", "instagram:app_id=ios;twitter:api=syndication;youtube:player_client=android,web;skip=dash,translated_subs")

            if (isPl) {
                addOption("--yes-playlist")
                addOption("--ignore-errors")
                addOption("--no-abort-on-error")
                if (item.playlistItems != null) {
                    addOption("--playlist-items", item.playlistItems)
                }
            } else {
                addOption("--no-playlist")
            }

            if (isTikTok(item.url)) {
                addOption("--referer", "https://www.tiktok.com/")
            }

            if (item.audioOnly) {
                addOption("-x")
                addOption("--audio-format", "mp3")
                addOption("--audio-quality", "0")
            } else {
                // Ensure 100% hardware decoding compatibility on Samsung devices (H.264 + AAC in MP4):
                addOption("-S", "vcodec:h264,lang,quality,res,fps,hdr:12,acodec:m4a,acodec:aac")
                val fmt = when (item.quality) {
                    "1080" -> "bestvideo[height<=1080]+bestaudio/best[height<=1080]/best"
                    "720"  -> "bestvideo[height<=720]+bestaudio/best[height<=720]/best"
                    "480"  -> "bestvideo[height<=480]+bestaudio/best[height<=480]/best"
                    else   -> "bestvideo+bestaudio/best"
                }
                addOption("-f", fmt)
                addOption("--merge-output-format", "mp4")
                addOption("--remux-video", "mp4")
                addOption("--postprocessor-args", "ffmpeg:-movflags +faststart")
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
