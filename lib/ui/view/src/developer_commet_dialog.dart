import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/text_style_constant.dart';
import 'package:auto_forward_sms/ui/widget/inkwell.dart';
import 'package:flutter/material.dart';

developerCommentDialog(
    {required GestureTapCallback cancelTap,
    required GestureTapCallback okTap}) {
  return AlertDialog(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    actionsPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
    actions: [
      inkWell(
        onTap: cancelTap,
        child: Text(
          'Close'.toUpperCase(),
          style: TextStyleConstant.skipStyle,
        ),
      ),
      const SizedBox(width: 25),
      inkWell(
        onTap: okTap,
        child: Text(
          'send'.toUpperCase(),
          style: TextStyleConstant.skipStyle,
        ),
      ),
      const SizedBox(width: 3),
    ],
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
              boxShadow: [
                // BoxShadow(
                //     color: ColorConstant.grey
                //         .withOpacity(0.2),
                //     blurRadius: 10,
                //     offset: const Offset(0, 5),
                //     spreadRadius: 1)
              ],
              border: Border.all(color: ColorConstant.grey.withOpacity(0.6)),
              color: Colors.white,
              borderRadius: BorderRadius.circular(5)),
          child: TextFormField(
            minLines: 4,
            cursorColor: ColorConstant.orange270,
            maxLines: 8,
            style: TextStyleConstant.black12.copyWith(fontSize: 14),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(8),
                hintText: 'Comment..',
                border: InputBorder.none,
                hintStyle: TextStyleConstant.black12),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            "Write a comment and send an e-mail using any mail app.The message will be generated automatically.",
            style: TextStyleConstant.descStyle.copyWith(letterSpacing: 1),
          ),
        )
      ],
    ),
  );
}
