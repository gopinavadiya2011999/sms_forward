import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/text_style_constant.dart';
import 'package:auto_forward_sms/core/constant/var_constant.dart';
import 'package:flutter/cupertino.dart';

customOrangeButton(
    {required String buttonText,
    double? paddingH,
    int? iconWidth,
    int? iconHeight,
    String? icon,
    bool border = false,
    bool leftButton = false,
    double? paddingV,
    bool margin = false}) {
  return Container(
    margin: EdgeInsets.only(right: margin ? VarConstant.rightMargin20 : 0),
    padding: EdgeInsets.symmetric(
        horizontal: paddingH ?? 41, vertical: paddingV ?? 15),
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: border
                  ? ColorConstant.transparent
                  : ColorConstant.orange.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: 5)
        ],
        border: Border.all(
            color: border ? ColorConstant.orange : ColorConstant.transparent,
            width: border ? 1.5 : 0),
        color: border ? ColorConstant.transparent : ColorConstant.orange,
        borderRadius: BorderRadius.circular(10)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null && leftButton)
          Image.asset(icon,
              cacheHeight: iconHeight ?? 19,
              cacheWidth: iconWidth ?? 11,
              color: border ? ColorConstant.orange : ColorConstant.white),
        if (leftButton) const SizedBox(width: 16),
        Text(
          buttonText.toUpperCase(),
          style: TextStyleConstant.skipStyle.merge(TextStyle(
              color: border ? ColorConstant.orange : ColorConstant.white)),
        ),
        if (icon != null && !leftButton) const SizedBox(width: 16),
        if (icon != null && !leftButton)
          Image.asset(icon,
              cacheHeight: iconHeight ?? 19, cacheWidth: iconWidth ?? 11)
      ],
    ),
  );
}
