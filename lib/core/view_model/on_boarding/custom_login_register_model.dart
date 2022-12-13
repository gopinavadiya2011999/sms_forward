import 'package:auto_forward_sms/core/view_model/base_model.dart';
import 'package:flutter/material.dart';

class CustomLoginRegisterViewModel extends BaseModel {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isValidForm = false;
  String invalidPassword = '';
  String invalidConfirmPassword = '';
  String invalidEmail = '';
  bool checked = false;
}
