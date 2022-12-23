import 'dart:convert';

class FilterList {
  String? text;
  bool smsSwitch;
  String? filterName;
  bool otpSwitch = false;
  int index = 0;

  FilterList(
      {this.text,
      this.smsSwitch = false,
      this.filterName,
      this.otpSwitch = false,
      this.index = 0});

  factory FilterList.fromJson(Map<String, dynamic> jsonData) {
    return FilterList(
      text: jsonData['text'],
      smsSwitch: jsonData['smsSwitch'],
      filterName: jsonData['filterName'],
      otpSwitch: jsonData['otpSwitch'],
      index: jsonData['index'],
    );
  }

  static Map<String, dynamic> toMap(FilterList music) => {
        'text': music.text,
        'smsSwitch': music.smsSwitch,
        'filterName': music.filterName,
        'otpSwitch': music.otpSwitch,
        'index': music.index,
      };

  static String encode(List<FilterList> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>((music) => FilterList.toMap(music))
            .toList(),
      );

  static List<FilterList> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<FilterList>((item) => FilterList.fromJson(item))
          .toList();
}

//List<FilterList> filterList = [
//FilterList(routeName: '', text: "SMS from work to personal mail"),
//FilterList(routeName: '', text: "SMS from parents to work phone"),
//FilterList(routeName: '', text: "SMS from bank to post office"),
//];
//
// List<FilterList> generalSetting = [
//   FilterList(routeName: '', text: "Forward otp from banks", switchOn: false),
//   FilterList(routeName: '', text: "Forward with roaming"),
//   FilterList(routeName: '', text: "Message history"),
//   FilterList(routeName: '', text: "Forward incoming sms message"),
//   FilterList(routeName: '', text: "Forward outgoing message", switchOn: false),
//   FilterList(routeName: '', text: "Filter schedule", switchOn: false),
// ];
