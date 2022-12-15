import 'package:auto_forward_sms/database_helper.dart';

class SmsModel {
  int? smsId;
  String? text;
  int? switchOn = 0;

  SmsModel({this.smsId, this.text, this.switchOn = 0});

  SmsModel.fromMap(Map<String, dynamic> map) {
    smsId = map['smsId'];
    text = map['text'];
    switchOn = map['switchOn'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.smsId: smsId,
      DatabaseHelper.text: text,
      DatabaseHelper.switchOn: switchOn,
    };
  }
}
