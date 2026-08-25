package io.mesalabs.unica.secretspace

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class QuickSwitchReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        Log.i("QuickSwitchReceiver", "Received action: $action")

        when (action) {
            "io.mesalabs.unica.action.SWITCH_TO_SECRET_SPACE" -> {
                SecretSpaceManager.switchToSecretSpace(context)
            }
            "io.mesalabs.unica.action.SWITCH_TO_MAIN_SPACE" -> {
                SecretSpaceManager.switchToMainSpace(context)
            }
        }
    }
}
