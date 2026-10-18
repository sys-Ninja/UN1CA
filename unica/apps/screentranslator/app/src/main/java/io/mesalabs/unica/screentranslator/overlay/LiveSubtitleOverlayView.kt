package io.mesalabs.unica.screentranslator.overlay

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Rect
import android.graphics.RectF
import android.graphics.Typeface
import android.os.Handler
import android.os.Looper
import android.view.View

data class TranslationBlock(
    val rect: Rect,
    val text: String,
    val bgColor: Int,
    val textColor: Int
)

class LiveSubtitleOverlayView(context: Context) : View(context) {

    private val mainHandler = Handler(Looper.getMainLooper())
    private var blocks: List<TranslationBlock> = emptyList()

    private val bgPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.FILL
    }

    private val textPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        typeface = Typeface.create(Typeface.DEFAULT, Typeface.BOLD)
    }

    init {
        setBackgroundColor(Color.TRANSPARENT)
    }

    fun setBlocks(newBlocks: List<TranslationBlock>) {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            blocks = newBlocks
            invalidate()
        } else {
            mainHandler.post {
                blocks = newBlocks
                invalidate()
            }
        }
    }

    fun clearSubtitles() {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            blocks = emptyList()
            invalidate()
        } else {
            mainHandler.post {
                blocks = emptyList()
                invalidate()
            }
        }
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        if (blocks.isEmpty()) return

        for (block in blocks) {
            val box = block.rect
            val text = block.text.trim()
            if (text.isBlank()) continue

            // 1. Inflate rect by 3px to completely mask and occlude original underlying text
            val inflatedRect = RectF(
                (box.left - 3).toFloat(),
                (box.top - 2).toFloat(),
                (box.right + 3).toFloat(),
                (box.bottom + 2).toFloat()
            )

            // Draw rounded mask card directly in place
            bgPaint.color = block.bgColor
            canvas.drawRoundRect(inflatedRect, 6f, 6f, bgPaint)

            // 2. Compute dynamic font size to perfectly fit inside the bounding box
            val targetHeight = box.height().toFloat()
            var fontSize = (targetHeight * 0.78f).coerceIn(14f, 64f)
            textPaint.textSize = fontSize

            val maxTextWidth = (inflatedRect.width() - 8f).coerceAtLeast(10f)
            while (textPaint.measureText(text) > maxTextWidth && fontSize > 11f) {
                fontSize -= 1.5f
                textPaint.textSize = fontSize
            }

            textPaint.color = block.textColor

            // 3. Exact vertical baseline centering
            val fontMetrics = textPaint.fontMetrics
            val centerY = box.centerY().toFloat()
            val baselineY = centerY - (fontMetrics.descent + fontMetrics.ascent) / 2f

            // 4. RTL / LTR Alignment
            val containsArabic = text.any { it in '؀'..'ۿ' }
            if (containsArabic) {
                textPaint.textAlign = Paint.Align.RIGHT
                val startX = inflatedRect.right - 4f
                canvas.drawText(text, startX, baselineY, textPaint)
            } else {
                textPaint.textAlign = Paint.Align.LEFT
                val startX = inflatedRect.left + 4f
                canvas.drawText(text, startX, baselineY, textPaint)
            }
        }
    }
}
