import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:flutter/material.dart';

InkWell inkWell({GestureTapCallback? onTap, Widget? child}) {
  return InkWell(

    hoverColor: ColorConstant.transparent,
    splashColor: ColorConstant.transparent,
    highlightColor: ColorConstant.transparent,
    onTap: onTap,
    child: child,
  );
}