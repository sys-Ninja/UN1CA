package io.mesalabs.unica.screentranslator.service

import android.app.PendingIntent
import android.content.Intent
import android.os.Build
import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import io.mesalabs.unica.screentranslator.ScreenTranslatorSettingsActivity
import io.mesalabs.unica.screentranslator.data.TranslatorPrefs

class TranslatorTileService : TileService() {

    override fun onStartListening() { super.onStartListening(); updateTileState() }

    override fun onClick() {
        super.onClick()
        val prefs = TranslatorPrefs.get(this)
        if (prefs.isServiceEnabled) {
            startService(Intent(this, ScreenTranslatorService::class.java).apply {
                action = ScreenTranslatorService.ACTION_STOP
            })
            prefs.isServiceEnabled = false
            updateTileState()
        } else {
            val intent = Intent(this, ScreenTranslatorSettingsActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                startActivityAndCollapse(PendingIntent.getActivity(
                    this, 0, intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                ))
            } else {
                @Suppress("DEPRECATION")
                startActivityAndCollapse(intent)
            }
        }
    }

    private fun updateTileState() {
        val tile = qsTile ?: return
        tile.state = if (TranslatorPrefs.get(this).isServiceEnabled) Tile.STATE_ACTIVE else Tile.STATE_INACTIVE
        tile.updateTile()
    }
}