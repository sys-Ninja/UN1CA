package io.mesalabs.unica.screentranslator.engine

import android.content.Context
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

object OnDeviceTranslationEngine {
    private const val TAG = "TranslationEngine"
    private var activeTranslator: Translator? = null
    private var currentSourceLang: String = ""
    private var currentTargetLang: String = ""
    
    // In-memory LRU cache for instant 0ms translation of recurrent text and game dialogues
    private val translationCache = LruCache<String, String>(2000)

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

        // Pre-download model if needed
        val conditions = DownloadConditions.Builder().build()
        activeTranslator?.downloadModelIfNeeded(conditions)
            ?.addOnSuccessListener { Log.i(TAG, "Translation model ready: $sourceLang -> $targetLang") }
            ?.addOnFailureListener { e -> Log.e(TAG, "Model download failed", e) }
    }

    suspend fun translateText(text: String): String = withContext(Dispatchers.Default) {
        val trimmed = text.trim()
        if (trimmed.isEmpty()) return@withContext ""

        // Check instant cache
        val cached = translationCache.get(trimmed)
        if (cached != null) {
            return@withContext cached
        }

        val translator = activeTranslator ?: return@withContext trimmed

        try {
            val result = translator.translate(trimmed).await()
            translationCache.put(trimmed, result)
            return@withContext result
        } catch (e: Exception) {
            Log.e(TAG, "Translation failed for: $trimmed", e)
            return@withContext trimmed
        }
    }

    fun close() {
        try {
            activeTranslator?.close()
        } catch (e: Exception) {
            Log.e(TAG, "Error closing translator", e)
        } finally {
            activeTranslator = null
        }
    }
}