package io.mesalabs.unica.ghostengine.location

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

class FloatingJoystickController(private val context: Context) {
    private val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    private var joystickView: View? = null
    private val prefs = GhostEnginePrefs.get(context)

    // Conversion: 1 degree latitude ~ 111,139 meters
    private val metersToLatDeg = 1.0 / 111139.0

    @SuppressLint("InflateParams", "ClickableViewAccessibility")
    fun show() {
        if (joystickView != null) return

        joystickView = LayoutInflater.from(context).inflate(R.layout.floating_joystick, null)

        val btnUp = joystickView!!.findViewById<ImageButton>(R.id.btn_up)
        val btnDown = joystickView!!.findViewById<ImageButton>(R.id.btn_down)
        val btnLeft = joystickView!!.findViewById<ImageButton>(R.id.btn_left)
        val btnRight = joystickView!!.findViewById<ImageButton>(R.id.btn_right)
        val btnSpeed = joystickView!!.findViewById<ImageButton>(R.id.btn_speed_toggle)

        btnUp.setOnClickListener { moveLocation(dNorth = 1.0, dEast = 0.0) }
        btnDown.setOnClickListener { moveLocation(dNorth = -1.0, dEast = 0.0) }
        btnLeft.setOnClickListener { moveLocation(dNorth = 0.0, dEast = -1.0) }
        btnRight.setOnClickListener { moveLocation(dNorth = 0.0, dEast = 1.0) }

        btnSpeed.setOnClickListener {
            // Cycle speeds: Walk (1.4 m/s) -> Cycle (4.5 m/s) -> Drive (14.0 m/s)
            val current = prefs.movementSpeed
            prefs.movementSpeed = when {
                current < 2.0f -> 4.5f
                current < 8.0f -> 14.0f
                else -> 1.4f
            }
        }

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.BOTTOM or Gravity.START
            x = 40
            y = 200
        }

        try {
            windowManager.addView(joystickView, params)
        } catch (_: Exception) {}
    }

    private fun moveLocation(dNorth: Double, dEast: Double) {
        val stepMeters = prefs.movementSpeed.toDouble() * 2.0
        val currentLat = prefs.spoofedLatitude
        val currentLng = prefs.spoofedLongitude

        val deltaLat = (dNorth * stepMeters) * metersToLatDeg
        val metersToLngDeg = 1.0 / (111139.0 * Math.cos(Math.toRadians(currentLat)))
        val deltaLng = (dEast * stepMeters) * metersToLngDeg

        prefs.spoofedLatitude = currentLat + deltaLat
        prefs.spoofedLongitude = currentLng + deltaLng
    }

    fun hide() {
        if (joystickView != null) {
            try {
                windowManager.removeView(joystickView)
            } catch (_: Exception) {}
            joystickView = null
        }
    }
}