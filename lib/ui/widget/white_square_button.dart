import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:flutter/material.dart';

whiteShadowButton(
    {required String icon,
    int? height,
    int? width,
    double? buttonHeight,
    double? buttonWidth}) {
  return Container(
      alignment: Alignment.center,
      decoration: customBoxDecoration(),
      width: buttonWidth ?? 40,
      height: buttonHeight ?? 40,
      child: Image.asset(
        icon,
        cacheHeight: height ?? 19,
        cacheWidth: width ?? 11,
      ));
}

customBoxDecoration() {
  return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: ColorConstant.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 10,
          offset: const Offset(0, 3),
        )
      ]);
}
