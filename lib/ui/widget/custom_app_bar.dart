import 'package:auto_forward_sms/core/constant/icon_constant.dart';
import 'package:auto_forward_sms/core/constant/text_style_constant.dart';
import 'package:auto_forward_sms/ui/widget/inkwell.dart';
import 'package:auto_forward_sms/ui/widget/white_square_button.dart';
import 'package:flutter/material.dart';

customAppBar(
    {required String icon,
    GestureTapCallback? onFirstIconTap,
    required String middleText,
    bool center = false,
    int? arrowHeight,
    int? arrowWidth,
    Widget? lastIcon,
    GestureTapCallback? onHelpTap,
    bool noHelp = false}) {
  return Row(
    mainAxisAlignment:
        center ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      GestureDetector(
          onTap: onFirstIconTap,
          child: whiteShadowButton(
              icon: icon, height: arrowHeight ?? 15, width: arrowWidth ?? 17)),
      if (center) const SizedBox(width: 28),
      Text(middleText, style: TextStyleConstant.titleStyle),
      if (!noHelp)
        inkWell(
            onTap: onHelpTap,
            child: Image.asset(IconConstant.help,
                cacheHeight: 30, cacheWidth: 30)),
      if (lastIcon != null) lastIcon
    ],
  );
}
