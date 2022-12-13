import 'package:auto_forward_sms/core/constant/text_style_constant.dart';
import 'package:auto_forward_sms/ui/widget/inkwell.dart';
import 'package:flutter/material.dart';

smsPermissionDialog(
    {required GestureTapCallback okTap,
    required GestureTapCallback cancelTap}) {
  return AlertDialog(
    actionsPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
    content: Text(
      "We need permission to read incoming SMS message in order to find out when they appear and forward"
      "them in time.",
      style: TextStyleConstant.black12.copyWith(fontSize: 13.5),
    ),
    actions: [
      inkWell(
        onTap: cancelTap,
        child: Text(
          'cancel'.toUpperCase(),
          style: TextStyleConstant.skipStyle,
        ),
      ),
      const SizedBox(width: 3),
      inkWell(
        onTap: okTap,
        child: Text(
          'ok'.toUpperCase(),
          style: TextStyleConstant.skipStyle,
        ),
      ),
      const SizedBox(width: 3),
    ],
  );
}
