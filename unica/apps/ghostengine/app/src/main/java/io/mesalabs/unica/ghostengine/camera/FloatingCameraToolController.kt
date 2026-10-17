package io.mesalabs.unica.ghostengine.camera

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Color
import android.graphics.PixelFormat
import android.os.Build
import android.view.Gravity
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.View
import android.view.ViewConfiguration
import android.view.WindowManager
import android.widget.TextView
import android.widget.Toast
import io.mesalabs.unica.ghostengine.R
import kotlin.math.hypot

class FloatingCameraToolController(
    private val context: Context,
    private val onOpenSettings: () -> Unit
) {
    private val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    private var toolView: View? = null
    private var isExpanded = true

    // Layout references
    private var layoutExpanded: View? = null
    private var layoutBubble: View? = null

    // UI elements
    private var txtPauseSymbol: TextView? = null
    private var txtPauseText: TextView? = null
    private var txtSpeedVal: TextView? = null
    private var txtPreset1Num: TextView? = null
    private var txtPreset2Num: TextView? = null
    private var txtCameraSymbol: TextView? = null
    private var txtCameraText: TextView? = null
    private var btnMirror: View? = null

    @SuppressLint("InflateParams", "ClickableViewAccessibility")
    fun show() {
        if (toolView != null) return

        toolView = LayoutInflater.from(context).inflate(R.layout.floating_camera_tool, null)

        layoutExpanded = toolView!!.findViewById(R.id.layout_expanded_panel)
        layoutBubble = toolView!!.findViewById(R.id.layout_minimized_bubble)

        val btnMinimize = toolView!!.findViewById<View>(R.id.btn_minimize)
        val btnClose = toolView!!.findViewById<View>(R.id.btn_close)

        // Row 1
        val btnPause = toolView!!.findViewById<View>(R.id.btn_pause)
        txtPauseSymbol = toolView!!.findViewById(R.id.txt_pause_symbol)
        txtPauseText = toolView!!.findViewById(R.id.txt_pause_text)

        val btnUp = toolView!!.findViewById<View>(R.id.btn_up)

        val btnSpeed = toolView!!.findViewById<View>(R.id.btn_speed)
        txtSpeedVal = toolView!!.findViewById(R.id.txt_speed_val)

        val btnPreset1 = toolView!!.findViewById<View>(R.id.btn_preset1)
        txtPreset1Num = toolView!!.findViewById(R.id.txt_preset1_num)

        // Row 2
        val btnLeft = toolView!!.findViewById<View>(R.id.btn_left)
        val btnReset = toolView!!.findViewById<View>(R.id.btn_reset)
        val btnRight = toolView!!.findViewById<View>(R.id.btn_right)

        val btnPreset2 = toolView!!.findViewById<View>(R.id.btn_preset2)
        txtPreset2Num = toolView!!.findViewById(R.id.txt_preset2_num)

        // Row 3
        val btnSeek = toolView!!.findViewById<View>(R.id.btn_seek)
        val btnDown = toolView!!.findViewById<View>(R.id.btn_down)
        val btnRestart = toolView!!.findViewById<View>(R.id.btn_restart)
        val btnZoomOut = toolView!!.findViewById<View>(R.id.btn_zoom_out)

        // Row 4
        val btnRotate = toolView!!.findViewById<View>(R.id.btn_rotate)
        btnMirror = toolView!!.findViewById(R.id.btn_mirror)
        val btnZoomIn = toolView!!.findViewById<View>(R.id.btn_zoom_in)

        val btnCameraToggle = toolView!!.findViewById<View>(R.id.btn_camera_toggle)
        txtCameraSymbol = toolView!!.findViewById(R.id.txt_camera_symbol)
        txtCameraText = toolView!!.findViewById(R.id.txt_camera_text)

        // Layout Params
        val layoutType = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        } else {
            @Suppress("DEPRECATION")
            WindowManager.LayoutParams.TYPE_PHONE
        }

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            layoutType,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.START
            x = 40
            y = 200
        }

        // Draggable touch setup on root
        var initialX = 0
        var initialY = 0
        var touchStartX = 0f
        var touchStartY = 0f
        val touchSlop = ViewConfiguration.get(context).scaledTouchSlop

        val dragListener = View.OnTouchListener { v, event ->
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    initialX = params.x
                    initialY = params.y
                    touchStartX = event.rawX
                    touchStartY = event.rawY
                    true
                }
                MotionEvent.ACTION_MOVE -> {
                    params.x = initialX + (event.rawX - touchStartX).toInt()
                    params.y = initialY + (event.rawY - touchStartY).toInt()
                    try {
                        windowManager.updateViewLayout(toolView, params)
                    } catch (_: Exception) {}
                    true
                }
                MotionEvent.ACTION_UP -> {
                    val dist = hypot((event.rawX - touchStartX).toDouble(), (event.rawY - touchStartY).toDouble())
                    if (dist < touchSlop) {
                        v.performClick()
                    }
                    true
                }
                else -> false
            }
        }

        // Set drag listener on Minimized bubble
        layoutBubble?.setOnTouchListener(dragListener)
        layoutBubble?.setOnClickListener {
            // Restore expanded panel
            setExpandedMode(true, params)
        }

        // Minimize Button
        btnMinimize?.setOnClickListener {
            setExpandedMode(false, params)
        }

        // Close Button
        btnClose?.setOnClickListener {
            hide()
        }

        // Row 1 Actions
        btnPause?.setOnClickListener {
            val isPaused = GhostCameraManager.togglePause()
            updatePauseUI(isPaused)
        }

        btnUp?.setOnClickListener {
            GhostCameraManager.pan(0f, -30f)
        }

        btnSpeed?.setOnClickListener {
            val speed = GhostCameraManager.cycleSpeed()
            txtSpeedVal?.text = "${String.format("%.1f", speed)}×"
        }

        btnPreset1?.setOnClickListener {
            GhostCameraManager.switchSlot(context, 1)
            updatePresetUI(1)
            Toast.makeText(context, "Slot 1 (Front/Selfie)", Toast.LENGTH_SHORT).show()
        }

        // Row 2 Actions
        btnLeft?.setOnClickListener {
            GhostCameraManager.pan(-30f, 0f)
        }

        btnReset?.setOnClickListener {
            GhostCameraManager.resetTransform()
            updateTransformUI()
            Toast.makeText(context, R.string.reset_transform_toast, Toast.LENGTH_SHORT).show()
        }

        btnRight?.setOnClickListener {
            GhostCameraManager.pan(30f, 0f)
        }

        btnPreset2?.setOnClickListener {
            GhostCameraManager.switchSlot(context, 2)
            updatePresetUI(2)
            Toast.makeText(context, "Slot 2 (Back/ID)", Toast.LENGTH_SHORT).show()
        }

        // Row 3 Actions
        btnSeek?.setOnClickListener {
            GhostCameraManager.seekRelative(-5000)
        }

        btnDown?.setOnClickListener {
            GhostCameraManager.pan(0f, 30f)
        }

        btnRestart?.setOnClickListener {
            GhostCameraManager.restartVideo()
        }

        btnZoomOut?.setOnClickListener {
            GhostCameraManager.zoom(-0.1f)
        }

        // Row 4 Actions
        btnRotate?.setOnClickListener {
            GhostCameraManager.rotate90()
        }

        btnMirror?.setOnClickListener {
            val mirrored = GhostCameraManager.toggleMirror()
            btnMirror?.isSelected = mirrored
        }

        btnZoomIn?.setOnClickListener {
            GhostCameraManager.zoom(0.1f)
        }

        btnCameraToggle?.setOnClickListener {
            val passthrough = GhostCameraManager.togglePassthrough()
            updatePassthroughUI(passthrough)
        }

        // Sync initial UI state
        updatePauseUI(GhostCameraManager.isPaused)
        updatePresetUI(GhostCameraManager.currentSlot)
        updatePassthroughUI(GhostCameraManager.isPassthrough)
        txtSpeedVal?.text = "${String.format("%.1f", GhostCameraManager.speedMultiplier)}×"

        try {
            windowManager.addView(toolView, params)
        } catch (_: Exception) {}
    }

    private fun setExpandedMode(expanded: Boolean, params: WindowManager.LayoutParams) {
        isExpanded = expanded
        if (expanded) {
            layoutBubble?.visibility = View.GONE
            layoutExpanded?.visibility = View.VISIBLE
        } else {
            layoutExpanded?.visibility = View.GONE
            layoutBubble?.visibility = View.VISIBLE
        }
        try {
            windowManager.updateViewLayout(toolView, params)
        } catch (_: Exception) {}
    }

    private fun updatePauseUI(isPaused: Boolean) {
        if (isPaused) {
            txtPauseSymbol?.text = "▶"
            txtPauseText?.text = "Play"
        } else {
            txtPauseSymbol?.text = "||"
            txtPauseText?.text = "Pause"
        }
    }

    private fun updatePresetUI(slot: Int) {
        txtPreset1Num?.setTextColor(if (slot == 1) Color.parseColor("#00E676") else Color.WHITE)
        txtPreset2Num?.setTextColor(if (slot == 2) Color.parseColor("#00E676") else Color.WHITE)
    }

    private fun updatePassthroughUI(passthrough: Boolean) {
        if (passthrough) {
            txtCameraSymbol?.text = "⦿"
            txtCameraSymbol?.setTextColor(Color.parseColor("#FFA000"))
            txtCameraText?.text = "Real"
            Toast.makeText(context, R.string.passthrough_camera_on, Toast.LENGTH_SHORT).show()
        } else {
            txtCameraSymbol?.text = "⦿"
            txtCameraSymbol?.setTextColor(Color.parseColor("#00E676"))
            txtCameraText?.text = "Virtual"
            Toast.makeText(context, R.string.passthrough_camera_off, Toast.LENGTH_SHORT).show()
        }
    }

    private fun updateTransformUI() {
        btnMirror?.isSelected = GhostCameraManager.isMirrored
    }

    fun hide() {
        toolView?.let {
            try {
                windowManager.removeView(it)
            } catch (_: Exception) {}
            toolView = null
        }
    }
}
