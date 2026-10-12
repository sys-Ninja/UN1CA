package io.mesalabs.unica.ghostengine.camera

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Color
import android.graphics.PixelFormat
import android.view.ContextThemeWrapper
import android.view.Gravity
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.ImageButton
import android.widget.TextView
import android.widget.Toast
import io.mesalabs.unica.ghostengine.R
import io.mesalabs.unica.ghostengine.data.GhostEnginePrefs

class FloatingCameraToolController(
    private val context: Context,
    private val onPickMedia: (slot: Int) -> Unit
) {
    private val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    private var toolView: View? = null
    private val prefs = GhostEnginePrefs.get(context)
    private var isGhostActive = true
    var currentSlot = 1
        private set

    // Slot metadata
    private val slotLabels = mapOf(
        1 to "\uD83D\uDC64 Selfie",
        2 to "\uD83E\uDEAA ID Front",
        3 to "\uD83E\uDEAA ID Back"
    )
    private val slotColors = mapOf(
        1 to "#00C853",   // green = front camera
        2 to "#2979FF",  // blue = back camera
        3 to "#2979FF"   // blue = back camera
    )

    @SuppressLint("InflateParams", "ClickableViewAccessibility")
    fun show() {
        if (toolView != null) return

        // Wrap context with Theme.GhostEngine to avoid InflateException
        // when resolving ?attr/ attributes in a WindowManager overlay context
        val themedContext = ContextThemeWrapper(context, R.style.Theme_GhostEngine)
        toolView = LayoutInflater.from(themedContext).inflate(R.layout.floating_camera_tool, null)

        val btnToggle = toolView!!.findViewById<ImageButton>(R.id.btn_ghost_toggle)
        val btnSlot1  = toolView!!.findViewById<TextView>(R.id.btn_slot_1)
        val btnSlot2  = toolView!!.findViewById<TextView>(R.id.btn_slot_2)
        val btnSlot3  = toolView!!.findViewById<TextView>(R.id.btn_slot_3)
        val btnNext   = toolView!!.findViewById<ImageButton>(R.id.btn_next_media)
        val btnPick   = toolView!!.findViewById<ImageButton>(R.id.btn_pick_media)
        val lblStatus = toolView!!.findViewById<TextView>(R.id.lbl_slot_status)

        fun updateHighlights() {
            listOf(1 to btnSlot1, 2 to btnSlot2, 3 to btnSlot3).forEach { (slot, btn) ->
                val active = slot == currentSlot
                btn.setTextColor(Color.parseColor(if (active) slotColors[slot]!! else "#AAAAAA"))
                btn.alpha = if (active) 1.0f else 0.6f
            }
            lblStatus?.text = slotLabels[currentSlot] ?: "Slot $currentSlot"
            // Show which camera is active
            val camLabel = if (currentSlot == 1) "\uD83D\uDCF7 Front Cam" else "\uD83D\uDCF7 Back Cam"
            lblStatus?.append("  $camLabel")
        }

        fun switchToSlot(slot: Int) {
            currentSlot = slot
            updateHighlights()
            GhostCameraManager.switchSlot(context, slot)
            val label = slotLabels[slot] ?: "Slot $slot"
            Toast.makeText(context, label, Toast.LENGTH_SHORT).show()
        }

        updateHighlights()

        btnToggle.setOnClickListener {
            isGhostActive = !isGhostActive
            btnToggle.alpha = if (isGhostActive) 1.0f else 0.4f
            if (isGhostActive) GhostCameraManager.resumeAll() else GhostCameraManager.pauseAll()
        }

        btnSlot1.setOnClickListener { switchToSlot(1) }
        btnSlot2.setOnClickListener { switchToSlot(2) }
        btnSlot3.setOnClickListener { switchToSlot(3) }
        btnNext.setOnClickListener  { switchToSlot(if (currentSlot >= 3) 1 else currentSlot + 1) }
        btnPick.setOnClickListener  { onPickMedia(currentSlot) }

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.END
            x = 16; y = 280
        }

        var ix = 0; var iy = 0; var tx = 0f; var ty = 0f
        toolView!!.setOnTouchListener { _, event ->
            when (event.action) {
                MotionEvent.ACTION_DOWN -> { ix = params.x; iy = params.y; tx = event.rawX; ty = event.rawY; true }
                MotionEvent.ACTION_MOVE -> {
                    params.x = ix + (tx - event.rawX).toInt()
                    params.y = iy + (event.rawY - ty).toInt()
                    windowManager.updateViewLayout(toolView, params); true
                }
                else -> false
            }
        }

        try { windowManager.addView(toolView, params) } catch (_: Exception) {}
    }

    fun hide() {
        toolView?.let {
            try { windowManager.removeView(it) } catch (_: Exception) {}
            toolView = null
        }
    }
}
