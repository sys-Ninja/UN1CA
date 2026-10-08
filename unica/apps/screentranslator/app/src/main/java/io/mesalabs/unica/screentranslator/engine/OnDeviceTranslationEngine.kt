package io.mesalabs.unica.screentranslator.engine

import android.util.Log
import com.google.mlkit.common.model.DownloadConditions
import com.google.mlkit.nl.translate.TranslateLanguage
import com.google.mlkit.nl.translate.Translation
import com.google.mlkit.nl.translate.Translator
import com.google.mlkit.nl.translate.TranslatorOptions
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.tasks.await
import kotlinx.coroutines.withContext
import org.json.JSONObject
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import java.net.URLEncoder

class OnDeviceTranslationEngine {
    companion object {
        private const val TAG = "TranslationEngine"
        private val cache = object : LinkedHashMap<String, String>(100, 0.75f, true) {
            override fun removeEldestEntry(eldest: Map.Entry<String, String>) = size > 3000
        }
        private var mlKitTranslator: Translator? = null
        private var currentSourceLang: String = ""
        private var currentTargetLang: String = ""
        private var isModelReady = false

        fun initialize(sourceLang: String = TranslateLanguage.ENGLISH, targetLang: String = TranslateLanguage.ARABIC) {
            if (mlKitTranslator != null && currentSourceLang == sourceLang && currentTargetLang == targetLang) {
                return
            }
            close()
            
            val options = TranslatorOptions.Builder()
                .setSourceLanguage(sourceLang)
                .setTargetLanguage(targetLang)
                .build()

            mlKitTranslator = Translation.getClient(options)
            currentSourceLang = sourceLang
            currentTargetLang = targetLang
            isModelReady = false

            val conditions = DownloadConditions.Builder().build()
            mlKitTranslator?.downloadModelIfNeeded(conditions)
                ?.addOnSuccessListener {
                    isModelReady = true
                    Log.i(TAG, "On-device ML translation model ready")
                }
                ?.addOnFailureListener { e ->
                    Log.w(TAG, "Model download failed", e)
                }
        }

        suspend fun translate(text: String, sourceLang: String = "en", targetLang: String = "ar"): String = withContext(Dispatchers.Default) {
            val trimmed = text.trim()
            if (trimmed.isEmpty()) return@withContext ""

            val key = "$sourceLang|$targetLang|$trimmed"
            cache[key]?.let { return@withContext it }

            // 1. ML Kit on-device
            if (isModelReady) {
                try {
                    val result = mlKitTranslator?.translate(trimmed)?.await()
                    if (!result.isNullOrBlank()) {
                        cache[key] = result
                        return@withContext result
                    }
                } catch (e: Exception) {
                    Log.w(TAG, "ML Kit translation failed", e)
                }
            }

            // 2. Google Unofficial
            try {
                val result = googleUnofficial(trimmed, sourceLang, targetLang)
                if (result.isNotBlank()) {
                    cache[key] = result
                    return@withContext result
                }
            } catch (e: Exception) {
                Log.w(TAG, "Google Unofficial failed", e)
            }

            // 3. MyMemory
            try {
                val result = myMemory(trimmed, sourceLang, targetLang)
                if (result.isNotBlank()) {
                    cache[key] = result
                    return@withContext result
                }
            } catch (e: Exception) {
                Log.w(TAG, "MyMemory failed", e)
            }

            return@withContext trimmed // fallback
        }

        private suspend fun googleUnofficial(text: String, src: String, tgt: String): String = withContext(Dispatchers.IO) {
            try {
                val encodedText = URLEncoder.encode(text, "UTF-8")
                val sLang = if (src.isBlank()) "auto" else src
                val urlStr = "https://clients5.google.com/translate_a/t?client=dict-chrome-ex&sl=$sLang&tl=$tgt&q=$encodedText"
                
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

                    val jsonObject = JSONObject(response)
                    val sentencesArray = jsonObject.optJSONArray("sentences") ?: return@withContext ""
                    val sb = StringBuilder()
                    for (i in 0 until sentencesArray.length()) {
                        val item = sentencesArray.optJSONObject(i)
                        if (item != null) {
                            val trans = item.optString("trans", "")
                            sb.append(trans)
                        }
                    }
                    return@withContext sb.toString().trim()
                }
            } catch (e: Exception) {
                Log.e(TAG, "googleUnofficial error", e)
            }
            return@withContext ""
        }

        private suspend fun myMemory(text: String, src: String, tgt: String): String = withContext(Dispatchers.IO) {
            try {
                val encodedText = URLEncoder.encode(text, "UTF-8")
                val sLang = if (src.isBlank() || src == "auto") "en" else src
                val urlStr = "https://api.mymemory.translated.net/get?q=$encodedText&langpair=$sLang|$tgt"
                
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

                    val jsonObject = JSONObject(response)
                    val responseData = jsonObject.optJSONObject("responseData")
                    if (responseData != null) {
                        return@withContext responseData.optString("translatedText", "").trim()
                    }
                }
            } catch (e: Exception) {
                Log.e(TAG, "myMemory error", e)
            }
            return@withContext ""
        }

        fun close() {
            try {
                mlKitTranslator?.close()
            } catch (e: Exception) {
                Log.e(TAG, "Error closing translator", e)
            } finally {
                mlKitTranslator = null
                isModelReady = false
            }
        }
    }
}
