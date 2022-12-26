package com.smsforwarder.autoforwad

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.provider.Telephony
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel


class MainActivity : FlutterActivity() {


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val smsReceiver = object : EventChannel.StreamHandler, BroadcastReceiver() {
            var eventSink: EventChannel.EventSink? = null
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }

            override fun onReceive(p0: Context?, p1: Intent?) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                    for (sms in Telephony.Sms.Intents.getMessagesFromIntent(p1)) {
                        eventSink?.success(sms.displayMessageBody)
                        unregisterReceiver(this)

                    }
                }
            }
        }
        registerReceiver(smsReceiver, IntentFilter("android.provider.Telephony.SMS_RECEIVED"))
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.smsforwarder.autoforwad/sms")
            .setStreamHandler(smsReceiver)


    }

}
