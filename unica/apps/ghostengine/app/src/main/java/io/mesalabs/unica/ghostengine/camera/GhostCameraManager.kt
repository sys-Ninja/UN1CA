package io.mesalabs.unica.ghostengine.camera

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.media.MediaPlayer
import android.net.Uri
import android.util.Log
import android.view.Surface
import io.mesalabs.unica.ghostengine.data.GhostEnginePrefs
import java.io.InputStream

object GhostCameraManager {
    private const val TAG = "GhostCameraManager"
    private var mediaPlayer: MediaPlayer? = null
    private var staticBitmap: Bitmap? = null
    private var isPlaying = false

    fun prepareMedia(context: Context) {
        val prefs = GhostEnginePrefs.get(context)
        val uriStr = prefs.mediaUri ?: return
        val uri = Uri.parse(uriStr)

        release()

        if (prefs.isVideoMedia) {
            try {
                mediaPlayer = MediaPlayer().apply {
                    setDataSource(context, uri)
                    isLooping = true
                    prepare()
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error preparing video feed", e)
            }
        } else {
            try {
                val inputStream: InputStream? = context.contentResolver.openInputStream(uri)
                staticBitmap = BitmapFactory.decodeStream(inputStream)
                inputStream?.close()
            } catch (e: Exception) {
                Log.e(TAG, "Error decoding image feed", e)
            }
        }
    }

    fun startFeed(surface: Surface) {
        if (mediaPlayer != null) {
            try {
                mediaPlayer?.setSurface(surface)
                mediaPlayer?.start()
                isPlaying = true
            } catch (e: Exception) {
                Log.e(TAG, "Error starting video surface feed", e)
            }
        }
    }

    fun pauseFeed() {
        if (mediaPlayer != null && isPlaying) {
            mediaPlayer?.pause()
            isPlaying = false
        }
    }

    fun resumeFeed() {
        if (mediaPlayer != null && !isPlaying) {
            mediaPlayer?.start()
            isPlaying = true
        }
    }

    fun getStaticBitmap(): Bitmap? = staticBitmap

    fun release() {
        try {
            mediaPlayer?.stop()
            mediaPlayer?.release()
        } catch (_: Exception) {}
        mediaPlayer = null
        staticBitmap?.recycle()
        staticBitmap = null
        isPlaying = false
    }
}