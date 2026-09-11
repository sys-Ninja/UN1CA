package io.mesalabs.unica.prayertimes

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.Settings

class AdhanSoundPickerProxy : Activity() {
    companion object { private const val REQ = 2001; const val EXTRA_PRAYER = "prayer" }
    private var prayer = "fajr"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        prayer = intent?.getStringExtra(EXTRA_PRAYER)?.lowercase() ?: "fajr"
        startActivityForResult(Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "audio/*"
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
        }, REQ)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQ && resultCode == RESULT_OK) {
            val uri: Uri = data?.data ?: run { finish(); return }
            try { contentResolver.takePersistableUriPermission(uri, Intent.FLAG_GRANT_READ_URI_PERMISSION) } catch (_: Exception) {}
            val r = contentResolver
            Settings.System.putString(r, "unica_prayer_times_custom_sound_$prayer", uri.toString())
            Settings.System.putString(r, "unica_prayer_times_sound_$prayer", "custom")
        }
        finish()
    }
}