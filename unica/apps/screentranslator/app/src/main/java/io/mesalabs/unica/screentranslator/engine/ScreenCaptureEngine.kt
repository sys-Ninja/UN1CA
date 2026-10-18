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
import kotlinx.coroutines.withContext
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

    @Volatile
    private var isPaused = false

    fun start() {
        if (virtualDisplay != null) {
            resume()
            return
        }

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

        // Android 14+ (API 34+): Must register callback BEFORE createVirtualDisplay
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            mediaProjection.registerCallback(object : android.media.projection.MediaProjection.Callback() {
                override fun onStop() {
                    Log.d(TAG, "MediaProjection stopped externally")
                }
            }, android.os.Handler(android.os.Looper.getMainLooper()))
        }

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

        isPaused = false
        startProcessingLoop()
    }

    fun pause() {
        isPaused = true
        overlayView.clearSubtitles()
    }

    fun resume() {
        isPaused = false
    }

    private fun sampleBackgroundColor(bitmap: Bitmap, rect: Rect): Pair<Int, Int> {
        var r = 0L
        var g = 0L
        var b = 0L
        var count = 0

        val expand = 3
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
                if (isPaused) {
                    delay(250)
                    continue
                }

                try {
                    val image = imageReader?.acquireLatestImage()
                    if (image != null) {
                        val planes = image.planes
                        val buffer: ByteBuffer = planes[0].buffer
                        val pixelStride = planes[0].pixelStride
                        val rowStride = planes[0].rowStride
                        val rowPadding = rowStride - pixelStride * screenWidth

                        val rawBitmap = Bitmap.createBitmap(
                            screenWidth + rowPadding / pixelStride,
                            screenHeight,
                            Bitmap.Config.ARGB_8888
                        )
                        rawBitmap.copyPixelsFromBuffer(buffer)
                        image.close()

                        // Exact pixel-perfect 1:1 screen matching:
                        val bitmap = if (rowPadding == 0) {
                            rawBitmap
                        } else {
                            val cropped = Bitmap.createBitmap(rawBitmap, 0, 0, screenWidth, screenHeight)
                            rawBitmap.recycle()
                            cropped
                        }

                        val currentHash = computeFastSampleHash(bitmap)

                        if (currentHash != lastFrameHash) {
                            lastFrameHash = currentHash

                            val textBlocks = OnDeviceOcrEngine.processFrame(bitmap)
                            if (textBlocks.isNotEmpty()) {
                                val translationBlocks = mutableListOf<TranslationBlock>()

                                for (block in textBlocks) {
                                    for (line in block.lines) {
                                        val trimmed = line.originalText.trim()
                                        if (trimmed.length < 2) continue

                                        val translated = OnDeviceTranslationEngine.translate(trimmed, sourceLang, targetLang)
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
                                        }
                                    }
                                }

                                if (translationBlocks.isNotEmpty()) {
                                    withContext(Dispatchers.Main) {
                                        overlayView.setBlocks(translationBlocks)
                                    }
                                }
                            } else {
                                withContext(Dispatchers.Main) {
                                    overlayView.clearSubtitles()
                                }
                            }
                        }

                        if (bitmap !== rawBitmap) {
                            bitmap.recycle()
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
