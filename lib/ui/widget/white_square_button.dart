import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:flutter/material.dart';

whiteShadowButton(
    {String? icon,
    Widget? customIcon,
    int? height,
    int? width,
    Color? bgColor,
    double? buttonHeight,
    double? buttonWidth}) {
  return Container(
      alignment: Alignment.center,
      decoration: customBoxDecoration(bgColor: bgColor),
      width: buttonWidth ?? 40,
      height: buttonHeight ?? 40,
      child: customIcon ??
          Image.asset(
            icon!,
            cacheHeight: height ?? 19,
            cacheWidth: width ?? 11,
          ));
}

customBoxDecoration({Color? bgColor}) {
  return BoxDecoration(
      color: bgColor ?? Colors.white,
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
