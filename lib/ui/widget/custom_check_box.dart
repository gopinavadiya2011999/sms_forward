/*
import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/text_style_constant.dart';
import 'package:flutter/material.dart';

customCheckBox({
  required bool checked,
  Color? color,
  required String text,
  ValueChanged<bool?>? onChanged,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(
        height: 22,
        width: 22,
        child: Checkbox(
            activeColor: ColorConstant.orange270,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            side: BorderSide(color: ColorConstant.orange270, width: 1.5),
            value: checked,
            onChanged: onChanged),
      ),
      const SizedBox(width: 12),
      Flexible(
        child: Text(text,
            style: TextStyleConstant.grey12
                .copyWith(color: color ?? ColorConstant.grey88)),
      )
    ],
  );
}
*/
