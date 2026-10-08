package io.mesalabs.unica.screentranslator.overlay

import android.animation.ValueAnimator
import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Rect
import android.graphics.Typeface
import android.view.View

data class TranslationBlock(
    val rect: Rect,
    val text: String,
    val bgColor: Int,
    val textColor: Int
)

class LiveSubtitleOverlayView(context: Context) : View(context) {

    private var blocks: List<TranslationBlock> = emptyList()
    private var visible = true
    private var currentAlpha = 255

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
        if (!visible) return
        blocks = newBlocks
        invalidate()
    }

    fun clearSubtitles() {
        blocks = emptyList()
        invalidate()
    }

    fun hideTemporarily(ms: Long = 1500) {
        if (!visible) return
        visible = false
        
        val fadeOut = ValueAnimator.ofInt(255, 0).apply {
            duration = 150
            addUpdateListener { animator ->
                currentAlpha = animator.animatedValue as Int
                invalidate()
            }
        }
        fadeOut.start()

        postDelayed({
            visible = true
            val fadeIn = ValueAnimator.ofInt(0, 255).apply {
                duration = 150
                addUpdateListener { animator ->
                    currentAlpha = animator.animatedValue as Int
                    invalidate()
                }
            }
            fadeIn.start()
        }, ms)
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        if (blocks.isEmpty() || currentAlpha == 0) return

        for (block in blocks) {
            val box = block.rect
            if (block.text.isBlank()) continue

            // Draw Background to occlude original text
            bgPaint.color = block.bgColor
            bgPaint.alpha = currentAlpha
            
            // Inflate rect slightly to cover edges
            val inflatedRect = Rect(box.left - 4, box.top - 4, box.right + 4, box.bottom + 4)
            canvas.drawRect(inflatedRect, bgPaint)

            // Calculate text properties
            val targetHeight = box.height().toFloat()
            val fontSize = (targetHeight * 0.85f).coerceIn(20f, 72f)
            
            textPaint.color = block.textColor
            textPaint.alpha = currentAlpha
            textPaint.textSize = fontSize

            // RTL support
            val containsArabic = block.text.any { it in '؀'..'ۿ' }
            if (containsArabic) {
                textPaint.textAlign = Paint.Align.RIGHT
            } else {
                textPaint.textAlign = Paint.Align.LEFT
            }

            val baselineY = box.bottom - (box.height() * 0.15f)
            val startX = if (containsArabic) {
                box.right.toFloat() - 4f
            } else {
                box.left.toFloat() + 4f
            }

            canvas.drawText(block.text, startX, baselineY, textPaint)
        }
    }
}
