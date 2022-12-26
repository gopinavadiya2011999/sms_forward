import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
// import 'package:yodo1mas/testmasfluttersdktwo.dart';

class CommonHelper {
  static String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('dd/MM/yyy hh:mm a');
    var date = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = '${diff.inDays}DAY AGO';
      } else {
        time = '${diff.inDays}DAYS AGO';
      }
    }

    return time;
  }

  static bool? interstitialAds() {
    bool? adsOpen;

    //  Timer.periodic(const Duration(seconds: 5), (timer) {
    // Yodo1MAS.instance.setInterstitialListener((event, message) async {
    //   switch (event) {
    //     case Yodo1MAS.AD_EVENT_OPENED:
    //       adsOpen = true;
    //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //           overlays: []);
    //       print('Interstitial AD_EVENT_OPENED');
    //       break;
    //     case Yodo1MAS.AD_EVENT_ERROR:
    //       adsOpen = false;
    //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //       print('Interstitial AD_EVENT_ERROR$message');
    //       break;
    //     case Yodo1MAS.AD_EVENT_CLOSED:
    //       print('Interstitial AD_EVENT_CLOSED');
    //       adsOpen = false;
    //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //       break;
    //   }
    // });
    // });
    return adsOpen;
  }
}
