import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/var_constant.dart';
import 'package:auto_forward_sms/core/utils/utils.dart';
import 'package:auto_forward_sms/ui/widget/inkwell.dart';
import 'package:flutter/material.dart';

arrowButton(
    {GestureTapCallback? onTap,
    Color? backColor,
    int? buttonHeight,
    bool noMargin = false,
    int? buttonWidth,
    Color? boxShadowColor,
    required String image,
    required BuildContext context}) {
  return inkWell(
    onTap: onTap,
    child: Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: Container(
          margin: noMargin
              ? EdgeInsets.zero
              : EdgeInsets.only(right: VarConstant.rightMargin20),
          height: Utils.calculateGridHeight(context: context, size: 50),
          width: Utils.calculateGridWidth(context: context, size: 50),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backColor,
              border: Border.all(color: ColorConstant.orange, width: 1.5),
              boxShadow: [
                if (boxShadowColor != null)
                  BoxShadow(
                      color: boxShadowColor.withOpacity(0.5),
                      spreadRadius: 4,
                      blurRadius: 5,
                      offset: const Offset(0, 0))
              ]),
          child: Image.asset(image,
              cacheHeight: buttonHeight ?? 18, cacheWidth: buttonWidth ?? 10)),
    ),
  );
}
