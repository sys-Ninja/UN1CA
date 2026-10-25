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

data class FastMeta(
    val title: String,
    val thumbnail: String?,
    val siteName: String
)

object FastMetaExtractor {
    private const val TAG = "FastMetaExtractor"
    private const val USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36"

    fun getQuickThumbnail(url: String): String? {
        val lower = url.lowercase()
        val id = when {
            lower.contains("youtu.be/") -> {
                url.substringAfter("youtu.be/").substringBefore("?").substringBefore("&").substringBefore("/")
            }
            lower.contains("watch?v=") -> {
                url.substringAfter("watch?v=").substringBefore("&").substringBefore("#")
            }
            lower.contains("watch?") && lower.contains("&v=") -> {
                url.substringAfter("&v=").substringBefore("&").substringBefore("#")
            }
            lower.contains("/embed/") -> {
                url.substringAfter("/embed/").substringBefore("?").substringBefore("/")
            }
            lower.contains("/v/") -> {
                url.substringAfter("/v/").substringBefore("?").substringBefore("/")
            }
            else -> null
        }?.trim()

        if (id != null && id.length in 10..12) {
            return "https://i.ytimg.com/vi/" + id + "/hqdefault.jpg"
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
                val jsonStr = httpGet(oembedUrl, 2500)
                if (jsonStr != null) {
                    val obj = JSONObject(jsonStr)
                    val title = obj.optString("title").takeIf { it.isNotBlank() } ?: "YouTube Video"
                    val thumb = obj.optString("thumbnail_url").takeIf { it.isNotBlank() } ?: quickThumb
                    val author = obj.optString("author_name")
                    val sub = if (author.isNotBlank()) "YOUTUBE • " + author else "YOUTUBE"
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
                val jsonStr = httpGet(oembedUrl, 2500)
                if (jsonStr != null) {
                    val obj = JSONObject(jsonStr)
                    val title = obj.optString("title").takeIf { it.isNotBlank() } ?: "TikTok Video"
                    val thumb = obj.optString("thumbnail_url").takeIf { it.isNotBlank() }
                    val author = obj.optString("author_name")
                    val sub = if (author.isNotBlank()) "TIKTOK • " + author else "TIKTOK"
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
                val jsonStr = httpGet(oembedUrl, 2500)
                if (jsonStr != null) {
                    val obj = JSONObject(jsonStr)
                    val author = obj.optString("author_name")
                    val sub = if (author.isNotBlank()) "X / TWITTER • " + author else "X / TWITTER"
                    return@withContext FastMeta("Post by " + author, null, sub)
                }
            } catch (e: Exception) {
                Log.w(TAG, "Twitter oembed error", e)
            }
        }

        // 4. Universal Fast HTML / OpenGraph scraper (reads first 32KB of HTML)
        try {
            val html = httpGetPartial(rawUrl, 32768, 3000)
            if (!html.isNullOrBlank()) {
                val ogTitle = extractMetaProperty(html, "og:title")
                    ?: extractMetaProperty(html, "twitter:title")
                    ?: extractTitleTag(html)

                val ogImage = extractMetaProperty(html, "og:image")
                    ?: extractMetaProperty(html, "twitter:image")

                val cleanTitle = ogTitle?.replace("&amp;", "&")
                    ?.replace("&#39;", "'")
                    ?.replace("&quot;", "\"")
                    ?.trim()

                if (!cleanTitle.isNullOrBlank()) {
                    return@withContext FastMeta(cleanTitle, ogImage, site)
                }
            }
        } catch (e: Exception) {
            Log.w(TAG, "HTML probe error for " + rawUrl, e)
        }

        FastMeta(site, null, site)
    }

    private fun extractMetaProperty(html: String, propName: String): String? {
        val lowerHtml = html.lowercase()
        val target = propName.lowercase()
        var searchIdx = 0
        while (searchIdx < lowerHtml.length) {
            val metaIdx = lowerHtml.indexOf("<meta", searchIdx)
            if (metaIdx == -1) break
            val closeIdx = lowerHtml.indexOf('>', metaIdx)
            if (closeIdx == -1) break
            val tag = html.substring(metaIdx, closeIdx + 1)
            val lowerTag = lowerHtml.substring(metaIdx, closeIdx + 1)
            if (lowerTag.contains(target)) {
                val contentIdx = lowerTag.indexOf("content=")
                if (contentIdx != -1) {
                    val remaining = tag.substring(contentIdx + 8).trimStart()
                    if (remaining.isNotEmpty()) {
                        val firstChar = remaining[0]
                        if (firstChar == '"' || firstChar == '\'') {
                            val endQuote = remaining.indexOf(firstChar, 1)
                            if (endQuote != -1) {
                                val value = remaining.substring(1, endQuote).trim()
                                if (value.isNotEmpty()) return value
                            }
                        }
                    }
                }
            }
            searchIdx = closeIdx + 1
        }
        return null
    }

    private fun extractTitleTag(html: String): String? {
        val lower = html.lowercase()
        val start = lower.indexOf("<title")
        if (start != -1) {
            val tagClose = lower.indexOf('>', start)
            if (tagClose != -1) {
                val end = lower.indexOf("</title>", tagClose)
                if (end != -1) {
                    val t = html.substring(tagClose + 1, end).trim()
                    if (t.isNotEmpty()) return t
                }
            }
        }
        return null
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
