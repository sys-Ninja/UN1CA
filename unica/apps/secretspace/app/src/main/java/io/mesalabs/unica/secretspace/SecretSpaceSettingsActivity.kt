package io.mesalabs.unica.secretspace

import android.app.ProgressDialog
import android.os.Bundle
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import io.mesalabs.unica.secretspace.databinding.ActivitySecretSpaceSettingsBinding
import kotlinx.coroutines.launch
import java.util.concurrent.Executor

class SecretSpaceSettingsActivity : AppCompatActivity() {

    private lateinit var binding: ActivitySecretSpaceSettingsBinding
    private lateinit var prefs: Prefs
    private lateinit var executor: Executor
    private lateinit var biometricPrompt: BiometricPrompt
    private lateinit var promptInfo: BiometricPrompt.PromptInfo

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivitySecretSpaceSettingsBinding.inflate(layoutInflater)
        setContentView(binding.root)

        prefs = Prefs.get(this)
        executor = ContextCompat.getMainExecutor(this)

        setupBiometrics()
        setupListeners()
        updateUiState()
    }

    override fun onResume() {
        super.onResume()
        updateUiState()
    }

    private fun setupBiometrics() {
        biometricPrompt = BiometricPrompt(this, executor,
            object : BiometricPrompt.AuthenticationCallback() {
                override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
                    super.onAuthenticationSucceeded(result)
                    // Save enrolled biometric trigger
                    prefs.selectedFingerprintName = "بصمة الإصبع الحالية (Verified)"
                    prefs.selectedFingerprintId = 1
                    updateUiState()
                    Toast.makeText(this@SecretSpaceSettingsActivity, "تم تعيين البصمة بنجاح!", Toast.LENGTH_SHORT).show()
                }

                override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                    super.onAuthenticationError(errorCode, errString)
                }
            })

        promptInfo = BiometricPrompt.PromptInfo.Builder()
            .setTitle("تعيين بصمة المساحة السرية")
            .setSubtitle("ضع إصبعك المخصص للمساحة السرية على الحساس")
            .setNegativeButtonText("إلغاء")
            .build()
    }

    private fun setupListeners() {
        binding.btnMainAction.setOnClickListener {
            if (SecretSpaceManager.isSpaceCreated(this)) {
                // Enter Space
                SecretSpaceManager.switchToSecretSpace(this)
            } else {
                // Create Space
                createSpace()
            }
        }

        binding.btnDeleteSpace.setOnClickListener {
            showDeleteConfirmation()
        }

        binding.btnAssignFingerprint.setOnClickListener {
            biometricPrompt.authenticate(promptInfo)
        }

        binding.switchIsolateNetwork.setOnCheckedChangeListener { _, isChecked ->
            prefs.isolateNetwork = isChecked
        }

        binding.switchLockOnScreenOff.setOnCheckedChangeListener { _, isChecked ->
            prefs.lockOnScreenOff = isChecked
        }
    }

    private fun updateUiState() {
        val isCreated = SecretSpaceManager.isSpaceCreated(this)
        val currentUserId = SecretSpaceManager.getCurrentUserId()

        if (isCreated) {
            binding.tvStatus.text = getString(R.string.status_active, prefs.secretUserId)
            binding.btnMainAction.text = getString(R.string.btn_enter_space)
            binding.btnDeleteSpace.visibility = View.VISIBLE
            binding.cardFingerprint.visibility = View.VISIBLE
        } else {
            binding.tvStatus.text = getString(R.string.status_not_created)
            binding.btnMainAction.text = getString(R.string.btn_create_space)
            binding.btnDeleteSpace.visibility = View.GONE
            binding.cardFingerprint.visibility = View.GONE
        }

        if (prefs.selectedFingerprintName.isNotEmpty()) {
            binding.tvFingerprintStatus.text = getString(R.string.fingerprint_assigned, prefs.selectedFingerprintName)
        } else {
            binding.tvFingerprintStatus.text = getString(R.string.fingerprint_not_set)
        }

        binding.switchIsolateNetwork.isChecked = prefs.isolateNetwork
        binding.switchLockOnScreenOff.isChecked = prefs.lockOnScreenOff
    }

    @Suppress("DEPRECATION")
    private fun createSpace() {
        val dialog = ProgressDialog(this).apply {
            setMessage(getString(R.string.creating_space))
            setCancelable(false)
            show()
        }

        lifecycleScope.launch {
            val userId = SecretSpaceManager.createSecretSpace(this@SecretSpaceSettingsActivity)
            dialog.dismiss()

            if (userId != null) {
                Toast.makeText(this@SecretSpaceSettingsActivity, R.string.space_created_success, Toast.LENGTH_SHORT).show()
                updateUiState()
            } else {
                Toast.makeText(this@SecretSpaceSettingsActivity, "فشل إنشاء المساحة (يرجى التأكد من صلاحيات النظام)", Toast.LENGTH_LONG).show()
            }
        }
    }

    private fun showDeleteConfirmation() {
        AlertDialog.Builder(this)
            .setTitle(R.string.delete_confirm_title)
            .setMessage(R.string.delete_confirm_msg)
            .setPositiveButton(R.string.confirm_delete) { _, _ ->
                deleteSpace()
            }
            .setNegativeButton(R.string.cancel, null)
            .show()
    }

    @Suppress("DEPRECATION")
    private fun deleteSpace() {
        val dialog = ProgressDialog(this).apply {
            setMessage(getString(R.string.deleting_space))
            setCancelable(false)
            show()
        }

        lifecycleScope.launch {
            val success = SecretSpaceManager.removeSecretSpace(this@SecretSpaceSettingsActivity)
            dialog.dismiss()

            if (success) {
                Toast.makeText(this@SecretSpaceSettingsActivity, R.string.space_deleted_success, Toast.LENGTH_SHORT).show()
            }
            updateUiState()
        }
    }
}
