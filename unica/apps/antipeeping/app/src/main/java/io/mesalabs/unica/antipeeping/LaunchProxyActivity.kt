package io.mesalabs.unica.antipeeping

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import io.mesalabs.unica.antipeeping.service.AntiPeepingService

/**
 * Transparent trampoline Activity that starts/stops [AntiPeepingService].
 *
 * Android 14 requires FGS with foregroundServiceType=camera to be started
 * while the app is in the foreground (allowWiu = true).  A running Activity
 * satisfies this constraint.  The Activity has Theme.NoDisplay so it is
 * invisible to the user and finishes itself immediately after launching the
 * service, adding zero latency to the user interaction.
 */
class LaunchProxyActivity : Activity() {

    companion object {
        const val EXTRA_STOP = "stop"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val stop = intent?.getBooleanExtra(EXTRA_STOP, false) ?: false
        val svc = Intent(this, AntiPeepingService::class.java)
        if (stop) {
            stopService(svc)
        } else {
            startForegroundService(svc)
        }
        finish()
    }
}
