package com.house.citizen
import com.google.firebase.messaging.FirebaseMessaging 
import android.content.Intent
import android.os.Bundle
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.content.Context
import android.preference.PreferenceManager
import android.util.Log
import androidx.annotation.NonNull
//import com.google.firebase.iid.FirebaseInstanceId
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
//import rekab.app.background_locator.IsolateHolderService
import vn.zalopay.sdk.Environment
import vn.zalopay.sdk.ZaloPayError
import vn.zalopay.sdk.ZaloPaySDK
import vn.zalopay.sdk.listeners.PayOrderListener

import io.flutter.plugins.pathprovider.PathProviderPlugin
import android.content.pm.PackageManager
import android.content.ComponentName
import android.app.Application

class MainActivity: FlutterActivity(), PluginRegistry.PluginRegistrantCallback {
    val CHANNEL = "com.house.citizen"
    val RECEIVE_NOTIFICATION = CHANNEL + "/receive_notification"

    val PAYMENTCOMPLETE = 1
    val PAYMENTERROR = -1
    val PAYMENTCANCELED = 4

    companion object {
        fun DATA() : String = "data"
        fun TOKEN() : String = "device_token"
    }

    private var openEventSink: EventChannel.EventSink? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createChannel()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Disable the Android splash screen fade out animation to avoid
            // a flicker before the similar frame is drawn in Flutter.
            splashScreen.setOnExitAnimationListener { splashScreenView -> splashScreenView.remove() }
        }
        //IsolateHolderService.setPluginRegistrant(this)
//        ZaloPaySDK.init(1162, Environment.SANDBOX)
    }

    private fun createChannel(){
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Create the default notification channel
            val requestID = System.currentTimeMillis()
            val name = getString(R.string.default_notification_channel_id)
            val channel = NotificationChannel(name, "Houze", NotificationManager.IMPORTANCE_HIGH)
            val notificationManager: NotificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    override fun registerWith(registry: PluginRegistry?) {
        if (!registry!!.hasPlugin("io.flutter.plugins.pathprovider")) {
            PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider"))
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        // FirebaseInstanceId.getInstance().instanceId.addOnSuccessListener(this) { instanceIdResult ->
        //     val token = instanceIdResult.token
        //     Log.i("FCM Token", token)
        //     val preferences = PreferenceManager.getDefaultSharedPreferences(baseContext)
        //     val edit = preferences.edit()
        //     edit.putString(MainActivity.TOKEN(), token)
        //     edit.apply()
        // }
        
        FirebaseMessaging.getInstance().token.addOnCompleteListener { task ->
            if (task.isSuccessful) {
                val token = task.result
                Log.i("FCM Token", token)
                val preferences = PreferenceManager.getDefaultSharedPreferences(baseContext)
                val edit = preferences.edit()
                edit.putString(MainActivity.TOKEN(), token)
                edit.apply()
            }
        }

        MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == TOKEN()) {

                val token = PreferenceManager.getDefaultSharedPreferences(baseContext).getString(TOKEN(), "")
                result.success(token)

            } else {
                result.notImplemented()
            }
        }

        EventChannel(flutterEngine.dartExecutor, RECEIVE_NOTIFICATION).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(o: Any?, eventSink: EventChannel.EventSink?) {
                openEventSink = eventSink
                GlobalScope.launch(context = Dispatchers.Main) {
                    delay(2_000)
                    openEventSink!!.success(intent.getStringExtra(DATA()))
                }
            }

            override fun onCancel(o: Any?) {}
        })

        val channelChangeAppIcon = "flutter.native/channelChangeAppIcon"
        MethodChannel(flutterEngine.dartExecutor, channelChangeAppIcon).setMethodCallHandler { call, result ->
             when (call.method) {
                "updateIcon" -> {
                val targetIcon = call.argument<String>("text")
                    if (targetIcon == null) {
                        // error
                        result.notImplemented()
                        return@setMethodCallHandler
                    } else {
                        setIcon(targetIcon)
                    }
                }   
            }
        }

        val channelPayOrder = "flutter.native/channelPayOrder"
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelPayOrder)
                .setMethodCallHandler { call, result ->
                    if (call.method == "payOrder"){
                        val tagSuccess = "[OnPaymentSucceeded]"
                        val tagError = "[onPaymentError]"
                        val tagCanel = "[onPaymentCancel]"
                        val  _zptoken = call.argument<String>("zptoken")
                        val _appId = call.argument<Int>("appId")
                        val _isTestMode = call.argument<Boolean>("isTestMode")
                        ZaloPaySDK.tearDown()
                        ZaloPaySDK.init(_appId
                                ?: 0, if (_isTestMode == true) Environment.SANDBOX else Environment.PRODUCTION)
                        ZaloPaySDK.getInstance().payOrder(this@MainActivity, _zptoken!!, "houzepayment://zalo", object : PayOrderListener {
                            override fun onPaymentCanceled(zpTransToken: String?, appTransID: String?) {
                                Log.d(tagCanel, String.format("[TransactionId]: %s, [appTransID]: %s", zpTransToken, appTransID))
//                                result.success(mapOf("errorCode" to PAYMENTCANCELED, "zpTranstoken" to (zpTransToken
//                                        ?: ""), "appTransId" to (appTransID ?: "")))
                            }

                            override fun onPaymentError(zaloPayErrorCode: ZaloPayError?, zpTransToken: String?, appTransID: String?) {
                                Log.d(tagError, String.format("[zaloPayErrorCode]: %s, [zpTransToken]: %s, [appTransID]: %s", zaloPayErrorCode.toString(), zpTransToken, appTransID))
//                                result.success(mapOf("errorCode" to PAYMENTERROR, "zpTranstoken" to (zpTransToken
//                                        ?: ""), "appTransId" to (appTransID ?: "")))
                            }

                            override fun onPaymentSucceeded(transactionId: String, transToken: String, appTransID: String?) {
                                Log.d(tagSuccess, String.format("[TransactionId]: %s, [TransToken]: %s, [appTransID]: %s", transactionId, transToken, appTransID))
//                                result.success(mapOf("errorCode" to PAYMENTCOMPLETE, "zpTranstoken" to (transToken
//                                        ?: ""), "transactionId" to (transactionId
//                                        ?: ""), "appTransId" to (appTransID ?: "")))
                            }
                        })
                    } else {
                        Log.d("[METHOD CALLER] ", "Method Not Implemented")
                        result.success(mapOf("errorCode" to PAYMENTERROR))
                    }
                }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.data.toString().contains("zalo")) {
            ZaloPaySDK.getInstance().onResult(intent)
        } else {
            openEventSink?.success(intent.getStringExtra(DATA()))
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        print(requestCode)
        print(resultCode)
        print(data?.toString())
        if (requestCode == 2342 && data == null) {
            super.onActivityResult(requestCode, resultCode, Intent())
        } else if (requestCode == 553 && data == null) {
            super.onActivityResult(requestCode, resultCode, Intent())
        } else if (requestCode == 69 && data == null) {
            super.onActivityResult(requestCode, resultCode, Intent())
        }else if (requestCode == 2352 && data == null) {
            super.onActivityResult(requestCode, resultCode, Intent())
        }else if (requestCode == 2353 && data == null) {
            super.onActivityResult(requestCode, resultCode, Intent())
        }else {
            super.onActivityResult(requestCode, resultCode, data)
        }
    }

    //dynamically change app icon
    val activitiesArray = arrayOf("nozomi", "moonlight", "ipsc", "vanphuc", "default", "MainActivity")
    private fun setIcon(targetIcon: String) {
        // val context = MainActivity.appContext
        val packageManager: PackageManager = context.getPackageManager()

        for (value in activitiesArray) {
            val action = if (value == targetIcon) {
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED
            } else {
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED
            }
            packageManager.setComponentEnabledSetting(
                    ComponentName("com.house.citizen", "com.house.citizen.${value}"),
                    action, PackageManager.DONT_KILL_APP
            )
        }

        //launch new intent to prevent app from killing itself!
        //check if android version is greater than 8
        if(android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val intent = Intent()
            intent.setClassName("com.house.citizen", "com.house.citizen.${targetIcon}")
            intent.action = Intent.ACTION_MAIN
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
            intent.setFlags(
                    Intent.FLAG_ACTIVITY_NEW_TASK or
                            Intent.FLAG_ACTIVITY_CLEAR_TASK)
            finish()
            startActivity(intent)
        }
    }
}