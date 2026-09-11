package io.mesalabs.unica.ghostengine

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import io.mesalabs.unica.ghostengine.camera.GhostCameraService

/**
 * Transparent trampoline Activity that starts/stops [GhostCameraService].
 * Invisible (Theme.NoDisplay) and finishes itself immediately after dispatching
 * the service command, so it satisfies Android 14's foreground requirement for
 * camera-type foreground services without any visible interruption.
 */
class LaunchProxyActivity : Activity() {

    companion object {
        const val EXTRA_STOP = "stop"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val stop = intent?.getBooleanExtra(EXTRA_STOP, false) ?: false
        if (stop) {
            stopService(Intent(this, GhostCameraService::class.java))
        } else {
            startForegroundService(Intent(this, GhostCameraService::class.java))
        }
        finish()
    }
}
