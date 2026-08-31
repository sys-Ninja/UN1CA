package io.mesalabs.unica.antipeeping.service

import android.graphics.drawable.Icon
import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import io.mesalabs.unica.antipeeping.R
import io.mesalabs.unica.antipeeping.data.AntiPeepingPrefs

class CoWatchTileService : TileService() {

    override fun onStartListening() {
        super.onStartListening()
        updateTileState()
    }

    override fun onClick() {
        super.onClick()
        val prefs = AntiPeepingPrefs.get(this)
        prefs.isCoWatchActive = !prefs.isCoWatchActive
        updateTileState()
    }

    private fun updateTileState() {
        val tile = qsTile ?: return
        val prefs = AntiPeepingPrefs.get(this)
        val active = prefs.isCoWatchActive

        tile.state = if (active) Tile.STATE_ACTIVE else Tile.STATE_INACTIVE
        tile.label = getString(R.string.tile_cowatch_title)
        tile.subtitle = if (active) getString(R.string.tile_cowatch_active) else getString(R.string.tile_cowatch_inactive)
        tile.updateTile()
    }
}