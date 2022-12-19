// Flutter imports:
import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:fluttertoast/fluttertoast.dart';
// Project imports:

class Utils {
  static double calculateGridHeight({
    required BuildContext context,
    required double size,
  }) {
    return (MediaQuery.of(context).size.height - kToolbarHeight - 24) /
        (MediaQuery.of(context).size.height / size);
  }

  static double calculateGridWidth({
    required BuildContext context,
    required double size,
  }) {
    return MediaQuery.of(context).size.width /
        (MediaQuery.of(context).size.width / size);
  }
}
