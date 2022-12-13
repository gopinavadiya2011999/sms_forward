import 'package:auto_forward_sms/core/localization/app_localization.dart';
import 'package:auto_forward_sms/ui/view/src/custom_login_register_view.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomLoginRegisterView(
        titleText: AppLocalizations.of(context).translate("create_account"),
        buttonText: AppLocalizations.of(context).translate("sign_up"),
        fromRegister: true,
        formKey: _formKey);
  }
}
