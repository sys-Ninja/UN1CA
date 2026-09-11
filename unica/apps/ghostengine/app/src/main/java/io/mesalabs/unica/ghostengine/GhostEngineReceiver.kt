package io.mesalabs.unica.ghostengine

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.mesalabs.unica.ghostengine.camera.GhostCameraService
import io.mesalabs.unica.ghostengine.data.GhostEnginePrefs

class GhostEngineReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        val prefs = GhostEnginePrefs.get(context)

        when (action) {
            "io.mesalabs.unica.ghostengine.TOGGLE_SERVICE" -> {
                // Android 14+ camera FGS requires foreground state (allowWiu=true).
                // Launch transparent proxy Activity which starts the FGS from
                // its own foreground context, then finishes immediately.
                val isEnabled = prefs.isGhostCameraEnabled || prefs.isStealthGpsEnabled
                val proxyIntent = Intent(context, LaunchProxyActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                    putExtra(LaunchProxyActivity.EXTRA_STOP, !isEnabled)
                }
                context.startActivity(proxyIntent)
            }
            Intent.ACTION_BOOT_COMPLETED -> {
                // Boot is an exemption for priv-apps — startForegroundService is allowed.
                val isEnabled = prefs.isGhostCameraEnabled || prefs.isStealthGpsEnabled
                if (isEnabled) {
                    context.startForegroundService(
                        Intent(context, GhostCameraService::class.java)
                    )
                }
            }
        }
    }
}
