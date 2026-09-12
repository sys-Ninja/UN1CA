package io.mesalabs.unica.ghostengine.camera

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.media.MediaPlayer
import android.net.Uri
import android.os.Build
import android.util.Log
import android.view.Surface
import io.mesalabs.unica.ghostengine.data.GhostEnginePrefs
import java.io.InputStream

/**
 * GhostCameraManager — media loader + virtual camera feed writer.
 *
 * On Android 14+ (API 34), attempts to register as a VirtualCamera via
 * [android.companion.virtual.VirtualDeviceManager]. The camera appears in
 * [android.hardware.camera2.CameraManager.getCameraIdList] and apps can select it.
 *
 * On earlier APIs or if VirtualDeviceManager is unavailable, operates in
 * overlay mode only (feeds to the FloatingCameraToolController surface).
 */
object GhostCameraManager {
    private const val TAG = "GhostCameraManager"
    private var mediaPlayer: MediaPlayer? = null
    private var staticBitmap: Bitmap? = null
    private var isPlaying = false
    private var virtualCameraSession: AutoCloseable? = null

    fun prepareMedia(context: Context) {
        val prefs = GhostEnginePrefs.get(context)
        val uriStr = prefs.mediaUri ?: return
        val uri = Uri.parse(uriStr)
        release()

        if (prefs.isVideoMedia) {
            try {
                mediaPlayer = MediaPlayer().apply {
                    setDataSource(context, uri)
                    isLooping = true
                    prepare()
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error preparing video feed", e)
            }
        } else {
            try {
                val inputStream: InputStream? = context.contentResolver.openInputStream(uri)
                staticBitmap = BitmapFactory.decodeStream(inputStream)
                inputStream?.close()
            } catch (e: Exception) {
                Log.e(TAG, "Error decoding image feed", e)
            }
        }
    }

    fun startFeed(surface: Surface) {
        if (mediaPlayer != null) {
            try {
                mediaPlayer?.setSurface(surface)
                mediaPlayer?.start()
                isPlaying = true
            } catch (e: Exception) {
                Log.e(TAG, "Error starting video surface feed", e)
            }
        } else if (staticBitmap != null) {
            // Draw static bitmap to surface once
            try {
                val canvas: Canvas = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    surface.lockHardwareCanvas() ?: surface.lockCanvas(null)
                } else {
                    surface.lockCanvas(null)
                }
                canvas.drawColor(Color.BLACK)
                staticBitmap?.let { bmp ->
                    val scale = minOf(
                        canvas.width.toFloat() / bmp.width,
                        canvas.height.toFloat() / bmp.height
                    )
                    val left = (canvas.width - bmp.width * scale) / 2f
                    val top  = (canvas.height - bmp.height * scale) / 2f
                    canvas.drawBitmap(bmp, null,
                        android.graphics.RectF(left, top, left + bmp.width * scale, top + bmp.height * scale),
                        Paint())
                }
                surface.unlockCanvasAndPost(canvas)
            } catch (e: Exception) {
                Log.e(TAG, "Error drawing static frame", e)
            }
        }
    }

    /**
     * Registers a virtual camera via Android 14 VirtualDeviceManager.
     * The registered camera appears as a new camera ID in CameraManager.
     * Apps that support camera selection (Telegram, Signal, etc.) can pick it.
     *
     * Requires android.permission.CREATE_VIRTUAL_DEVICE (signature|privileged).
     */
    fun startVirtualCamera(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) return
        try {
            // Use reflection to avoid compile-time dependency on hidden VirtualDevice APIs
            val vdmClass = Class.forName("android.companion.virtual.VirtualDeviceManager")
            val vdm = context.getSystemService(vdmClass) ?: run {
                Log.w(TAG, "VirtualDeviceManager not available"); return
            }

            // VirtualDeviceParams.Builder
            val paramsBuilderClass = Class.forName("android.companion.virtual.VirtualDeviceParams\$Builder")
            val paramsBuilder = paramsBuilderClass.getDeclaredConstructor().newInstance()
            paramsBuilderClass.getMethod("setName", String::class.java).invoke(paramsBuilder, "GhostEngine")
            val params = paramsBuilderClass.getMethod("build").invoke(paramsBuilder)

            // createVirtualDevice — try the no-association-id variant first (some Samsung builds)
            val vd = try {
                vdmClass.getMethod("createVirtualDevice", params.javaClass).invoke(vdm, params)
            } catch (_: NoSuchMethodException) {
                // Standard API requires associationId (int) as first param
                // We use -1 as sentinel; Samsung priv-apps with LOCATION_HARDWARE may bypass CDM check
                vdmClass.getMethod("createVirtualDevice", Int::class.javaPrimitiveType, params.javaClass)
                    .invoke(vdm, -1, params)
            } ?: run { Log.w(TAG, "createVirtualDevice returned null"); return }

            val vdClass = vd.javaClass

            // VirtualCameraConfig.Builder
            val vcConfigBuilderClass = Class.forName("android.companion.virtual.camera.VirtualCameraConfig\$Builder")
            val vcConfigBuilder = vcConfigBuilderClass.getDeclaredConstructor(String::class.java)
                .newInstance("Ghost Camera")

            // setLensFacing(LENS_FACING_FRONT = 0)
            try { vcConfigBuilderClass.getMethod("setLensFacing", Int::class.javaPrimitiveType)
                .invoke(vcConfigBuilder, 0) } catch (_: Exception) {}

            // addSupportedStreamConfig / setRequestedWidth+Height — try different API versions
            try {
                vcConfigBuilderClass.getMethod("setRequestedWidth", Int::class.javaPrimitiveType)
                    .invoke(vcConfigBuilder, 1280)
                vcConfigBuilderClass.getMethod("setRequestedHeight", Int::class.javaPrimitiveType)
                    .invoke(vcConfigBuilder, 720)
                vcConfigBuilderClass.getMethod("setRequestedFrameRate", Int::class.javaPrimitiveType)
                    .invoke(vcConfigBuilder, 30)
            } catch (_: Exception) {}

            val vcConfig = vcConfigBuilderClass.getMethod("build").invoke(vcConfigBuilder)

            // createVirtualCamera
            val vc = vdClass.getMethod("createVirtualCamera", vcConfig.javaClass)
                .invoke(vd, vcConfig) ?: run { Log.w(TAG, "createVirtualCamera null"); return }

            virtualCameraSession = vc as? AutoCloseable ?: AutoCloseable { 
                try { vc.javaClass.getMethod("close").invoke(vc) } catch (_: Exception) {}
            }

            Log.i(TAG, "✅ VirtualCamera registered — visible in CameraManager.getCameraIdList()")

            // Set the callback to receive Surface and start feeding our media
            val cbClass = try {
                Class.forName("android.companion.virtual.camera.VirtualCamera\$Callback")
            } catch (_: Exception) {
                Class.forName("android.companion.virtual.camera.VirtualCameraCallback")
            }

            val proxy = java.lang.reflect.Proxy.newProxyInstance(
                cbClass.classLoader, arrayOf(cbClass)
            ) { _, method, args ->
                when (method.name) {
                    "onStreamConfigured" -> {
                        // Surface provided for us to write frames
                        val surface = args?.firstOrNull { it is Surface } as? Surface
                        surface?.let { startFeed(it) }
                    }
                    "onStreamClosed" -> pauseFeed()
                }
                null
            }

            try {
                vc.javaClass.methods.firstOrNull { it.name == "setVirtualCameraCallback" }
                    ?.invoke(vc, java.util.concurrent.Executors.newSingleThreadExecutor(), proxy)
            } catch (_: Exception) {}

        } catch (e: Exception) {
            Log.w(TAG, "VirtualCamera not available on this device/API: ${e.message}")
        }
    }

    fun pauseFeed() {
        if (mediaPlayer != null && isPlaying) {
            mediaPlayer?.pause()
            isPlaying = false
        }
    }

    fun resumeFeed() {
        if (mediaPlayer != null && !isPlaying) {
            mediaPlayer?.start()
            isPlaying = true
        }
    }

    fun getStaticBitmap(): Bitmap? = staticBitmap

    fun release() {
        try { virtualCameraSession?.close() } catch (_: Exception) {}
        virtualCameraSession = null
        try { mediaPlayer?.stop(); mediaPlayer?.release() } catch (_: Exception) {}
        mediaPlayer = null
        staticBitmap?.recycle()
        staticBitmap = null
        isPlaying = false
    }
}