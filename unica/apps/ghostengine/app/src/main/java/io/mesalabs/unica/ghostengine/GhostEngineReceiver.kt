package io.mesalabs.unica.ghostengine

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import io.mesalabs.unica.ghostengine.camera.GhostCameraService
import io.mesalabs.unica.ghostengine.data.GhostEnginePrefs
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class GhostEngineReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        val prefs = GhostEnginePrefs.get(context)

        if (action == "io.mesalabs.unica.ghostengine.TOGGLE_SERVICE" ||
            action == Intent.ACTION_BOOT_COMPLETED) {

            // goAsync() + Dispatchers.IO moves startForegroundService() out of the
            // strict BroadcastReceiver context, preventing the Android 14+
            // ForegroundServiceStartNotAllowedException thrown when the call is made
            // directly from onReceive().
            val pendingResult = goAsync()
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    val isEnabled = prefs.isGhostCameraEnabled || prefs.isStealthGpsEnabled
                    if (isEnabled) {
                        val serviceIntent = Intent(context, GhostCameraService::class.java)
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            context.startForegroundService(serviceIntent)
                        } else {
                            context.startService(serviceIntent)
                        }
                    } else {
                        val stopIntent = Intent(context, GhostCameraService::class.java).apply {
                            this.action = GhostCameraService.ACTION_STOP
                        }
                        context.startService(stopIntent)
                    }
                } finally {
                    pendingResult.finish()
                }
            }
        }
    }
}
