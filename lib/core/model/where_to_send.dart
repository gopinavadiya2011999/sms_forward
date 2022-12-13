import 'package:auto_forward_sms/core/constant/icon_constant.dart';
import 'package:auto_forward_sms/core/constant/image_constant.dart';

class WhereToSendList {
  String? text;
  String? icon;
  String? type;
  int? iconHeight;
  int? iconWidth;

  WhereToSendList(
      {this.text, this.icon, this.type, this.iconHeight, this.iconWidth});
}

List<WhereToSendList> whereToSend = [
  WhereToSendList(
    iconHeight: 18,
    iconWidth: 23,
    text: "loremipsum@gmai.com",
    icon: IconConstant.msgBox,
    type: 'message',
  ),
  WhereToSendList(
      iconWidth: 17,
      iconHeight: 25,
      text: "+1 34562 78954",
      icon: IconConstant.phone,
      type: 'phone'),
  WhereToSendList(
      iconWidth: 25,
      iconHeight: 13,
      text: "https://loremipsum.com/api",
      icon: IconConstant.link,
      type: 'website'),
  WhereToSendList(
      iconHeight: 18,
      iconWidth: 18,
      text: "@lormipsumuserorchatld",
      icon: IconConstant.otherId,
      type: 'other'),
];
