import 'package:auto_forward_sms/core/view_model/base_model.dart';
import 'package:flutter/cupertino.dart';

class NewFilterViewModel extends BaseModel {
  TextEditingController emailPhoneController = TextEditingController();
  TextEditingController filterNameController = TextEditingController();
  String invalidFilter = '';
  bool isValidForm = false;
  String invalidMailPhone = '';
  bool switchOff = false;
}
