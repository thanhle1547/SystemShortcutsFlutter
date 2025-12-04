package com.example.system_shortcuts

import android.annotation.SuppressLint
import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.content.Context
import android.content.Intent
import android.content.pm.ActivityInfo
import android.media.AudioManager
import android.net.wifi.WifiManager
import android.os.Build
import android.provider.Settings
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** SystemShortcutsPlugin */
class SystemShortcutsPlugin :
    FlutterPlugin,
    MethodCallHandler,
    ActivityAware {
    private val tag = "SystemShortcutsPlugin"
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var activity: Activity? = null
    private lateinit var binding: FlutterPlugin.FlutterPluginBinding

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        binding = flutterPluginBinding
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "system_shortcuts")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    @SuppressLint("SourceLockedOrientationActivity", "MissingPermission")
    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        val activity = this.activity
        if (activity == null) {
            Log.w(tag, "Received method channel, but no current activity")
            return
        }
        when(call.method) {
            "home" -> activity.startActivity(
                Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME)
            )
            "back" -> activity.onBackPressed()
            "volDown" -> {
                val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
                audioManager.adjustVolume(AudioManager.ADJUST_LOWER, AudioManager.FLAG_PLAY_SOUND)
                result.success(true)
            }
            "volUp" -> {
                val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
                audioManager.adjustVolume(AudioManager.ADJUST_RAISE, AudioManager.FLAG_PLAY_SOUND)
                result.success(true)
            }
            "orientLandscape" -> {
                activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
                result.success(true)
            }
            "orientPortrait" -> {
                activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
                result.success(true)
            }
            "wifi" -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    result.success(false)
                    return
                }

                val wifiManager = context.getSystemService(Context.WIFI_SERVICE) as WifiManager

                val success = if (wifiManager.isWifiEnabled) {
                    // setWifiEnabled() will always return false for Android Q
                    // because Q doesn't allow apps to enable/disable Wi-Fi anymore.
                    wifiManager.setWifiEnabled(false)
                } else {
                    wifiManager.setWifiEnabled(true)
                }

                result.success(success)
            }
            "checkWifi" -> {
                val wifiManager = context.getSystemService(Context.WIFI_SERVICE) as WifiManager
                result.success(wifiManager.isWifiEnabled)
            }
            "openWifiSettingsPanel" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val intent = Intent(Settings.Panel.ACTION_WIFI)
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(intent)
            }
            "openInternetSettingsPanel" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val intent = Intent(Settings.Panel.ACTION_INTERNET_CONNECTIVITY)
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(intent)
            }
            "bluetooth" -> {
                val mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter()

                val success = if (mBluetoothAdapter.isEnabled) {
                    mBluetoothAdapter.disable()
                } else {
                    mBluetoothAdapter.enable()
                }

                result.success(success)
            }
            "checkBluetooth" -> {
                val mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
                result.success(mBluetoothAdapter.isEnabled)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(activityBinding: ActivityPluginBinding) {
        activity = activityBinding.activity
        context = activityBinding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
        context = binding.applicationContext
    }

    override fun onReattachedToActivityForConfigChanges(activityBinding: ActivityPluginBinding) {
        activity = activityBinding.activity
        context = activityBinding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
        context = binding.applicationContext
    }
}
