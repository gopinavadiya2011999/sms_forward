import 'package:auto_forward_sms/database_helper.dart';

class SmsModel {
  int? smsId;
  String? text;
  int? switchOn = 0;
  int? otpSwitch = 0;
  String? filterName;
  String? countryCode;

  // List<MessageModel>? messageList;

  SmsModel(
      {this.smsId,
      this.text,
      this.switchOn = 0,
      this.otpSwitch = 0,
      this.filterName,
      this.countryCode
      /* this.messageList*/
      });

  SmsModel.fromMap(Map<String, dynamic> map) {
    smsId = map['smsId'];
    text = map['text'];
    switchOn = map['switchOn'];
    filterName = map['filterName'];
    otpSwitch = map['otpSwitch'];
    countryCode = map['countryCode'];
    //   if (map['messageList'] != null) {
    //     messageList = <MessageModel>[];
    //     map['messageList'].forEach((v) {
    //       messageList!.add(MessageModel.fromMap(v));
    //     });
    //   }
    //   messageList = map['messageList'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.smsId: smsId,
      DatabaseHelper.text: text,
      DatabaseHelper.switchOn: switchOn,
      DatabaseHelper.filterName: filterName,
      DatabaseHelper.otpSwitch: otpSwitch,
      DatabaseHelper.countryCode: countryCode
    };
  }
}

class MessageModel {
  String? msgId;
  String? msg;
  String? fromWho;
  String? senderNo;
  String? dateTime;
  bool isDeleted = false;

  MessageModel(
      {this.msgId,
      this.msg,
      this.dateTime,
      this.fromWho,
      this.senderNo,
      this.isDeleted = false});

  MessageModel.fromMap(Map<String, dynamic> map) {
    msgId = map['msgId'];
    msg = map['msg'];
    fromWho = map['fromWho'];
    dateTime = map['dateTime'];
    senderNo = map['senderNo'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.msgId: msgId,
      DatabaseHelper.msg: msg,
      DatabaseHelper.fromWho: fromWho,
      DatabaseHelper.dateTime: dateTime,
      DatabaseHelper.senderNo: senderNo
    };
  }
}
