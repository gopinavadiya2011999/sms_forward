import 'dart:developer';
import 'dart:isolate';
import 'package:auto_forward_sms/core/routing/routes.dart';
import 'package:auto_forward_sms/main.dart';
import 'package:auto_forward_sms/ui/view/home_view/home_view.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get_storage/get_storage.dart';
import 'package:telephony/telephony.dart';

import '../model/filter_list.dart';

List<FilterList> filterLists = [];

@pragma('vm:entry-point')
onBackgroundMessage(SmsMessage sms) async {
  await GetStorage.init();
  // await initPlatformState();
  print("^^READ BACKGROUND^^ ${box.read('save')}");
  filterLists = FilterList.decode(await box.read('save'));
  filterLists =
      filterLists.where((element) => element.switchOn == true).toList();
  print(
      "^^^^^^^^^^^^FilterLIst:::: :PN BAVKBREd:: %${filterLists.map((e) => e.text)}");
  if (filterLists.isNotEmpty) {
    if (sms.body != null) {
      print(
          "#####${sms.body}#####: ${filterLists.map((e) => e.text).toList().toSet()}");
      print(
          "#####${sms.body}#####: ${filterLists.map((e) => e.switchOn).toList().toSet()}");

      for (int i = 0; i < filterLists.length; i++) {
        print("***bg :: ${filterLists[i].text}");
        Telephony.backgroundInstance
            .sendSms(to: filterLists[i].text!, message: sms.body!);
      }
    }
  }
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  int _eventCount = 0;

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;
    final customData =
        await FlutterForegroundTask.getData<String>(key: 'customData');
    print('customData: $customData');
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    FlutterForegroundTask.updateService(
      notificationTitle: 'MyTaskHandler',
      notificationText: 'eventCount: $_eventCount',
    );

    /*PlatFormChannel().smsStream().listen((event) {
      print("Message foreground Platform  := ${event.toString()}");
      if (phone.isNotEmpty) {
        Telephony.instance.sendSms(to: phone, message: event.toString());
      }
    });*/
    /* final String decodeData = await box.read('save');
    filterLists = FilterList.decode(decodeData);
    filterLists =
        filterLists.where((element) => element.switchOn == true).toList();
    print(
        '######### ${filterLists.map((e) => e.text)} |||||| ${box.read('save')}');
*/
    sendPort?.send(_eventCount);
    /*sendPort?.send(
        Telephony.instance.sendSms(to: "70096968574", message: "message"));*/
    //log("Count := $_eventCount");

    _eventCount++;
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    print("on destroy::: ");
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) {
    print('onButtonPressed >> $id');
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp(Routes.home);
    _sendPort?.send('onNotificationPressed');
  }
}
