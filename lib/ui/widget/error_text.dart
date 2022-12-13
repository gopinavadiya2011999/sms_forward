import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:flutter/material.dart';

errorText({required String errorText}) {
  return Align(
    alignment: AlignmentDirectional.topStart,
    child: Container(
      margin: const EdgeInsets.only(top: 8),
      child: Text(
        errorText,
        textAlign: TextAlign.start,
        style: TextStyle(color: ColorConstant.errorColor),
      ),
    ),
  );
}
