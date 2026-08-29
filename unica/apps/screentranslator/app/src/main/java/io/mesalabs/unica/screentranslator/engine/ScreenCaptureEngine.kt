package io.mesalabs.unica.screentranslator.engine

import android.content.Context
import android.graphics.Bitmap
import android.graphics.PixelFormat
import android.graphics.Rect
import android.hardware.display.DisplayManager
import android.hardware.display.VirtualDisplay
import android.media.ImageReader
import android.media.projection.MediaProjection
import android.util.DisplayMetrics
import android.util.Log
import android.view.WindowManager
import io.mesalabs.unica.screentranslator.data.TranslatorPrefs
import io.mesalabs.unica.screentranslator.overlay.LiveSubtitleOverlayView
import io.mesalabs.unica.screentranslator.overlay.SubtitleRenderItem
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import java.nio.ByteBuffer

class ScreenCaptureEngine(
    private val context: Context,
    private val mediaProjection: MediaProjection,
    private val overlayView: LiveSubtitleOverlayView
) {
    private val TAG = "ScreenCaptureEngine"
    private var virtualDisplay: VirtualDisplay? = null
    private var imageReader: ImageReader? = null
    private var captureJob: Job? = null
    private val scope = CoroutineScope(Dispatchers.Default)

    private var screenWidth = 1080
    private var screenHeight = 2400
    private var screenDensity = 420

    private var lastFrameHash = 0L

    fun start() {
        val wm = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val metrics = DisplayMetrics()
        @Suppress("DEPRECATION")
        wm.defaultDisplay.getRealMetrics(metrics)

        screenWidth = metrics.widthPixels
        screenHeight = metrics.heightPixels
        screenDensity = metrics.densityDpi

        imageReader = ImageReader.newInstance(
            screenWidth,
            screenHeight,
            PixelFormat.RGBA_8888,
            2
        )

        virtualDisplay = mediaProjection.createVirtualDisplay(
            "ScreenTranslatorCapture",
            screenWidth,
            screenHeight,
            screenDensity,
            DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR,
            imageReader!!.surface,
            null,
            null
        )

        startProcessingLoop()
    }

    private fun startProcessingLoop() {
        captureJob?.cancel()
        val prefs = TranslatorPrefs.get(context)

        captureJob = scope.launch {
            while (isActive) {
                try {
                    val image = imageReader?.acquireLatestImage()
                    if (image != null) {
                        val planes = image.planes
                        val buffer: ByteBuffer = planes[0].buffer
                        val pixelStride = planes[0].pixelStride
                        val rowStride = planes[0].rowStride
                        val rowPadding = rowStride - pixelStride * screenWidth

                        val bitmap = Bitmap.createBitmap(
                            screenWidth + rowPadding / pixelStride,
                            screenHeight,
                            Bitmap.Config.ARGB_8888
                        )
                        bitmap.copyPixelsFromBuffer(buffer)
                        image.close()

                        // Fast frame hash check to avoid redundant OCR on static frames
                        val currentHash = computeFastSampleHash(bitmap)
                        if (currentHash != lastFrameHash) {
                            lastFrameHash = currentHash

                            // 1. Run On-Device OCR
                            val textBlocks = OnDeviceOcrEngine.processFrame(bitmap)
                            if (textBlocks.isNotEmpty()) {
                                val subtitleItems = mutableListOf<SubtitleRenderItem>()

                                for (block in textBlocks) {
                                    for (line in block.lines) {
                                        val translated = OnDeviceTranslationEngine.translateText(line.originalText)
                                        if (translated.isNotBlank()) {
                                            subtitleItems.add(
                                                SubtitleRenderItem(
                                                    translatedText = translated,
                                                    boundingBox = line.boundingBox,
                                                    originalWidth = screenWidth,
                                                    originalHeight = screenHeight
                                                )
                                            )
                                        }
                                    }
                                }
                                overlayView.updateSubtitles(subtitleItems)
                            } else {
                                overlayView.clearSubtitles()
                            }
                        }
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Frame processing error", e)
                }

                val delayMs = (1000 / prefs.fpsCap.coerceIn(4, 15)).toLong()
                delay(delayMs)
            }
        }
    }

    private fun computeFastSampleHash(bitmap: Bitmap): Long {
        var hash = 0L
        val stepX = (bitmap.width / 16).coerceAtLeast(1)
        val stepY = (bitmap.height / 16).coerceAtLeast(1)
        for (x in 0 until bitmap.width step stepX) {
            for (y in 0 until bitmap.height step stepY) {
                hash = 31 * hash + bitmap.getPixel(x, y)
            }
        }
        return hash
    }

    fun stop() {
        captureJob?.cancel()
        captureJob = null
        try {
            virtualDisplay?.release()
            virtualDisplay = null
            imageReader?.close()
            imageReader = null
        } catch (e: Exception) {
            Log.e(TAG, "Error stopping capture engine", e)
        }
        overlayView.clearSubtitles()
    }
}