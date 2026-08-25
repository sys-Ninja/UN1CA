package io.mesalabs.unica.secretspace

import android.app.ActivityManager
import android.content.Context
import android.os.Build
import android.os.Process
import android.os.UserHandle
import android.os.UserManager
import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.lang.reflect.Method

object SecretSpaceManager {

    private const val TAG = "SecretSpaceManager"
    const val DEFAULT_SPACE_NAME = "Ghost Space"

    /**
     * Checks if the Secret Space user currently exists in UserManager.
     */
    fun isSpaceCreated(context: Context): Boolean {
        val prefs = Prefs.get(context)
        val savedId = prefs.secretUserId
        if (savedId <= 0) return false

        return try {
            val userManager = context.getSystemService(Context.USER_SERVICE) as UserManager
            val users = getUserList(userManager)
            users.any { getIdFromUserInfo(it) == savedId }
        } catch (e: Exception) {
            Log.e(TAG, "Error checking if secret space exists", e)
            false
        }
    }

    /**
     * Gets the current active User ID.
     */
    fun getCurrentUserId(): Int {
        return try {
            val userHandleClass = UserHandle::class.java
            val myUserIdMethod = userHandleClass.getMethod("myUserId")
            myUserIdMethod.invoke(null) as Int
        } catch (e: Exception) {
            Process.myUid() / 100000
        }
    }

    /**
     * Creates a full, isolated Secondary User for the Secret Space.
     */
    suspend fun createSecretSpace(
        context: Context,
        name: String = DEFAULT_SPACE_NAME
    ): Int? = withContext(Dispatchers.IO) {
        val userManager = context.getSystemService(Context.USER_SERVICE) as UserManager

        try {
            // Method 1: Try AOSP createUser(name, userType, flags)
            val createUserMethod: Method? = try {
                UserManager::class.java.getMethod(
                    "createUser",
                    String::class.java,
                    String::class.java,
                    Int::class.javaPrimitiveType
                )
            } catch (e: NoSuchMethodException) {
                null
            }

            val userInfo = if (createUserMethod != null) {
                val fullSecondaryType = "android.os.usertype.full.SECONDARY"
                createUserMethod.invoke(userManager, name, fullSecondaryType, 0)
            } else {
                // Method 2: Fallback to createUser(name, flags)
                val fallbackMethod = UserManager::class.java.getMethod(
                    "createUser",
                    String::class.java,
                    Int::class.javaPrimitiveType
                )
                fallbackMethod.invoke(userManager, name, 0)
            }

            if (userInfo != null) {
                val userId = getIdFromUserInfo(userInfo)
                Log.d(TAG, "Secret space created successfully with User ID: $userId")
                Prefs.get(context).secretUserId = userId
                Prefs.get(context).isEnabled = true
                return@withContext userId
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to create secret space user", e)
        }

        null
    }

    /**
     * Switches the active session to the Secret Space user.
     */
    fun switchToSecretSpace(context: Context): Boolean {
        val targetId = Prefs.get(context).secretUserId
        if (targetId <= 0) {
            Log.e(TAG, "Cannot switch: Invalid secret user ID $targetId")
            return false
        }
        return switchUser(context, targetId)
    }

    /**
     * Switches back to the Primary Owner (User 0).
     */
    fun switchToMainSpace(context: Context): Boolean {
        return switchUser(context, 0)
    }

    /**
     * Low-level user switching via ActivityManager / IActivityManager.
     */
    fun switchUser(context: Context, userId: Int): Boolean {
        Log.i(TAG, "Switching user to $userId...")
        return try {
            val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val switchMethod = ActivityManager::class.java.getMethod("switchUser", Int::class.javaPrimitiveType)
            switchMethod.invoke(activityManager, userId) as Boolean
        } catch (e: Exception) {
            Log.e(TAG, "Error switching to user $userId via reflection, trying ActivityManagerNative", e)
            try {
                val amnClass = Class.forName("android.app.ActivityManagerNative")
                val getDefaultMethod = amnClass.getMethod("getDefault")
                val am = getDefaultMethod.invoke(null)
                val switchMethod = am.javaClass.getMethod("switchUser", Int::class.javaPrimitiveType)
                switchMethod.invoke(am, userId) as Boolean
            } catch (ex: Exception) {
                Log.e(TAG, "Fatal: Unable to switch user", ex)
                false
            }
        }
    }

    /**
     * Deletes the Secret Space user and purges all of its encrypted storage.
     */
    suspend fun removeSecretSpace(context: Context): Boolean = withContext(Dispatchers.IO) {
        val prefs = Prefs.get(context)
        val userId = prefs.secretUserId
        if (userId <= 0) return@withContext false

        try {
            val userManager = context.getSystemService(Context.USER_SERVICE) as UserManager
            val removeMethod = UserManager::class.java.getMethod("removeUser", Int::class.javaPrimitiveType)
            val result = removeMethod.invoke(userManager, userId) as Boolean
            if (result) {
                prefs.secretUserId = -1
                prefs.isEnabled = false
                prefs.selectedFingerprintId = -1
                prefs.selectedFingerprintName = ""
                Log.d(TAG, "Secret space user $userId removed successfully")
            }
            result
        } catch (e: Exception) {
            Log.e(TAG, "Failed to remove secret space user $userId", e)
            false
        }
    }

    private fun getUserList(userManager: UserManager): List<Any> {
        return try {
            val getUsersMethod = UserManager::class.java.getMethod("getUsers")
            @Suppress("UNCHECKED_CAST")
            getUsersMethod.invoke(userManager) as? List<Any> ?: emptyList()
        } catch (e: Exception) {
            emptyList()
        }
    }

    private fun getIdFromUserInfo(userInfo: Any): Int {
        return try {
            val idField = userInfo.javaClass.getField("id")
            idField.getInt(userInfo)
        } catch (e: Exception) {
            -1
        }
    }
}
