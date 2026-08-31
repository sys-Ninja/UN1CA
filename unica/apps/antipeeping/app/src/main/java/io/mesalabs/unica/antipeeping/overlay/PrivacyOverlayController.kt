package io.mesalabs.unica.antipeeping.overlay

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Color
import android.graphics.PixelFormat
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.Button
import android.widget.TextView
import io.mesalabs.unica.antipeeping.R
import io.mesalabs.unica.antipeeping.data.AntiPeepingPrefs

class PrivacyOverlayController(private val context: Context) {

    private val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    private val vibrator = context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
    private var bannerView: View? = null
    private var isShowing = false

    @SuppressLint("InflateParams")
    fun showThreat(actionType: String, onSnoozeClicked: () -> Unit) {
        if (isShowing) return
        isShowing = true

        // Haptic feedback
        if (actionType == AntiPeepingPrefs.ACTION_HAPTIC || actionType == AntiPeepingPrefs.ACTION_ALERT) {
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    vibrator.vibrate(VibrationEffect.createWaveform(longArrayOf(0, 120, 80, 120), -1))
                } else {
                    @Suppress("DEPRECATION")
                    vibrator.vibrate(longArrayOf(0, 120, 80, 120), -1)
                }
            } catch (_: Exception) {}
        }

        if (actionType == AntiPeepingPrefs.ACTION_HAPTIC) {
            // Haptic only mode: don't show visual overlay
            return
        }

        val layoutId = if (actionType == AntiPeepingPrefs.ACTION_BLUR) {
            R.layout.privacy_blur_overlay
        } else {
            R.layout.privacy_warning_banner
        }

        bannerView = LayoutInflater.from(context).inflate(layoutId, null)

        val btnSnooze = bannerView?.findViewById<Button>(R.id.btn_snooze_cowatch)
        btnSnooze?.setOnClickListener {
            hideThreat()
            onSnoozeClicked()
        }

        val flags = if (actionType == AntiPeepingPrefs.ACTION_BLUR) {
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                    WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS
        } else {
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                    WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS
        }

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            if (actionType == AntiPeepingPrefs.ACTION_BLUR) WindowManager.LayoutParams.MATCH_PARENT else WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            flags,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = if (actionType == AntiPeepingPrefs.ACTION_BLUR) Gravity.CENTER else Gravity.TOP
            y = if (actionType == AntiPeepingPrefs.ACTION_BLUR) 0 else 60
        }

        try {
            windowManager.addView(bannerView, params)
        } catch (_: Exception) {}
    }

    fun hideThreat() {
        if (!isShowing) return
        isShowing = false
        if (bannerView != null) {
            try {
                windowManager.removeView(bannerView)
            } catch (_: Exception) {}
            bannerView = null
        }
    }
}