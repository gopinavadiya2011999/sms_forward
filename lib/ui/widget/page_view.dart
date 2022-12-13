import 'package:auto_forward_sms/core/utils/utils.dart';
import 'package:flutter/material.dart';
import '../../core/constant/text_style_constant.dart';

Widget pageView(
    {String? image,
    String? title,
    String? description,
    BuildContext? context}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(image!,
          width: Utils.calculateGridWidth(
              context: context!,
              size: MediaQuery.of(context).size.height <= 500 ? 150 : 308),
          height: Utils.calculateGridHeight(
              context: context,
              size: MediaQuery.of(context).size.height <= 500 ? 200 : 326),
          fit: BoxFit.fill),
      SizedBox(height: Utils.calculateGridHeight(context: context, size: 20)),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title!, style: TextStyleConstant.titleStyle),
          Container(
            margin: EdgeInsets.only(
              top: Utils.calculateGridHeight(context: context, size: 6),
              bottom: Utils.calculateGridHeight(context: context, size: 22),
            ),
            child: Text(description!, style: TextStyleConstant.descStyle),
          ),
        ],
      ),
    ],
  );
}
