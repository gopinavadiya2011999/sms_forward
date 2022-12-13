import 'package:flutter/services.dart';

class PlatFormChannel {
  static const _channel = EventChannel("com.example.auto_forward_sms/sms");

  Stream smsStream() async* {
    yield* _channel.receiveBroadcastStream();
  }
}

//
// Telephony.instance.listenIncomingSms(
// onNewMessage: (SmsMessage message) {
// print("Message coming : = ${message.body}");
// },
// onBackgroundMessage: onBackgroundMessage,
// listenInBackground: true,
// );

// PlatFormChannel().smsStream().listen((event) {
//   print("Message  := ${event.toString()}");
//   // telephony.sendSms(to: "8980225073", message: event.toString());
//   log("Incoming Message  : = ${event.toString()}");
//   // inComingSms.value = "$message ==> $event";
//   // inComingSms.refresh();
// });
