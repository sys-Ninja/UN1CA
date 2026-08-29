package io.mesalabs.unica.ghostengine.camera

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.PixelFormat
import android.view.Gravity
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.ImageButton
import io.mesalabs.unica.ghostengine.R
import io.mesalabs.unica.ghostengine.data.GhostEnginePrefs

class FloatingCameraToolController(
    private val context: Context,
    private val onPickMedia: () -> Unit
) {
    private val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    private var toolView: View? = null
    private val prefs = GhostEnginePrefs.get(context)
    private var isGhostActive = true

    @SuppressLint("InflateParams", "ClickableViewAccessibility")
    fun show() {
        if (toolView != null) return

        toolView = LayoutInflater.from(context).inflate(R.layout.floating_camera_tool, null)

        val btnToggle = toolView!!.findViewById<ImageButton>(R.id.btn_ghost_toggle)
        val btnPick = toolView!!.findViewById<ImageButton>(R.id.btn_pick_media)

        btnToggle.setOnClickListener {
            isGhostActive = !isGhostActive
            btnToggle.alpha = if (isGhostActive) 1.0f else 0.45f
            if (isGhostActive) {
                GhostCameraManager.resumeFeed()
            } else {
                GhostCameraManager.pauseFeed()
            }
        }

        btnPick.setOnClickListener { onPickMedia() }

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.END
            x = 24
            y = 300
        }

        var initialX = 0
        var initialY = 0
        var initialTouchX = 0f
        var initialTouchY = 0f

        toolView!!.setOnTouchListener { _, event ->
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    initialX = params.x
                    initialY = params.y
                    initialTouchX = event.rawX
                    initialTouchY = event.rawY
                    true
                }
                MotionEvent.ACTION_MOVE -> {
                    val dx = (initialTouchX - event.rawX).toInt()
                    val dy = (event.rawY - initialTouchY).toInt()
                    params.x = initialX + dx
                    params.y = initialY + dy
                    windowManager.updateViewLayout(toolView, params)
                    true
                }
                else -> false
            }
        }

        try {
            windowManager.addView(toolView, params)
        } catch (_: Exception) {}
    }

    fun hide() {
        if (toolView != null) {
            try {
                windowManager.removeView(toolView)
            } catch (_: Exception) {}
            toolView = null
        }
    }
}