import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/icon_constant.dart';
import 'package:auto_forward_sms/ui/widget/arrow_button.dart';
import 'package:flutter/material.dart';

customRoundFloatingBtn(
    {GestureTapCallback? onPressed,
    required BuildContext context,
    String? image}) {
  return FloatingActionButton(
    backgroundColor: ColorConstant.transparent,
    elevation: 0,
    focusElevation: 0,
    highlightElevation: 0,
    hoverElevation: 0,
    disabledElevation: 0,
    focusColor: ColorConstant.transparent,
    hoverColor: ColorConstant.transparent,
    splashColor: ColorConstant.transparent,
    onPressed: onPressed,
    child: arrowButton(
        context: context,
        noMargin: true,
        buttonHeight: 14,
        buttonWidth: 14,
        image: image ?? IconConstant.plus,
        backColor: ColorConstant.orange,
        boxShadowColor: ColorConstant.orange.withOpacity(0.5)),
  );
}
