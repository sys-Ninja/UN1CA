package io.mesalabs.unica.downloader

import android.net.Uri
import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONObject
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import java.util.regex.Pattern

data class FastMeta(
    val title: String,
    val thumbnail: String?,
    val siteName: String
)

object FastMetaExtractor {
    private const val TAG = "FastMetaExtractor"
    private const val USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36"

    private val YT_PATTERN = Pattern.compile("(?:youtu\\.be/|youtube\\.com/(?:embed/|v/|watch\\?v=|watch\\?.+&v=))([\\w-]{11})")

    fun getQuickThumbnail(url: String): String? {
        val m = YT_PATTERN.matcher(url)
        if (m.find()) {
            val id = m.group(1)
            return "https://i.ytimg.com/vi/$id/hqdefault.jpg"
        }
        return null
    }

    suspend fun extract(rawUrl: String): FastMeta? = withContext(Dispatchers.IO) {
        val uri = try { Uri.parse(rawUrl) } catch (_: Exception) { return@withContext null }
        val host = uri.host?.lowercase() ?: ""
        val site = host.removePrefix("www.").removePrefix("m.").uppercase()

        // 1. YouTube instant oEmbed (returns JSON in ~100ms)
        if (host.contains("youtube.com") || host.contains("youtu.be")) {
            val quickThumb = getQuickThumbnail(rawUrl)
            try {
                val oembedUrl = "https://www.youtube.com/oembed?url=" + Uri.encode(rawUrl) + "&format=json"
                val jsonStr = httpGet(oembedUrl, timeoutMs = 2500)
                if (jsonStr != null) {
                    val obj = JSONObject(jsonStr)
                    val title = obj.optString("title").takeIf { it.isNotBlank() } ?: "YouTube Video"
                    val thumb = obj.optString("thumbnail_url").takeIf { it.isNotBlank() } ?: quickThumb
                    val author = obj.optString("author_name")
                    val sub = if (author.isNotBlank()) "YOUTUBE • $author" else "YOUTUBE"
                    return@withContext FastMeta(title, thumb, sub)
                }
            } catch (e: Exception) {
                Log.w(TAG, "YouTube oembed probe error", e)
            }
            if (quickThumb != null) {
                return@withContext FastMeta("YouTube Video", quickThumb, "YOUTUBE")
            }
        }

        // 2. TikTok instant oEmbed
        if (host.contains("tiktok.com")) {
            try {
                val oembedUrl = "https://www.tiktok.com/oembed?url=" + Uri.encode(rawUrl)
                val jsonStr = httpGet(oembedUrl, timeoutMs = 2500)
                if (jsonStr != null) {
                    val obj = JSONObject(jsonStr)
                    val title = obj.optString("title").takeIf { it.isNotBlank() } ?: "TikTok Video"
                    val thumb = obj.optString("thumbnail_url").takeIf { it.isNotBlank() }
                    val author = obj.optString("author_name")
                    val sub = if (author.isNotBlank()) "TIKTOK • $author" else "TIKTOK"
                    return@withContext FastMeta(title, thumb, sub)
                }
            } catch (e: Exception) {
                Log.w(TAG, "TikTok oembed error", e)
            }
        }

        // 3. Twitter / X instant oEmbed
        if (host.contains("twitter.com") || host.contains("x.com")) {
            try {
                val oembedUrl = "https://publish.twitter.com/oembed?url=" + Uri.encode(rawUrl)
                val jsonStr = httpGet(oembedUrl, timeoutMs = 2500)
                if (jsonStr != null) {
                    val obj = JSONObject(jsonStr)
                    val author = obj.optString("author_name")
                    val sub = if (author.isNotBlank()) "X / TWITTER • $author" else "X / TWITTER"
                    return@withContext FastMeta("Post by $author", null, sub)
                }
            } catch (e: Exception) {
                Log.w(TAG, "Twitter oembed error", e)
            }
        }

        // 4. Universal Fast HTML / OpenGraph scraper (reads first 32KB of HTML)
        try {
            val html = httpGetPartial(rawUrl, maxBytes = 32768, timeoutMs = 3000)
            if (!html.isNullOrBlank()) {
                val ogTitle = extractMetaProperty(html, "og:title")
                    ?: extractMetaProperty(html, "twitter:title")
                    ?: extractTitleTag(html)

                val ogImage = extractMetaProperty(html, "og:image")
                    ?: extractMetaProperty(html, "twitter:image")
                    ?: extractTagHref(html, "image_src")

                val cleanTitle = ogTitle?.replace("&amp;", "&")
                    ?.replace("&#39;", "'")
                    ?.replace("&quot;", "\"")
                    ?.trim()

                if (!cleanTitle.isNullOrBlank()) {
                    return@withContext FastMeta(cleanTitle, ogImage, site)
                }
            }
        } catch (e: Exception) {
            Log.w(TAG, "HTML probe error for $rawUrl", e)
        }

        FastMeta(site, null, site)
    }

    private fun extractMetaProperty(html: String, propName: String): String? {
        val q = Pattern.quote(propName)
        val p1 = Pattern.compile("<meta[^>]+(?:property|name)\\s*=\\s*["']" + q + "["'][^>]+content\\s*=\\s*["']([^"']+)["']", Pattern.CASE_INSENSITIVE)
        val m1 = p1.matcher(html)
        if (m1.find()) return m1.group(1)?.trim()

        val p2 = Pattern.compile("<meta[^>]+content\\s*=\\s*["']([^"']+)["'][^>]+(?:property|name)\\s*=\\s*["']" + q + "["']", Pattern.CASE_INSENSITIVE)
        val m2 = p2.matcher(html)
        if (m2.find()) return m2.group(1)?.trim()

        return null
    }

    private fun extractTitleTag(html: String): String? {
        val p = Pattern.compile("<title[^>]*>([^<]+)</title>", Pattern.CASE_INSENSITIVE)
        val m = p.matcher(html)
        return if (m.find()) m.group(1)?.trim() else null
    }

    private fun extractTagHref(html: String, relName: String): String? {
        val q = Pattern.quote(relName)
        val p = Pattern.compile("<link[^>]+rel\\s*=\\s*["']" + q + "["'][^>]+href\\s*=\\s*["']([^"']+)["']", Pattern.CASE_INSENSITIVE)
        val m = p.matcher(html)
        return if (m.find()) m.group(1)?.trim() else null
    }

    private fun httpGet(urlStr: String, timeoutMs: Int): String? {
        var conn: HttpURLConnection? = null
        return try {
            val u = URL(urlStr)
            conn = (u.openConnection() as HttpURLConnection).apply {
                connectTimeout = timeoutMs
                readTimeout = timeoutMs
                instanceFollowRedirects = true
                setRequestProperty("User-Agent", USER_AGENT)
                setRequestProperty("Accept", "application/json, text/plain, */*")
            }
            if (conn.responseCode in 200..299) {
                conn.inputStream.bufferedReader().use { it.readText() }
            } else null
        } catch (_: Exception) {
            null
        } finally {
            conn?.disconnect()
        }
    }

    private fun httpGetPartial(urlStr: String, maxBytes: Int, timeoutMs: Int): String? {
        var conn: HttpURLConnection? = null
        return try {
            val u = URL(urlStr)
            conn = (u.openConnection() as HttpURLConnection).apply {
                connectTimeout = timeoutMs
                readTimeout = timeoutMs
                instanceFollowRedirects = true
                setRequestProperty("User-Agent", USER_AGENT)
                setRequestProperty("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
            }
            if (conn.responseCode in 200..299) {
                val reader = BufferedReader(InputStreamReader(conn.inputStream))
                val sb = StringBuilder()
                val buf = CharArray(2048)
                var total = 0
                var read: Int
                while (reader.read(buf).also { read = it } != -1 && total < maxBytes) {
                    sb.append(buf, 0, read)
                    total += read
                    val current = sb.toString()
                    if (current.contains("</head>", ignoreCase = true)) break
                }
                sb.toString()
            } else null
        } catch (_: Exception) {
            null
        } finally {
            conn?.disconnect()
        }
    }
}
