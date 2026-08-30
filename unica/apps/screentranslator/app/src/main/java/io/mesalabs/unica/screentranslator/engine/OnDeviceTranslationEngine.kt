package io.mesalabs.unica.screentranslator.engine

import android.util.Log
import android.util.LruCache
import com.google.mlkit.common.model.DownloadConditions
import com.google.mlkit.nl.translate.TranslateLanguage
import com.google.mlkit.nl.translate.Translation
import com.google.mlkit.nl.translate.Translator
import com.google.mlkit.nl.translate.TranslatorOptions
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.tasks.await
import kotlinx.coroutines.withContext
import org.json.JSONArray
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import java.net.URLEncoder

object OnDeviceTranslationEngine {
    private const val TAG = "TranslationEngine"
    private var activeTranslator: Translator? = null
    private var currentSourceLang: String = ""
    private var currentTargetLang: String = ""
    private var isModelReady = false

    // In-memory LRU cache for instant 0ms translation of recurrent text and game dialogues
    private val translationCache = LruCache<String, String>(3000)

    fun initialize(sourceLang: String = TranslateLanguage.ENGLISH, targetLang: String = TranslateLanguage.ARABIC) {
        if (activeTranslator != null && currentSourceLang == sourceLang && currentTargetLang == targetLang) {
            return
        }

        close()

        val options = TranslatorOptions.Builder()
            .setSourceLanguage(sourceLang)
            .setTargetLanguage(targetLang)
            .build()

        activeTranslator = Translation.getClient(options)
        currentSourceLang = sourceLang
        currentTargetLang = targetLang
        isModelReady = false

        // Pre-download model in background
        val conditions = DownloadConditions.Builder().build()
        activeTranslator?.downloadModelIfNeeded(conditions)
            ?.addOnSuccessListener {
                isModelReady = true
                Log.i(TAG, "On-device ML translation model ready: $sourceLang -> $targetLang")
            }
            ?.addOnFailureListener { e ->
                Log.w(TAG, "On-device model download pending/failed, fallback to online mode", e)
            }
    }

    suspend fun translateText(text: String): String = withContext(Dispatchers.Default) {
        val trimmed = text.trim()
        if (trimmed.isEmpty()) return@withContext ""

        // 1. Check instant cache (0ms)
        val cached = translationCache.get(trimmed)
        if (cached != null) {
            return@withContext cached
        }

        // 2. Try on-device ML Kit translation (Offline, Fast)
        val translator = activeTranslator
        if (translator != null && isModelReady) {
            try {
                val result = translator.translate(trimmed).await()
                if (result.isNotBlank()) {
                    translationCache.put(trimmed, result)
                    return@withContext result
                }
            } catch (e: Exception) {
                Log.w(TAG, "On-device translation exception, falling back to network", e)
            }
        }

        // 3. Instant Online Fallback (ensures 100% translation during initial download or unsupported languages)
        val fallbackResult = translateOnlineFallback(trimmed, currentSourceLang, currentTargetLang)
        if (fallbackResult.isNotBlank()) {
            translationCache.put(trimmed, fallbackResult)
            return@withContext fallbackResult
        }

        return@withContext trimmed
    }

    private suspend fun translateOnlineFallback(text: String, src: String, tgt: String): String = withContext(Dispatchers.IO) {
        try {
            val encodedText = URLEncoder.encode(text, "UTF-8")
            val sLang = if (src.isBlank() || src == "auto") "auto" else src
            val tLang = if (tgt.isBlank()) "ar" else tgt
            val urlStr = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=$sLang&tl=$tLang&dt=t&q=$encodedText"

            val url = URL(urlStr)
            val conn = (url.openConnection() as HttpURLConnection).apply {
                requestMethod = "GET"
                connectTimeout = 4000
                readTimeout = 4000
                setRequestProperty("User-Agent", "Mozilla/5.0")
            }

            if (conn.responseCode == 200) {
                val reader = BufferedReader(InputStreamReader(conn.inputStream, "UTF-8"))
                val response = reader.readText()
                reader.close()

                val jsonArray = JSONArray(response)
                val sentencesArray = jsonArray.optJSONArray(0) ?: return@withContext ""
                val sb = StringBuilder()
                for (i in 0 until sentencesArray.length()) {
                    val item = sentencesArray.optJSONArray(i)
                    if (item != null && item.length() > 0) {
                        sb.append(item.optString(0))
                    }
                }
                return@withContext sb.toString().trim()
            }
        } catch (_: Exception) {}
        return@withContext ""
    }

    fun close() {
        try {
            activeTranslator?.close()
        } catch (e: Exception) {
            Log.e(TAG, "Error closing translator", e)
        } finally {
            activeTranslator = null
            isModelReady = false
        }
    }
}