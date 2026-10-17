package io.mesalabs.unica.ghostengine.camera

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Matrix
import android.graphics.Paint
import android.media.MediaPlayer
import android.media.PlaybackParams
import android.net.Uri
import android.os.Build
import android.util.Log
import android.view.Surface
import io.mesalabs.unica.ghostengine.data.GhostEnginePrefs
import java.io.InputStream
import java.util.Collections
import java.util.concurrent.ConcurrentHashMap

object GhostCameraManager {
    private const val TAG = "GhostCameraManager"

    // Transformation state
    var panX = 0f
        private set
    var panY = 0f
        private set
    var zoom = 1.0f
        private set
    var rotationDeg = 0
        private set
    var isMirrored = false
        private set
    var isPaused = false
        private set
    var speedMultiplier = 1.0f
        private set
    var isPassthrough = false
        private set
    var currentSlot = 1
        private set

    // Slot 1 (Selfie / Front)
    private var slot1MediaPlayer: MediaPlayer? = null
    private var slot1Bitmap: Bitmap? = null

    // Slot 2 (ID Front / Back)
    private var slot2MediaPlayer: MediaPlayer? = null
    private var slot2Bitmap: Bitmap? = null

    // Slot 3 (ID Back)
    private var slot3MediaPlayer: MediaPlayer? = null
    private var slot3Bitmap: Bitmap? = null

    // Sessions & Surfaces
    private var frontCameraSession: AutoCloseable? = null
    private var backCameraSession: AutoCloseable? = null
    private val registeredSurfaces = Collections.newSetFromMap(ConcurrentHashMap<Surface, Boolean>())

    // Redraw listener for UI updates
    var onStateChanged: (() -> Unit)? = null

    fun pan(dx: Float, dy: Float) {
        panX += dx
        panY += dy
        redrawAllSurfaces()
        onStateChanged?.invoke()
    }

    fun zoom(delta: Float) {
        zoom = (zoom + delta).coerceIn(0.3f, 4.0f)
        redrawAllSurfaces()
        onStateChanged?.invoke()
    }

    fun rotate90() {
        rotationDeg = (rotationDeg + 90) % 360
        redrawAllSurfaces()
        onStateChanged?.invoke()
    }

    fun toggleMirror(): Boolean {
        isMirrored = !isMirrored
        redrawAllSurfaces()
        onStateChanged?.invoke()
        return isMirrored
    }

    fun resetTransform() {
        panX = 0f
        panY = 0f
        zoom = 1.0f
        rotationDeg = 0
        isMirrored = false
        redrawAllSurfaces()
        onStateChanged?.invoke()
    }

    fun togglePause(): Boolean {
        isPaused = !isPaused
        val mp = getActivePlayer()
        if (mp != null) {
            try {
                if (isPaused) mp.pause() else mp.start()
            } catch (e: Exception) { Log.e(TAG, "togglePause error", e) }
        }
        onStateChanged?.invoke()
        return isPaused
    }

    fun cycleSpeed(): Float {
        speedMultiplier = when (speedMultiplier) {
            0.5f -> 1.0f
            1.0f -> 1.5f
            1.5f -> 2.0f
            else -> 0.5f
        }
        val mp = getActivePlayer()
        if (mp != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            try {
                mp.playbackParams = PlaybackParams().setSpeed(speedMultiplier)
            } catch (e: Exception) { Log.e(TAG, "setSpeed error", e) }
        }
        onStateChanged?.invoke()
        return speedMultiplier
    }

    fun seekRelative(deltaMs: Int) {
        val mp = getActivePlayer()
        if (mp != null) {
            try {
                val newPos = (mp.currentPosition + deltaMs).coerceAtLeast(0)
                mp.seekTo(newPos)
            } catch (e: Exception) { Log.e(TAG, "seekRelative error", e) }
        }
    }

    fun restartVideo() {
        val mp = getActivePlayer()
        if (mp != null) {
            try {
                mp.seekTo(0)
                if (!isPaused) mp.start()
            } catch (e: Exception) { Log.e(TAG, "restartVideo error", e) }
        }
    }

    fun togglePassthrough(): Boolean {
        isPassthrough = !isPassthrough
        if (isPassthrough) {
            pauseAll()
        } else {
            if (!isPaused) resumeAll()
            redrawAllSurfaces()
        }
        onStateChanged?.invoke()
        return isPassthrough
    }

    private fun getActiveBitmap(): Bitmap? = when (currentSlot) {
        1 -> slot1Bitmap
        2 -> slot2Bitmap
        3 -> slot3Bitmap
        else -> slot1Bitmap
    }

    private fun getActivePlayer(): MediaPlayer? = when (currentSlot) {
        1 -> slot1MediaPlayer
        2 -> slot2MediaPlayer
        3 -> slot3MediaPlayer
        else -> slot1MediaPlayer
    }

    fun switchSlot(context: Context, slot: Int) {
        currentSlot = slot
        val prefs = GhostEnginePrefs.get(context)
        val uriStr = when (slot) {
            1 -> prefs.mediaSlot1
            2 -> prefs.mediaSlot2
            3 -> prefs.mediaSlot3
            else -> prefs.mediaUri
        } ?: prefs.mediaUri
        if (uriStr != null) {
            prefs.mediaUri = uriStr
            prepareSlot(context, slot)
        }
        feedAllSurfaces()
        onStateChanged?.invoke()
    }

    fun prepareSlot(context: Context, slot: Int) {
        val prefs = GhostEnginePrefs.get(context)
        val uriStr = when (slot) {
            1 -> prefs.mediaSlot1 ?: prefs.mediaUri
            2 -> prefs.mediaSlot2 ?: prefs.mediaUri
            3 -> prefs.mediaSlot3 ?: prefs.mediaUri
            else -> prefs.mediaUri
        } ?: return

        val uri = Uri.parse(uriStr)
        val isVideo = prefs.isVideoMedia

        loadMedia(context, uri, isVideo,
            onPlayer = { mp ->
                when (slot) {
                    1 -> { slot1MediaPlayer?.release(); slot1MediaPlayer = mp }
                    2 -> { slot2MediaPlayer?.release(); slot2MediaPlayer = mp }
                    3 -> { slot3MediaPlayer?.release(); slot3MediaPlayer = mp }
                }
            },
            onBitmap = { bmp ->
                when (slot) {
                    1 -> { slot1Bitmap?.recycle(); slot1Bitmap = bmp }
                    2 -> { slot2Bitmap?.recycle(); slot2Bitmap = bmp }
                    3 -> { slot3Bitmap?.recycle(); slot3Bitmap = bmp }
                }
            }
        )
    }

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
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && speedMultiplier != 1.0f) {
                        playbackParams = PlaybackParams().setSpeed(speedMultiplier)
                    }
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
        if (surface.isValid) {
            registeredSurfaces.add(surface)
            feedSurface(surface)
        }
    }

    private fun feedSurface(surface: Surface) {
        if (isPassthrough || !surface.isValid) return

        val mp = getActivePlayer()
        val bmp = getActiveBitmap()

        if (mp != null) {
            try {
                mp.setSurface(surface)
                if (!isPaused) mp.start()
            } catch (e: Exception) { Log.e(TAG, "Video surface feed error", e) }
        } else if (bmp != null) {
            drawBitmapToSurface(bmp, surface)
        }
    }

    private fun feedAllSurfaces() {
        for (surface in registeredSurfaces) {
            if (surface.isValid) feedSurface(surface)
        }
    }

    fun redrawAllSurfaces() {
        if (isPassthrough) return
        val bmp = getActiveBitmap() ?: return
        for (surface in registeredSurfaces) {
            if (surface.isValid) {
                drawBitmapToSurface(bmp, surface)
            }
        }
    }

    private fun drawBitmapToSurface(bmp: Bitmap, surface: Surface) {
        if (isPassthrough || !surface.isValid) return
        try {
            val canvas: Canvas = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                surface.lockHardwareCanvas() ?: surface.lockCanvas(null)
            } else {
                surface.lockCanvas(null)
            } ?: return

            canvas.drawColor(Color.BLACK)

            val matrix = Matrix()
            // 1. Center pivot
            matrix.postTranslate(-bmp.width / 2f, -bmp.height / 2f)
            // 2. Mirror flip
            if (isMirrored) {
                matrix.postScale(-1f, 1f)
            }
            // 3. Rotation
            matrix.postRotate(rotationDeg.toFloat())
            // 4. Base aspect scale & user zoom
            val scaleX = canvas.width.toFloat() / bmp.width.toFloat()
            val scaleY = canvas.height.toFloat() / bmp.height.toFloat()
            val baseScale = minOf(scaleX, scaleY)
            val effectiveScale = baseScale * zoom
            matrix.postScale(effectiveScale, effectiveScale)
            // 5. Translate to canvas center + pan
            matrix.postTranslate(canvas.width / 2f + panX, canvas.height / 2f + panY)

            val paint = Paint(Paint.FILTER_BITMAP_FLAG or Paint.ANTI_ALIAS_FLAG)
            canvas.drawBitmap(bmp, matrix, paint)
            surface.unlockCanvasAndPost(canvas)
        } catch (e: Exception) {
            Log.e(TAG, "Draw bitmap error", e)
        }
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

            val pbClass = Class.forName("android.companion.virtual.VirtualDeviceParams$Builder")
            val pb = pbClass.getDeclaredConstructor().newInstance()
            pbClass.getMethod("setName", String::class.java).invoke(pb, "GhostEngine")
            val params = pbClass.getMethod("build").invoke(pb)

            val vd = try {
                vdmClass.getMethod("createVirtualDevice", params.javaClass).invoke(vdm, params)
            } catch (_: NoSuchMethodException) {
                vdmClass.getMethod("createVirtualDevice", Int::class.javaPrimitiveType, params.javaClass)
                    .invoke(vdm, -1, params)
            } ?: return

            val vcbClass = Class.forName("android.companion.virtual.camera.VirtualCameraConfig$Builder")
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

            Log.i(TAG, "Virtual camera registered: $name (lensFacing=$lensFacing)")

            val cbClass = try {
                Class.forName("android.companion.virtual.camera.VirtualCamera$Callback")
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
                        val surface = args?.firstOrNull { it is Surface } as? Surface
                        surface?.let { registeredSurfaces.remove(it) }
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

    fun pauseAll() {
        try { slot1MediaPlayer?.pause() } catch (_: Exception) {}
        try { slot2MediaPlayer?.pause() } catch (_: Exception) {}
        try { slot3MediaPlayer?.pause() } catch (_: Exception) {}
    }

    fun resumeAll() {
        try { if (!isPaused) slot1MediaPlayer?.start() } catch (_: Exception) {}
        try { if (!isPaused) slot2MediaPlayer?.start() } catch (_: Exception) {}
        try { if (!isPaused) slot3MediaPlayer?.start() } catch (_: Exception) {}
    }

    fun release() {
        try { frontCameraSession?.close() } catch (_: Exception) {}
        try { backCameraSession?.close() } catch (_: Exception) {}
        frontCameraSession = null
        backCameraSession = null
        registeredSurfaces.clear()

        try { slot1MediaPlayer?.release() } catch (_: Exception) {}
        try { slot2MediaPlayer?.release() } catch (_: Exception) {}
        try { slot3MediaPlayer?.release() } catch (_: Exception) {}
        slot1MediaPlayer = null
        slot2MediaPlayer = null
        slot3MediaPlayer = null

        slot1Bitmap?.recycle(); slot1Bitmap = null
        slot2Bitmap?.recycle(); slot2Bitmap = null
        slot3Bitmap?.recycle(); slot3Bitmap = null
    }
}
