package io.mesalabs.unica.screentranslator.service

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.IBinder
import android.view.WindowManager
import androidx.core.app.NotificationCompat
import io.mesalabs.unica.screentranslator.R
import io.mesalabs.unica.screentranslator.data.TranslatorPrefs
import io.mesalabs.unica.screentranslator.engine.OnDeviceOcrEngine
import io.mesalabs.unica.screentranslator.engine.OnDeviceTranslationEngine
import io.mesalabs.unica.screentranslator.engine.ScreenCaptureEngine
import io.mesalabs.unica.screentranslator.overlay.FloatingBubbleController
import io.mesalabs.unica.screentranslator.overlay.LiveSubtitleOverlayView

class ScreenTranslatorService : Service() {

    private var windowManager: WindowManager? = null
    private var overlayView: LiveSubtitleOverlayView? = null
    private var captureEngine: ScreenCaptureEngine? = null
    private var bubbleController: FloatingBubbleController? = null
    private var mediaProjection: MediaProjection? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action

        if (action == ACTION_STOP) {
            stopSelf()
            return START_NOT_STICKY
        }

        startForeground(2001, createNotification())

        val resultCode = intent?.getIntExtra(EXTRA_RESULT_CODE, 0) ?: 0
        val resultData = intent?.getParcelableExtra<Intent>(EXTRA_RESULT_DATA)

        if (resultCode != 0 && resultData != null && captureEngine == null) {
            val mpManager = getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
            mediaProjection = mpManager.getMediaProjection(resultCode, resultData)

            initEngines()
            setupOverlay()
            startCapture()
        }

        return START_STICKY
    }

    private fun initEngines() {
        val prefs = TranslatorPrefs.get(this)
        OnDeviceOcrEngine.initialize()
        OnDeviceTranslationEngine.initialize(prefs.sourceLanguage, prefs.targetLanguage)
    }

    private fun setupOverlay() {
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
        overlayView = LiveSubtitleOverlayView(this)

        // 100% Touch-through layer: All user touches pass directly to the game (0ms lag!)
        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE or
                    WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                    WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS or
                    WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED,
            PixelFormat.TRANSLUCENT
        )

        try {
            windowManager?.addView(overlayView, params)
        } catch (_: Exception) {}

        val prefs = TranslatorPrefs.get(this)
        if (prefs.showFloatingBubble) {
            bubbleController = FloatingBubbleController(this) { isEnabled ->
                if (isEnabled) {
                    captureEngine?.start()
                } else {
                    captureEngine?.stop()
                }
            }
            bubbleController?.show()
        }
    }

    private fun startCapture() {
        val mp = mediaProjection ?: return
        val overlay = overlayView ?: return

        captureEngine = ScreenCaptureEngine(this, mp, overlay)
        captureEngine?.start()
        TranslatorPrefs.get(this).isServiceEnabled = true
    }

    private fun createNotification(): Notification {
        val channelId = "screen_translator_channel"
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nm.createNotificationChannel(
            NotificationChannel(
                channelId,
                getString(R.string.app_name),
                NotificationManager.IMPORTANCE_LOW
            )
        )

        val stopIntent = PendingIntent.getService(
            this, 0,
            Intent(this, ScreenTranslatorService::class.java).setAction(ACTION_STOP),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, channelId)
            .setSmallIcon(android.R.drawable.ic_menu_rotate)
            .setContentTitle(getString(R.string.app_name))
            .setContentText(getString(R.string.service_running_sum))
            .addAction(0, getString(R.string.stop), stopIntent)
            .setOngoing(true)
            .build()
    }

    override fun onDestroy() {
        captureEngine?.stop()
        captureEngine = null

        bubbleController?.hide()
        bubbleController = null

        if (overlayView != null) {
            try {
                windowManager?.removeView(overlayView)
            } catch (_: Exception) {}
            overlayView = null
        }

        mediaProjection?.stop()
        mediaProjection = null

        OnDeviceOcrEngine.close()
        OnDeviceTranslationEngine.close()

        TranslatorPrefs.get(this).isServiceEnabled = false
        super.onDestroy()
    }

    companion object {
        const val ACTION_STOP = "io.mesalabs.unica.screentranslator.STOP"
        const val EXTRA_RESULT_CODE = "extra_result_code"
        const val EXTRA_RESULT_DATA = "extra_result_data"
    }
}