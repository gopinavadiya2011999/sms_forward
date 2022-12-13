import 'package:auto_forward_sms/core/view_model/base_model.dart';
import 'package:flutter/material.dart';

class GeneralSettingsViewModel extends BaseModel {
  TextEditingController filterController = TextEditingController();
  bool isValidForm = false;
  String invalidFilter = '';
}
