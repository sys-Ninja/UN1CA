package io.mesalabs.unica.ghostengine.camera

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.RectF
import android.media.MediaPlayer
import android.net.Uri
import android.os.Build
import android.util.Log
import android.view.Surface
import io.mesalabs.unica.ghostengine.data.GhostEnginePrefs
import java.io.InputStream

object GhostCameraManager {
    private const val TAG = "GhostCameraManager"

    // Front camera feed (Slot 1: Selfie)
    private var frontMediaPlayer: MediaPlayer? = null
    private var frontBitmap: Bitmap? = null
    private var frontPlaying = false
    private var frontCameraSession: AutoCloseable? = null

    // Back camera feed (Slot 2: ID Front / Slot 3: ID Back)
    private var backMediaPlayer: MediaPlayer? = null
    private var backBitmap: Bitmap? = null
    private var backPlaying = false
    private var backCameraSession: AutoCloseable? = null

    /** Slot -> lens: 1=Front, 2=Back, 3=Back */
    fun slotToLens(slot: Int): Int = if (slot == 1) 0 else 1  // 0=Front, 1=Back

    /** Load media for a specific slot into the correct camera (front/back) */
    fun prepareSlot(context: Context, slot: Int) {
        val prefs = GhostEnginePrefs.get(context)
        val uriStr = when (slot) {
            1 -> prefs.mediaSlot1
            2 -> prefs.mediaSlot2
            3 -> prefs.mediaSlot3
            else -> prefs.mediaUri
        } ?: prefs.mediaUri ?: return

        val uri = Uri.parse(uriStr)
        val isVideo = prefs.isVideoMedia
        val isFront = slot == 1

        if (isFront) {
            releaseFront()
            loadMedia(context, uri, isVideo,
                onPlayer = { frontMediaPlayer = it; frontPlaying = false },
                onBitmap = { frontBitmap = it }
            )
        } else {
            releaseBack()
            loadMedia(context, uri, isVideo,
                onPlayer = { backMediaPlayer = it; backPlaying = false },
                onBitmap = { backBitmap = it }
            )
        }
    }

    /** Convenience: load all 3 slots at once */
    fun prepareMedia(context: Context) {
        prepareSlot(context, 1)
        prepareSlot(context, 2)
        prepareSlot(context, 3)
    }

    private fun loadMedia(
        context: Context,
        uri: Uri,
        isVideo: Boolean,
        onPlayer: (MediaPlayer) -> Unit,
        onBitmap: (Bitmap) -> Unit
    ) {
        if (isVideo) {
            try {
                val mp = MediaPlayer().apply {
                    setDataSource(context, uri)
                    isLooping = true
                    prepare()
                }
                onPlayer(mp)
            } catch (e: Exception) { Log.e(TAG, "Video prepare error", e) }
        } else {
            try {
                val stream: InputStream? = context.contentResolver.openInputStream(uri)
                val bmp = BitmapFactory.decodeStream(stream)
                stream?.close()
                if (bmp != null) onBitmap(bmp)
            } catch (e: Exception) { Log.e(TAG, "Image decode error", e) }
        }
    }

    fun startFeed(surface: Surface, lensFacing: Int) {
        if (lensFacing == 0) startFrontFeed(surface) else startBackFeed(surface)
    }

    private fun startFrontFeed(surface: Surface) {
        val mp = frontMediaPlayer
        val bmp = frontBitmap
        if (mp != null) {
            try { mp.setSurface(surface); mp.start(); frontPlaying = true }
            catch (e: Exception) { Log.e(TAG, "Front video feed error", e) }
        } else if (bmp != null) {
            drawBitmapToSurface(bmp, surface)
        }
    }

    private fun startBackFeed(surface: Surface) {
        val mp = backMediaPlayer
        val bmp = backBitmap
        if (mp != null) {
            try { mp.setSurface(surface); mp.start(); backPlaying = true }
            catch (e: Exception) { Log.e(TAG, "Back video feed error", e) }
        } else if (bmp != null) {
            drawBitmapToSurface(bmp, surface)
        }
    }

    private fun drawBitmapToSurface(bmp: Bitmap, surface: Surface) {
        try {
            val canvas: Canvas = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M)
                surface.lockHardwareCanvas() ?: surface.lockCanvas(null)
            else surface.lockCanvas(null)
            canvas.drawColor(Color.BLACK)
            val scale = minOf(canvas.width.toFloat() / bmp.width, canvas.height.toFloat() / bmp.height)
            val l = (canvas.width - bmp.width * scale) / 2f
            val t = (canvas.height - bmp.height * scale) / 2f
            canvas.drawBitmap(bmp, null, RectF(l, t, l + bmp.width * scale, t + bmp.height * scale), Paint())
            surface.unlockCanvasAndPost(canvas)
        } catch (e: Exception) { Log.e(TAG, "Draw bitmap error", e) }
    }

    fun startVirtualCamera(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) return
        registerVirtualCamera(context, lensFacing = 0, name = "Ghost Front Camera") { session ->
            frontCameraSession = session
        }
        registerVirtualCamera(context, lensFacing = 1, name = "Ghost Back Camera") { session ->
            backCameraSession = session
        }
    }

    private fun registerVirtualCamera(
        context: Context,
        lensFacing: Int,
        name: String,
        onSession: (AutoCloseable) -> Unit
    ) {
        try {
            val vdmClass = Class.forName("android.companion.virtual.VirtualDeviceManager")
            val vdm = context.getSystemService(vdmClass) ?: return

            val pbClass = Class.forName("android.companion.virtual.VirtualDeviceParams\$Builder")
            val pb = pbClass.getDeclaredConstructor().newInstance()
            pbClass.getMethod("setName", String::class.java).invoke(pb, "GhostEngine")
            val params = pbClass.getMethod("build").invoke(pb)

            val vd = try {
                vdmClass.getMethod("createVirtualDevice", params.javaClass).invoke(vdm, params)
            } catch (_: NoSuchMethodException) {
                vdmClass.getMethod("createVirtualDevice", Int::class.javaPrimitiveType, params.javaClass)
                    .invoke(vdm, -1, params)
            } ?: return

            val vcbClass = Class.forName("android.companion.virtual.camera.VirtualCameraConfig\$Builder")
            val vcb = vcbClass.getDeclaredConstructor(String::class.java).newInstance(name)
            try { vcbClass.getMethod("setLensFacing", Int::class.javaPrimitiveType).invoke(vcb, lensFacing) } catch (_: Exception) {}
            try {
                vcbClass.getMethod("setRequestedWidth", Int::class.javaPrimitiveType).invoke(vcb, 1280)
                vcbClass.getMethod("setRequestedHeight", Int::class.javaPrimitiveType).invoke(vcb, 720)
                vcbClass.getMethod("setRequestedFrameRate", Int::class.javaPrimitiveType).invoke(vcb, 30)
            } catch (_: Exception) {}
            val vcConfig = vcbClass.getMethod("build").invoke(vcb)

            val vc = vd.javaClass.getMethod("createVirtualCamera", vcConfig.javaClass).invoke(vd, vcConfig) ?: return
            val session = vc as? AutoCloseable ?: AutoCloseable {
                try { vc.javaClass.getMethod("close").invoke(vc) } catch (_: Exception) {}
            }
            onSession(session)

            Log.i(TAG, "✅ Virtual camera registered: $name (lensFacing=$lensFacing)")

            val cbClass = try {
                Class.forName("android.companion.virtual.camera.VirtualCamera\$Callback")
            } catch (_: Exception) {
                Class.forName("android.companion.virtual.camera.VirtualCameraCallback")
            }
            val proxy = java.lang.reflect.Proxy.newProxyInstance(cbClass.classLoader, arrayOf(cbClass)) { _, method, args ->
                when (method.name) {
                    "onStreamConfigured" -> {
                        val surface = args?.firstOrNull { it is Surface } as? Surface
                        surface?.let { startFeed(it, lensFacing) }
                    }
                    "onStreamClosed" -> {
                        if (lensFacing == 0) { frontMediaPlayer?.pause(); frontPlaying = false }
                        else { backMediaPlayer?.pause(); backPlaying = false }
                    }
                }
                null
            }
            try {
                vc.javaClass.methods.firstOrNull { it.name == "setVirtualCameraCallback" }
                    ?.invoke(vc, java.util.concurrent.Executors.newSingleThreadExecutor(), proxy)
            } catch (_: Exception) {}
        } catch (e: Exception) {
            Log.w(TAG, "VirtualCamera ($name) not available: ${e.message}")
        }
    }

    fun switchSlot(context: Context, slot: Int) {
        val prefs = GhostEnginePrefs.get(context)
        val uriStr = when (slot) {
            1 -> prefs.mediaSlot1
            2 -> prefs.mediaSlot2
            3 -> prefs.mediaSlot3
            else -> prefs.mediaUri
        } ?: return
        prefs.mediaUri = uriStr
        prepareSlot(context, slot)
    }

    fun getSlotBitmap(slot: Int): Bitmap? = if (slot == 1) frontBitmap else backBitmap

    fun pauseAll() {
        try { if (frontPlaying) { frontMediaPlayer?.pause(); frontPlaying = false } } catch (_: Exception) {}
        try { if (backPlaying) { backMediaPlayer?.pause(); backPlaying = false } } catch (_: Exception) {}
    }

    fun resumeAll() {
        try { if (!frontPlaying && frontMediaPlayer != null) { frontMediaPlayer?.start(); frontPlaying = true } } catch (_: Exception) {}
        try { if (!backPlaying && backMediaPlayer != null) { backMediaPlayer?.start(); backPlaying = true } } catch (_: Exception) {}
    }

    private fun releaseFront() {
        try { frontCameraSession?.close() } catch (_: Exception) {}
        frontCameraSession = null
        try { frontMediaPlayer?.stop(); frontMediaPlayer?.release() } catch (_: Exception) {}
        frontMediaPlayer = null
        frontBitmap?.recycle(); frontBitmap = null
        frontPlaying = false
    }

    private fun releaseBack() {
        try { backCameraSession?.close() } catch (_: Exception) {}
        backCameraSession = null
        try { backMediaPlayer?.stop(); backMediaPlayer?.release() } catch (_: Exception) {}
        backMediaPlayer = null
        backBitmap?.recycle(); backBitmap = null
        backPlaying = false
    }

    fun release() {
        releaseFront()
        releaseBack()
    }
}
