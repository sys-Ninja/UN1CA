package io.mesalabs.unica.antipeeping.service

import android.annotation.SuppressLint
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.IBinder
import androidx.camera.core.CameraSelector
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.ImageProxy
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.face.Face
import com.google.mlkit.vision.face.FaceDetection
import com.google.mlkit.vision.face.FaceDetectorOptions
import io.mesalabs.unica.antipeeping.R
import io.mesalabs.unica.antipeeping.data.AntiPeepingPrefs
import io.mesalabs.unica.antipeeping.overlay.PrivacyOverlayController
import java.util.concurrent.Executors

class AntiPeepingService : Service(), LifecycleOwner {

    private val lifecycleRegistry = LifecycleRegistry(this)
    override val lifecycle: Lifecycle get() = lifecycleRegistry

    private val cameraExecutor = Executors.newSingleThreadExecutor()
    private var overlayController: PrivacyOverlayController? = null
    private var cameraProvider: ProcessCameraProvider? = null

    private var lastAnalysisTimestamp = 0L
    private val detector = FaceDetection.getClient(
        FaceDetectorOptions.Builder()
            .setPerformanceMode(FaceDetectorOptions.PERFORMANCE_MODE_FAST)
            .setLandmarkMode(FaceDetectorOptions.LANDMARK_MODE_NONE)
            .setClassificationMode(FaceDetectorOptions.CLASSIFICATION_MODE_NONE)
            .enableTracking()
            .build()
    )

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        lifecycleRegistry.currentState = Lifecycle.State.CREATED
        overlayController = PrivacyOverlayController(this)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP) {
            stopSelf()
            return START_NOT_STICKY
        }

        startForeground(NOTIFICATION_ID, createNotification())
        lifecycleRegistry.currentState = Lifecycle.State.STARTED
        lifecycleRegistry.currentState = Lifecycle.State.RESUMED

        startCameraAnalysis()
        return START_STICKY
    }

    private fun startCameraAnalysis() {
        val cameraProviderFuture = ProcessCameraProvider.getInstance(this)
        cameraProviderFuture.addListener({
            try {
                cameraProvider = cameraProviderFuture.get()
                bindAnalysisUseCase()
            } catch (_: Exception) {}
        }, ContextCompat.getMainExecutor(this))
    }

    private fun bindAnalysisUseCase() {
        val provider = cameraProvider ?: return
        val cameraSelector = CameraSelector.DEFAULT_FRONT_CAMERA

        val imageAnalysis = ImageAnalysis.Builder()
            .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
            .build()

        imageAnalysis.setAnalyzer(cameraExecutor) { imageProxy ->
            processFrame(imageProxy)
        }

        try {
            provider.unbindAll()
            provider.bindToLifecycle(this, cameraSelector, imageAnalysis)
        } catch (_: Exception) {}
    }

    @SuppressLint("UnsafeOptInUsageError")
    private fun processFrame(imageProxy: ImageProxy) {
        val now = System.currentTimeMillis()
        // Pulse sampling: check frame once every 700ms to save CPU & battery
        if (now - lastAnalysisTimestamp < 700L) {
            imageProxy.close()
            return
        }
        lastAnalysisTimestamp = now

        val prefs = AntiPeepingPrefs.get(this)
        if (prefs.isCoWatchActive) {
            // User enabled Co-Watch Mode (watching with friend) -> Skip threat detection
            overlayController?.hideThreat()
            imageProxy.close()
            return
        }

        val mediaImage = imageProxy.image
        if (mediaImage != null) {
            val image = InputImage.fromMediaImage(mediaImage, imageProxy.imageInfo.rotationDegrees)
            detector.process(image)
                .addOnSuccessListener { faces ->
                    analyzeFaces(faces, prefs)
                }
                .addOnCompleteListener {
                    imageProxy.close()
                }
        } else {
            imageProxy.close()
        }
    }

    private fun analyzeFaces(faces: List<Face>, prefs: AntiPeepingPrefs) {
        if (faces.size > 1) {
            // Find the primary user face (largest bounding box closest to center)
            val primaryFace = faces.maxByOrNull { it.boundingBox.width() * it.boundingBox.height() }
            val secondaryFaces = faces.filter { it != primaryFace }

            // Check if any secondary face is looking towards the screen
            val peepingThreat = secondaryFaces.any { face ->
                val angleY = face.headEulerAngleY // Yaw angle
                val angleZ = face.headEulerAngleZ // Roll angle
                val isFacingScreen = Math.abs(angleY) < 35.0f && Math.abs(angleZ) < 35.0f
                val isCloseEnough = face.boundingBox.width() > 70
                isFacingScreen && isCloseEnough
            }

            if (peepingThreat) {
                overlayController?.showThreat(prefs.actionType) {
                    // Snooze clicked by user
                    prefs.isCoWatchActive = true
                }
            } else {
                overlayController?.hideThreat()
            }
        } else {
            overlayController?.hideThreat()
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        lifecycleRegistry.currentState = Lifecycle.State.DESTROYED
        overlayController?.hideThreat()
        try {
            cameraProvider?.unbindAll()
        } catch (_: Exception) {}
        cameraExecutor.shutdown()
    }

    private fun createNotification(): Notification {
        val channelId = "anti_peeping_channel"
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nm.createNotificationChannel(
            NotificationChannel(
                channelId,
                getString(R.string.app_name),
                NotificationManager.IMPORTANCE_MIN
            )
        )

        val stopIntent = PendingIntent.getService(
            this, 0,
            Intent(this, AntiPeepingService::class.java).setAction(ACTION_STOP),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, channelId)
            .setContentTitle(getString(R.string.app_name))
            .setContentText(getString(R.string.notif_protecting))
            .setSmallIcon(android.R.drawable.ic_lock_idle_lock)
            .setOngoing(true)
            .addAction(0, getString(R.string.notif_stop), stopIntent)
            .build()
    }

    companion object {
        const val ACTION_STOP = "io.mesalabs.unica.antipeeping.STOP"
        private const val NOTIFICATION_ID = 4001
    }
}