package io.mesalabs.unica.screentranslator.engine

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Color
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
import io.mesalabs.unica.screentranslator.overlay.TranslationBlock
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

    private fun sampleBackgroundColor(bitmap: Bitmap, rect: Rect): Pair<Int, Int> {
        var r = 0L
        var g = 0L
        var b = 0L
        var count = 0

        val expand = 2
        val left = (rect.left - expand).coerceAtLeast(0)
        val right = (rect.right + expand).coerceAtMost(bitmap.width - 1)
        val top = (rect.top - expand).coerceAtLeast(0)
        val bottom = (rect.bottom + expand).coerceAtMost(bitmap.height - 1)

        val pixels = intArrayOf(
            bitmap.getPixel(left, top),
            bitmap.getPixel(right, top),
            bitmap.getPixel(left, bottom),
            bitmap.getPixel(right, bottom),
            bitmap.getPixel(rect.centerX(), top),
            bitmap.getPixel(rect.centerX(), bottom),
            bitmap.getPixel(left, rect.centerY()),
            bitmap.getPixel(right, rect.centerY())
        )

        for (pixel in pixels) {
            r += Color.red(pixel)
            g += Color.green(pixel)
            b += Color.blue(pixel)
            count++
        }

        val avgR = (r / count).toInt()
        val avgG = (g / count).toInt()
        val avgB = (b / count).toInt()
        
        val bgColor = Color.rgb(avgR, avgG, avgB)
        
        // Luminance calculation
        val luminance = (0.299 * avgR + 0.587 * avgG + 0.114 * avgB) / 255.0
        val textColor = if (luminance < 0.5) Color.WHITE else Color.BLACK

        return Pair(bgColor, textColor)
    }

    private fun startProcessingLoop() {
        captureJob?.cancel()
        val prefs = TranslatorPrefs.get(context)
        val sourceLang = prefs.sourceLanguage
        val targetLang = prefs.targetLanguage

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

                        val currentHash = computeFastSampleHash(bitmap)
                        
                        // Dialog & Scene change detection
                        val diff = if (lastFrameHash != 0L) {
                            java.lang.Long.bitCount(currentHash xor lastFrameHash).toFloat() / 64f
                        } else 0f
                        
                        if (diff > 0.4f) {
                            // Large scene change
                            overlayView.hideTemporarily(1500)
                        }

                        if (currentHash != lastFrameHash) {
                            lastFrameHash = currentHash

                            val textBlocks = OnDeviceOcrEngine.processFrame(bitmap)
                            if (textBlocks.isNotEmpty()) {
                                val translationBlocks = mutableListOf<TranslationBlock>()
                                var totalBlockArea = 0

                                for (block in textBlocks) {
                                    for (line in block.lines) {
                                        val translated = OnDeviceTranslationEngine.translate(line.originalText, sourceLang, targetLang)
                                        if (translated.isNotBlank()) {
                                            val (bgColor, textColor) = sampleBackgroundColor(bitmap, line.boundingBox)
                                            
                                            translationBlocks.add(
                                                TranslationBlock(
                                                    rect = line.boundingBox,
                                                    text = translated,
                                                    bgColor = bgColor,
                                                    textColor = textColor
                                                )
                                            )
                                            totalBlockArea += (line.boundingBox.width() * line.boundingBox.height())
                                        }
                                    }
                                }

                                val screenArea = screenWidth * screenHeight
                                val blockAreaRatio = totalBlockArea.toFloat() / screenArea.toFloat()
                                
                                if (blockAreaRatio > 0.65f) {
                                    // Too much text, likely a full screen menu or dialog changing
                                    overlayView.hideTemporarily(2000)
                                } else {
                                    overlayView.setBlocks(translationBlocks)
                                }
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
        val stepX = (bitmap.width / 8).coerceAtLeast(1)
        val stepY = (bitmap.height / 8).coerceAtLeast(1)
        var bitPos = 0
        for (x in 0 until bitmap.width step stepX) {
            for (y in 0 until bitmap.height step stepY) {
                if (bitPos >= 64) break
                val pixel = bitmap.getPixel(x, y)
                val luminance = (Color.red(pixel) + Color.green(pixel) + Color.blue(pixel)) / 3
                if (luminance > 128) {
                    hash = hash or (1L shl bitPos)
                }
                bitPos++
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
