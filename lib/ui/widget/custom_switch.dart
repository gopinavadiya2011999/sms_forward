import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:flutter/material.dart';

customSwitch({required bool value, ValueChanged<bool>? onChanged}) {
  return SizedBox(
      width: 40,
      height: 30,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Switch(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeColor: ColorConstant.orange270,
          value: value,
          onChanged: onChanged,
        ),
      ));
}
