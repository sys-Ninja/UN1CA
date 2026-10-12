package io.mesalabs.unica.ghostengine

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import io.mesalabs.unica.ghostengine.camera.GhostCameraService

class LaunchProxyActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val stop = intent?.getBooleanExtra(EXTRA_STOP, false) ?: false
        if (stop) {
            stopService(Intent(this, GhostCameraService::class.java))
        } else {
            startForegroundService(Intent(this, GhostCameraService::class.java))
        }
        // finish() must be called before onResume() for Theme.Translucent
        // so calling it here in onCreate() is correct and safe
        finish()
    }

    companion object {
        const val EXTRA_STOP = "extra_stop"
    }
}
