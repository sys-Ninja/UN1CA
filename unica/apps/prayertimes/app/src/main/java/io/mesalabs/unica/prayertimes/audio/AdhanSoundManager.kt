package io.mesalabs.unica.prayertimes.audio

import android.content.Context
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.net.Uri
import android.util.Log
import io.mesalabs.unica.prayertimes.Prefs
import io.mesalabs.unica.prayertimes.R
import io.mesalabs.unica.prayertimes.calc.Prayer

enum class AdhanSoundType {
    MAKKAH,
    MADINAH,
    AQSA,
    CAIRO,
    FAJR_FULL,
    TAKBEER,
    SOFT_CHIME,
    SILENT,
    CUSTOM
}

data class AdhanSoundEntry(
    val key: String,
    val type: AdhanSoundType,
    val titleResId: Int,
    val isOnlyForFajr: Boolean = false,
    val customUri: String? = null
)

object AdhanSoundManager {
    private const val TAG = "AdhanSoundManager"
    private var previewPlayer: MediaPlayer? = null
    private var currentlyPlayingKey: String? = null

    val ALL_BUILTIN_SOUNDS = listOf(
        AdhanSoundEntry("makkah", AdhanSoundType.MAKKAH, R.string.adhan_makkah),
        AdhanSoundEntry("madinah", AdhanSoundType.MADINAH, R.string.adhan_madinah),
        AdhanSoundEntry("aqsa", AdhanSoundType.AQSA, R.string.adhan_aqsa),
        AdhanSoundEntry("cairo", AdhanSoundType.CAIRO, R.string.adhan_cairo),
        AdhanSoundEntry("fajr_full", AdhanSoundType.FAJR_FULL, R.string.adhan_fajr_full, isOnlyForFajr = true),
        AdhanSoundEntry("takbeer", AdhanSoundType.TAKBEER, R.string.adhan_takbeer),
        AdhanSoundEntry("soft_chime", AdhanSoundType.SOFT_CHIME, R.string.adhan_soft_chime),
        AdhanSoundEntry("silent", AdhanSoundType.SILENT, R.string.adhan_silent),
        AdhanSoundEntry("custom", AdhanSoundType.CUSTOM, R.string.adhan_custom)
    )

    fun getSoundEntriesForPrayer(prayer: Prayer): List<AdhanSoundEntry> {
        return ALL_BUILTIN_SOUNDS.filter { entry ->
            if (entry.isOnlyForFajr) prayer == Prayer.FAJR else true
        }
    }

    fun getSoundUri(context: Context, prayer: String): Uri? {
        val prefs = Prefs.get(context)
        val soundKey = prefs.getAdhanSoundKey(prayer)

        if (soundKey == "silent") return null

        if (soundKey == "custom") {
            val customUriStr = prefs.getCustomAdhanUri(prayer)
            if (!customUriStr.isNullOrEmpty()) {
                return Uri.parse(customUriStr)
            }
        }

        // Check if there is a raw resource matching built-in name
        val resName = "adhan_$soundKey"
        val resId = context.resources.getIdentifier(resName, "raw", context.packageName)
        if (resId != 0) {
            return Uri.parse("android.resource://${context.packageName}/$resId")
        }

        // Fallback: System alarm sound
        return android.provider.Settings.System.DEFAULT_ALARM_ALERT_URI
    }

    fun startPreview(
        context: Context,
        soundKey: String,
        customUriStr: String? = null,
        onComplete: () -> Unit,
        onError: (Exception) -> Unit = {}
    ) {
        stopPreview()

        if (soundKey == "silent") {
            onComplete()
            return
        }

        try {
            val uri: Uri = if (soundKey == "custom" && !customUriStr.isNullOrEmpty()) {
                Uri.parse(customUriStr)
            } else {
                val resName = "adhan_$soundKey"
                val resId = context.resources.getIdentifier(resName, "raw", context.packageName)
                if (resId != 0) {
                    Uri.parse("android.resource://${context.packageName}/$resId")
                } else {
                    android.provider.Settings.System.DEFAULT_ALARM_ALERT_URI
                }
            }

            previewPlayer = MediaPlayer().apply {
                setDataSource(context, uri)
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .build()
                )
                setOnCompletionListener {
                    stopPreview()
                    onComplete()
                }
                setOnErrorListener { _, what, extra ->
                    stopPreview()
                    onError(RuntimeException("MediaPlayer error: what=$what extra=$extra"))
                    true
                }
                prepare()
                start()
            }
            currentlyPlayingKey = soundKey
        } catch (e: Exception) {
            Log.e(TAG, "Error playing sound preview: $soundKey", e)
            stopPreview()
            onError(e)
        }
    }

    fun stopPreview() {
        try {
            previewPlayer?.stop()
            previewPlayer?.release()
        } catch (e: Exception) {
            Log.e(TAG, "Error stopping preview", e)
        } finally {
            previewPlayer = null
            currentlyPlayingKey = null
        }
    }

    fun isPlaying(soundKey: String): Boolean {
        return currentlyPlayingKey == soundKey && previewPlayer?.isPlaying == true
    }

    fun getSoundTitle(context: Context, soundKey: String, prayer: String): String {
        if (soundKey == "custom") {
            val customUri = Prefs.get(context).getCustomAdhanUri(prayer)
            return if (!customUri.isNullOrEmpty()) {
                Uri.parse(customUri).lastPathSegment ?: context.getString(R.string.adhan_custom)
            } else {
                context.getString(R.string.adhan_custom)
            }
        }
        val entry = ALL_BUILTIN_SOUNDS.firstOrNull { it.key == soundKey }
        return if (entry != null) context.getString(entry.titleResId) else context.getString(R.string.default_sound)
    }
}