package io.mesalabs.unica.ghostengine.camera

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.IBinder
import androidx.core.app.NotificationCompat
import io.mesalabs.unica.ghostengine.GhostEngineSettingsActivity
import io.mesalabs.unica.ghostengine.R
import io.mesalabs.unica.ghostengine.data.GhostEnginePrefs
import io.mesalabs.unica.ghostengine.location.FloatingJoystickController
import io.mesalabs.unica.ghostengine.location.StealthLocationManager

class GhostCameraService : Service() {

    private var floatingTool: FloatingCameraToolController? = null
    private var joystickController: FloatingJoystickController? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action

        if (action == ACTION_STOP) {
            stopSelf()
            return START_NOT_STICKY
        }

        startForeground(3001, createNotification())
        applyActiveEngines()

        return START_STICKY
    }

    private fun applyActiveEngines() {
        val prefs = GhostEnginePrefs.get(this)

        if (prefs.isGhostCameraEnabled) {
            GhostCameraManager.prepareMedia(this)
            if (prefs.showCameraTool) {
                floatingTool = FloatingCameraToolController(this) {
                    val launchIntent = Intent(this, GhostEngineSettingsActivity::class.java).apply {
                        flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    }
                    startActivity(launchIntent)
                }
                floatingTool?.show()
            }
        }

        if (prefs.isStealthGpsEnabled) {
            StealthLocationManager.startSpoofing(this)
            if (prefs.showFloatingJoystick) {
                joystickController = FloatingJoystickController(this)
                joystickController?.show()
            }
        }
    }

    private fun createNotification(): Notification {
        val channelId = "ghost_engine_channel"
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
            Intent(this, GhostCameraService::class.java).setAction(ACTION_STOP),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, channelId)
            .setSmallIcon(android.R.drawable.ic_menu_camera)
            .setContentTitle(getString(R.string.app_name))
            .setContentText(getString(R.string.service_running_sum))
            .addAction(0, getString(R.string.stop), stopIntent)
            .setOngoing(true)
            .build()
    }

    override fun onDestroy() {
        floatingTool?.hide()
        floatingTool = null

        joystickController?.hide()
        joystickController = null

        GhostCameraManager.release()
        StealthLocationManager.stopSpoofing(this)

        super.onDestroy()
    }

    companion object {
        const val ACTION_STOP = "io.mesalabs.unica.ghostengine.STOP"
    }
}