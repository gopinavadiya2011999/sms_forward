import 'dart:isolate';

import 'package:auto_forward_sms/core/model/filter_list.dart';
import 'package:auto_forward_sms/core/routing/routes.dart';
import 'package:auto_forward_sms/core/view_model/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';
import '../../platform_channel.dart';
import '../../services/fore_ground_services.dart';

class HomeViewModel extends BaseModel {
  String inComingSms = "Empty";
  ReceivePort? receivePort;
  Telephony telephony = Telephony.instance;

// Future<bool> getPermission() async {
//   if (await Permission.sms.status == PermissionStatus.granted) {
//     return true;
//   } else {
//     if (await Permission.sms.request() == PermissionStatus.granted) {
//       return true;
//     } else {
//       return false;
//     }
//   }
// }
//
// void initForeGroundTask(
//     {required BuildContext context, required List<FilterList> filterList}) {
//   FlutterForegroundTask.init(
//     androidNotificationOptions: AndroidNotificationOptions(
//       channelId: 'notification_channel_id',
//       channelName: 'Foreground Notification',
//       channelDescription:
//       'This notification appears when the foreground service is running.',
//       channelImportance: NotificationChannelImportance.LOW,
//       priority: NotificationPriority.LOW,
//       iconData: const NotificationIconData(
//           resType: ResourceType.mipmap,
//           resPrefix: ResourcePrefix.ic,
//           name: 'launcher',
//           backgroundColor: Colors.teal),
//       buttons: [
//         const NotificationButton(id: 'sendButton', text: 'Send'),
//         const NotificationButton(id: 'testButton', text: 'Test')
//       ],
//     ),
//     iosNotificationOptions: const IOSNotificationOptions(
//       showNotification: true,
//       playSound: false,
//     ),
//     foregroundTaskOptions: const ForegroundTaskOptions(
//         interval: 1000,
//         isOnceEvent: false,
//         autoRunOnBoot: true,
//         allowWakeLock: true,
//         allowWifiLock: true),
//   );
//   startForegroundTask(context: context, filterList: filterList);
// }
//
// bool registerReceivePort({required BuildContext context,
//   ReceivePort? receivePortData,
//   required List<FilterList> filterList}) {
//   closeReceivePort();
//
//   if (receivePortData != null) {
//     receivePort = receivePortData;
//     receivePort?.listen((msg) {
//       /*   print(
//           "%%ON RECEIVED :: ${filterList.where((element) => element.switchOn == true).toList().map((e) => e.text).toList()}");
//   */
//       telephony.listenIncomingSms(
//           onNewMessage: (SmsMessage messages) {
//             filterList = filterList
//                 .where((element) => element.switchOn == true)
//                 .toList();
//
//             print(filterList.map((e) => e.text));
//             updateUI();
//             if (messages.body != null) {
//               for (int i = 0; i < filterList.length; i++) {
//                 print("***fg :: ${filterList[i].text}");
//                 telephony.sendSms(
//                     to: filterList[i].text!, message: messages.body!);
//               }
//             }
//
//             // print("incoming SMS :: ${messages}");
//           },
//           onBackgroundMessage: onBackgroundMessage);
//       /*    PlatFormChannel().smsStream().listen((event) {
//         print("Message Platform  := ${event.toString()}");
//
//
//         telephony.sendSms(to: phone, message: event.toString());
//         inComingSms = "$message ==> $event";
//         updateUI();
//       });*/
//       inComingSms = msg.toString();
//       updateUI();
//       if (msg is int) {
//         // print('==>> eventCount: $msg  |||||| ');
//       } else if (msg is String) {
//         if (msg == 'onNotificationPressed') {
//           Navigator.pushNamed(context, Routes.home);
//         }
//       } else if (msg is DateTime) {
//         //   print('timestamp: ${msg.toString()}');
//       }
//     });
//
//     updateUI();
//     return true;
//   }
//
//   return false;
// }
//
// Future<bool> startForegroundTask({required BuildContext context,
//   required List<FilterList> filterList}) async {
//   if (!await FlutterForegroundTask.canDrawOverlays) {
//     final isGranted =
//     await FlutterForegroundTask.openSystemAlertWindowSettings();
//     if (!isGranted) {
//       print('SYSTEM_ALERT_WINDOW permission denied!');
//       return false;
//     }
//   }
//
//   await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');
//
//   bool reqResult;
//   if (await FlutterForegroundTask.isRunningService) {
//     reqResult = await FlutterForegroundTask.restartService();
//   } else {
//     reqResult = await FlutterForegroundTask.startService(
//       notificationTitle: 'Foreground Service is running',
//       notificationText: 'Data => ${inComingSms}',
//       callback: startCallback,
//     );
//   }
//
//   ReceivePort? receivePort;
//   if (reqResult) {
//     receivePort = await FlutterForegroundTask.receivePort;
//   }
//
//   return registerReceivePort(
//       context: context, receivePortData: receivePort, filterList: filterList);
// }
//
// Future<bool> stopForegroundTask() async {
//   return await FlutterForegroundTask.stopService();
// }
//
// void closeReceivePort() {
//   receivePort?.close();
//   receivePort = null;
// }
}
