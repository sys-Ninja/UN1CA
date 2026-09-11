package io.mesalabs.unica.ghostengine

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.Settings

class GhostMediaPickerProxy : Activity() {
    companion object { private const val REQ = 1001 }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        startActivityForResult(Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "*/*"
            putExtra(Intent.EXTRA_MIME_TYPES, arrayOf("image/*", "video/*"))
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
        }, REQ)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQ && resultCode == RESULT_OK) {
            val uri: Uri = data?.data ?: run { finish(); return }
            try { contentResolver.takePersistableUriPermission(uri, Intent.FLAG_GRANT_READ_URI_PERMISSION) } catch (_: Exception) {}
            val uriStr = uri.toString()
            val isVideo = contentResolver.getType(uri)?.startsWith("video/") == true
            val r = contentResolver
            Settings.System.putString(r, "unica_ghost_media_uri", uriStr)
            Settings.System.putInt(r, "unica_ghost_is_video", if (isVideo) 1 else 0)
            Settings.System.putString(r, "unica_ghost_slot1", uriStr)
            sendBroadcast(Intent("io.mesalabs.unica.ghostengine.MEDIA_UPDATED").apply {
                `package` = packageName
                putExtra("uri", uriStr); putExtra("isVideo", isVideo)
            })
        }
        finish()
    }
}