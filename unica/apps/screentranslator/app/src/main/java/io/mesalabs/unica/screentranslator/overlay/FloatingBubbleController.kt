package io.mesalabs.unica.screentranslator.overlay

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.PixelFormat
import android.view.Gravity
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.ImageView
import io.mesalabs.unica.screentranslator.R

class FloatingBubbleController(
    private val context: Context,
    private val onToggleTranslate: (Boolean) -> Unit
) {
    private val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    private var bubbleView: View? = null
    private var isTranslating = true

    @SuppressLint("ClickableViewAccessibility", "InflateParams")
    fun show() {
        if (bubbleView != null) return

        bubbleView = LayoutInflater.from(context).inflate(R.layout.floating_bubble, null)
        val icon = bubbleView!!.findViewById<ImageView>(R.id.image_bubble_icon)

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.START
            x = 24
            y = 400
        }

        var initialX = 0
        var initialY = 0
        var initialTouchX = 0f
        var initialTouchY = 0f
        var isClick = true

        bubbleView!!.setOnTouchListener { _, event ->
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    initialX = params.x
                    initialY = params.y
                    initialTouchX = event.rawX
                    initialTouchY = event.rawY
                    isClick = true
                    true
                }
                MotionEvent.ACTION_MOVE -> {
                    val dx = (event.rawX - initialTouchX).toInt()
                    val dy = (event.rawY - initialTouchY).toInt()
                    if (Math.abs(dx) > 10 || Math.abs(dy) > 10) {
                        isClick = false
                    }
                    params.x = initialX + dx
                    params.y = initialY + dy
                    windowManager.updateViewLayout(bubbleView, params)
                    true
                }
                MotionEvent.ACTION_UP -> {
                    if (isClick) {
                        isTranslating = !isTranslating
                        icon.alpha = if (isTranslating) 1.0f else 0.45f
                        onToggleTranslate(isTranslating)
                    }
                    true
                }
                else -> false
            }
        }

        try {
            windowManager.addView(bubbleView, params)
        } catch (_: Exception) {}
    }

    fun hide() {
        if (bubbleView != null) {
            try {
                windowManager.removeView(bubbleView)
            } catch (_: Exception) {}
            bubbleView = null
        }
    }
}