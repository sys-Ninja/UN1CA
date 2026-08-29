package io.mesalabs.unica.screentranslator.engine

import android.graphics.Bitmap
import android.graphics.Rect
import android.util.Log
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.Text
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.TextRecognizer
import com.google.mlkit.vision.text.latin.TextRecognizerOptions
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.tasks.await
import kotlinx.coroutines.withContext

data class DetectedTextBlock(
    val originalText: String,
    val boundingBox: Rect,
    val lines: List<DetectedTextLine>
)

data class DetectedTextLine(
    val originalText: String,
    val boundingBox: Rect
)

object OnDeviceOcrEngine {
    private const val TAG = "OnDeviceOcrEngine"
    private var recognizer: TextRecognizer? = null

    fun initialize() {
        if (recognizer == null) {
            recognizer = TextRecognition.getClient(TextRecognizerOptions.DEFAULT_OPTIONS)
        }
    }

    suspend fun processFrame(bitmap: Bitmap): List<DetectedTextBlock> = withContext(Dispatchers.Default) {
        val rec = recognizer ?: return@withContext emptyList()
        val image = InputImage.fromBitmap(bitmap, 0)

        try {
            val result: Text = rec.process(image).await()
            val blocks = mutableListOf<DetectedTextBlock>()

            for (block in result.textBlocks) {
                val box = block.boundingBox ?: continue
                val lines = block.lines.mapNotNull { line ->
                    line.boundingBox?.let { lineBox ->
                        DetectedTextLine(line.text, lineBox)
                    }
                }
                if (lines.isNotEmpty()) {
                    blocks.add(DetectedTextBlock(block.text, box, lines))
                }
            }
            return@withContext blocks
        } catch (e: Exception) {
            Log.e(TAG, "OCR recognition error", e)
            return@withContext emptyList()
        }
    }

    fun close() {
        try {
            recognizer?.close()
        } catch (e: Exception) {
            Log.e(TAG, "Error closing OCR recognizer", e)
        } finally {
            recognizer = null
        }
    }
}