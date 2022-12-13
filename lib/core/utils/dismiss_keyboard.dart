// Flutter imports:
import 'package:flutter/material.dart';

Future<void> dismissKeyboard(BuildContext context) async =>
    FocusScope.of(context).unfocus();
