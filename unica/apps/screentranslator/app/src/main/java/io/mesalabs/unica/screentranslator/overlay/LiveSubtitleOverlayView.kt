package io.mesalabs.unica.screentranslator.overlay

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Rect
import android.graphics.Typeface
import android.view.View
import io.mesalabs.unica.screentranslator.data.TranslatorPrefs
import java.util.concurrent.CopyOnWriteArrayList

data class SubtitleRenderItem(
    val translatedText: String,
    val boundingBox: Rect,
    val originalWidth: Int,
    val originalHeight: Int
)

class LiveSubtitleOverlayView(context: Context) : View(context) {

    private val items = CopyOnWriteArrayList<SubtitleRenderItem>()
    private val prefs = TranslatorPrefs.get(context)

    // Two-pass Paint for seamless cinema-style outlined subtitles (No ugly boxes!)
    private val strokePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeJoin = Paint.Join.ROUND
        strokeCap = Paint.Cap.ROUND
        typeface = Typeface.create(Typeface.DEFAULT, Typeface.BOLD)
    }

    private val fillPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.FILL
        typeface = Typeface.create(Typeface.DEFAULT, Typeface.BOLD)
    }

    fun updateSubtitles(newItems: List<SubtitleRenderItem>) {
        items.clear()
        items.addAll(newItems)
        postInvalidate()
    }

    fun clearSubtitles() {
        if (items.isNotEmpty()) {
            items.clear()
            postInvalidate()
        }
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        if (items.isEmpty()) return

        val textColor = prefs.textColor
        val strokeColor = prefs.strokeColor
        val strokeW = prefs.strokeWidth

        strokePaint.color = strokeColor
        strokePaint.strokeWidth = strokeW
        fillPaint.color = textColor

        for (item in items) {
            val box = item.boundingBox
            val text = item.translatedText
            if (text.isBlank()) continue

            // Auto-fit font size based on bounding box height
            val targetHeight = box.height().toFloat()
            val fontSize = (targetHeight * 0.82f).coerceIn(24f, 68f)

            strokePaint.textSize = fontSize
            fillPaint.textSize = fontSize

            val textWidth = fillPaint.measureText(text)
            val startX = (box.left + (box.width() - textWidth) / 2f).coerceAtLeast(box.left.toFloat())
            val baselineY = box.bottom - (box.height() * 0.2f)

            // Pass 1: Draw dark outline (gives high contrast against any game background)
            canvas.drawText(text, startX, baselineY, strokePaint)

            // Pass 2: Draw crisp text fill
            canvas.drawText(text, startX, baselineY, fillPaint)
        }
    }
}