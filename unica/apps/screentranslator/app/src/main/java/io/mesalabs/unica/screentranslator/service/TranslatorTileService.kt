package io.mesalabs.unica.screentranslator.service

import android.content.Intent
import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import io.mesalabs.unica.screentranslator.ScreenTranslatorSettingsActivity
import io.mesalabs.unica.screentranslator.data.TranslatorPrefs

class TranslatorTileService : TileService() {

    override fun onStartListening() {
        super.onStartListening()
        updateTileState()
    }

    override fun onClick() {
        super.onClick()
        val prefs = TranslatorPrefs.get(this)

        if (prefs.isServiceEnabled) {
            val stopIntent = Intent(this, ScreenTranslatorService::class.java).apply {
                action = ScreenTranslatorService.ACTION_STOP
            }
            startService(stopIntent)
            prefs.isServiceEnabled = false
            updateTileState()
        } else {
            val launchIntent = Intent(this, ScreenTranslatorSettingsActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            startActivityAndCollapse(launchIntent)
        }
    }

    private fun updateTileState() {
        val tile = qsTile ?: return
        val isEnabled = TranslatorPrefs.get(this).isServiceEnabled
        tile.state = if (isEnabled) Tile.STATE_ACTIVE else Tile.STATE_INACTIVE
        tile.updateTile()
    }
}