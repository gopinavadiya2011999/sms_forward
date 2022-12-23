import 'package:auto_forward_sms/database_helper.dart';
import 'package:auto_forward_sms/sms_model.dart';
import 'package:auto_forward_sms/ui/view/home_view/home_view.dart';

import 'package:telephony/telephony.dart';
import 'package:uuid/uuid.dart';

import '../model/filter_list.dart';
import '../utils/flutter_toast.dart';

List<FilterList> filterLists = [];

@pragma('vm:entry-point')
onBackgroundMessage(SmsMessage sms) async {
  List<SmsModel> smsModel = [];

  // await GetStorage.init();
  // await initPlatformState();
  // print("^^READ BACKGROUND^^ ${box.read('save')}");
  // filterLists = FilterList.decode(await box.read('save'));

  final allRows = await dbHelper.queryAllRows();
  smsModel.clear();
  for (var element in allRows) {
    smsModel.add(SmsModel.fromMap(element));
  }

  // print('Query done:: ${allRows.map((e) => e).toList()}');

  filterLists.clear();

  // print("^^^^^^^^^^^^FilterList:: ${filterLists.map((e) => e.text)}");
  for (var element in smsModel) {
    filterLists.add(FilterList(
        index: element.smsId!,
        otpSwitch: element.otpSwitch == 1 ? true : false,
        filterName: element.filterName,
        text: element.text,
        smsSwitch: element.switchOn == 1 ? true : false));
  }

  filterLists =
      filterLists.where((element) => element.smsSwitch == true).toList();
  if (filterLists.isNotEmpty) {
    if (sms.body != null) {
      /* print(
          "#####${sms.body}#####: ${filterLists.map((e) => e.text).toList().toSet()}");
      print(
          "#####${sms.body}#####: ${filterLists.map((e) => e.smsSwitch).toList().toSet()}");
*/
      Uuid uuid = const Uuid();

      for (int i = 0; i < filterLists.length; i++) {
        if (!filterLists[i].otpSwitch &&
            (sms.body!.contains("otp") ||
                sms.body!.contains("Otp") ||
                sms.body!.contains("oTp") ||
                sms.body!.contains("otP") ||
                sms.body!.contains("OTP"))) {
          showBottomLongToast("Otp Content ");
          // print("***fg if====:: ${filterLists[i].text}");
        } else {
          if (sms.address.toString() != filterLists[i].text) {
            // print("*===**bfg else:: ${filterLists[i].text}");
            await dbHelper.insertMessage(MessageModel.fromMap({
              DatabaseHelper.msgId:
                  uuid.v1() + DateTime.now().millisecondsSinceEpoch.toString(),
              DatabaseHelper.msg: sms.body.toString(),
              DatabaseHelper.fromWho: sms.address.toString(),
              DatabaseHelper.dateTime:
                  DateTime.now().millisecondsSinceEpoch.toString(),
              DatabaseHelper.senderNo: filterLists[i].text.toString(),
            }));
            Telephony.backgroundInstance
                .sendSms(to: filterLists[i].text!, message: sms.body!);
          }
        }
      }
    }
  }
}

//@pragma('vm:entry-point')
// void startCallback() {
//   FlutterForegroundTask.setTaskHandler(MyTaskHandler());
// }
//
// class MyTaskHandler extends TaskHandler {
//   SendPort? _sendPort;
//   int _eventCount = 0;
//
//   @override
//   Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
//     _sendPort = sendPort;
//     final customData =
//         await FlutterForegroundTask.getData<String>(key: 'customData');
//     if (kDebugMode) {
//       print('customData: $customData');
//     }
//   }
//
//   @override
//   Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
//     FlutterForegroundTask.updateService(
//       notificationTitle: 'MyTaskHandler',
//       notificationText: 'eventCount: $_eventCount',
//     );
//
//     /*PlatFormChannel().smsStream().listen((event) {
//       print("Message foreground Platform  := ${event.toString()}");
//       if (phone.isNotEmpty) {
//         Telephony.instance.sendSms(to: phone, message: event.toString());
//       }
//     });*/
//     /* final String decodeData = await box.read('save');
//     filterLists = FilterList.decode(decodeData);
//     filterLists =
//         filterLists.where((element) => element.switchOn == true).toList();
//     print(
//         '######### ${filterLists.map((e) => e.text)} |||||| ${box.read('save')}');
// */
//     sendPort?.send(_eventCount);
//     /*sendPort?.send(
//         Telephony.instance.sendSms(to: "70096968574", message: "message"));*/
//     //log("Count := $_eventCount");
//
//     _eventCount++;
//   }
//
//   @override
//   Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
//     await FlutterForegroundTask.clearAllData();
//   }
//
//   @override
//   void onButtonPressed(String id) {
//     if (kDebugMode) {
//       print('onButtonPressed >> $id');
//     }
//   }
//
//   @override
//   void onNotificationPressed() {
//     FlutterForegroundTask.launchApp(Routes.home);
//     _sendPort?.send('onNotificationPressed');
//   }
// }
