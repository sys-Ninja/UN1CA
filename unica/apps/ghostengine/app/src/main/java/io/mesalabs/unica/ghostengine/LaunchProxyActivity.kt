package io.mesalabs.unica.ghostengine

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import io.mesalabs.unica.ghostengine.camera.GhostCameraService

class LaunchProxyActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val stop = intent?.getBooleanExtra(EXTRA_STOP, false) ?: false
        if (stop) {
            stopService(Intent(this, GhostCameraService::class.java))
            finish()
        } else {
            val serviceIntent = Intent(this, GhostCameraService::class.java)
            startForegroundService(serviceIntent)
            // تأخير إغلاق الـ Activity حتى تبدأ الخدمة وتستدعي startForeground()
            Handler(Looper.getMainLooper()).postDelayed({ finish() }, 600)
        }
    }

    companion object {
        const val EXTRA_STOP = "extra_stop"
    }
}
