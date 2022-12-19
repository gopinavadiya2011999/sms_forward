/*
import 'package:auto_forward_sms/core/constant/image_constant.dart';
import 'package:auto_forward_sms/core/routing/routes.dart';
import 'package:auto_forward_sms/core/utils/dismiss_keyboard.dart';
import 'package:auto_forward_sms/core/utils/utils.dart';
import 'package:auto_forward_sms/core/view_model/on_boarding/custom_login_register_model.dart';
import 'package:auto_forward_sms/ui/widget/custom_check_box.dart';
import 'package:auto_forward_sms/ui/widget/error_text.dart';
import 'package:auto_forward_sms/ui/widget/white_square_button.dart';
import 'package:flutter/material.dart';
import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/icon_constant.dart';
import 'package:auto_forward_sms/core/constant/text_style_constant.dart';
import 'package:auto_forward_sms/core/constant/var_constant.dart';
import 'package:auto_forward_sms/core/localization/app_localization.dart';
import 'package:auto_forward_sms/core/view_model/base_view.dart';
import 'package:auto_forward_sms/ui/check_network/check_network.dart';
import 'package:auto_forward_sms/ui/widget/custom_orange_button.dart';
import 'package:auto_forward_sms/ui/widget/custom_text_field.dart';
import 'package:auto_forward_sms/ui/widget/inkwell.dart';
import 'package:flutter/gestures.dart';

class CustomLoginRegisterView extends StatefulWidget {
  final bool fromRegister;
  final String titleText;
  final GlobalKey<FormState>? formKey;

  final String buttonText;

  final String? descText;

  const CustomLoginRegisterView(
      {Key? key,
      required this.titleText,
      this.descText,
      this.fromRegister = false,
      required this.buttonText,
      this.formKey})
      : super(key: key);

  @override
  State<CustomLoginRegisterView> createState() =>
      _CustomLoginRegisterViewState();
}

class _CustomLoginRegisterViewState extends State<CustomLoginRegisterView> {
  CustomLoginRegisterViewModel model = CustomLoginRegisterViewModel();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    clearController();
  }

  @override
  Widget build(BuildContext context) {
    return CheckNetwork(
        child: BaseView<CustomLoginRegisterViewModel>(
      builder: (buildContext, model, child) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  if (widget.fromRegister &&
                      MediaQuery.of(context).size.height >= 600)
                    Positioned(
                        top: Utils.calculateGridHeight(
                            context: context, size: 60),
                        left: 20,
                        child: inkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: whiteShadowButton(
                                icon: IconConstant.leftArrow))),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Image.asset(ImageConstant.loginTop)),
                  _loginForm(),
                  if (MediaQuery.of(context).size.height >= 600)
                    Positioned(
                        bottom: Utils.calculateGridHeight(
                            context: context, size: 38),
                        child: widget.fromRegister
                            ? _textSpanSignUpView()
                            : _textSpanLoginView())
                ],
              ),
            ));
      },
      onModelReady: (model) {
        this.model = model;
      },
    ));
  }

  _loginForm() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: VarConstant.rightMargin20),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.fromRegister &&
                MediaQuery.of(context).size.height <= 600)
              Container(
                  alignment: AlignmentDirectional.topStart,
                  margin: EdgeInsets.only(
                      top:
                          Utils.calculateGridHeight(context: context, size: 50),
                      bottom: Utils.calculateGridHeight(
                          context: context, size: 20)),
                  child: inkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: whiteShadowButton(icon: IconConstant.leftArrow))),
            if (MediaQuery.of(context).size.height <= 600)
              const SizedBox(height: 20),
            Text(widget.titleText, style: TextStyleConstant.headingWelcome),
            if (widget.descText != null) const SizedBox(height: 8),
            if (widget.descText != null)
              Text(widget.descText!,
                  style: TextStyleConstant.skipStyle
                      .merge(TextStyle(color: ColorConstant.grey88))),
            const SizedBox(height: 30),
            _formView(),
            if (model.invalidPassword.isEmpty && !widget.fromRegister)
              const SizedBox(height: 12),
            if (model.invalidPassword.isEmpty && !widget.fromRegister)
              Align(
                  alignment: Alignment.topRight,
                  child: Text(
                      AppLocalizations.of(context).translate("forgot_pass"),
                      style: TextStyleConstant.grey12)),
            SizedBox(height: widget.fromRegister ? 50 : 40),
            inkWell(
                onTap: () => _checkValidation(),
                child: customOrangeButton(
                    paddingH: 53, buttonText: widget.buttonText)),
            if (!widget.fromRegister) const SizedBox(height: 24),
            if (!widget.fromRegister) _orText(),
            const SizedBox(height: 20),
            if (!widget.fromRegister) _signInButton(),
            if (MediaQuery.of(context).size.height <= 600)
              Container(
                  margin: EdgeInsets.only(
                      top:
                          Utils.calculateGridHeight(context: context, size: 61),
                      bottom: Utils.calculateGridHeight(
                          context: context, size: 10)),
                  child: widget.fromRegister
                      ? _textSpanSignUpView()
                      : _textSpanLoginView())
          ],
        ),
      ),
    );
  }

  _customDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: AlignmentDirectional.centerStart,
              end: AlignmentDirectional.topStart,
              colors: [
            ColorConstant.orange270,
            ColorConstant.orange270,
          ])),
      width: 48,
    );
  }

  _signInButton() {
    return inkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorConstant.orange270, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                IconConstant.google,
                cacheHeight: 28,
                cacheWidth: 28,
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context).translate('sign_in').toUpperCase(),
                style: TextStyleConstant.skipStyle
                    .merge(TextStyle(color: ColorConstant.black22)),
              )
            ],
          ),
        ));
  }

  _orText() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _customDivider(),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            AppLocalizations.of(context).translate('or').toUpperCase(),
            style: TextStyleConstant.skipStyle
                .merge(TextStyle(color: ColorConstant.black22)),
          ),
        ),
        _customDivider(),
      ],
    );
  }

  _textSpanLoginView() {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: AppLocalizations.of(context).translate('no_account'),
            style: TextStyleConstant.skipStyle
                .copyWith(color: ColorConstant.grey88)),
        TextSpan(
          text: AppLocalizations.of(context).translate('sign_up'),
          style: TextStyleConstant.skipStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              clearController();

              Navigator.pushNamed(context, Routes.register);
            },
        )
      ]),
    );
  }

  clearController() {
    model.invalidEmail = '';
    model.invalidConfirmPassword = '';
    model.invalidPassword = '';
    model.isValidForm = false;
    model.checked = false;
    model.confirmPasswordController.clear();
    model.passwordController.clear();
    model.emailController.clear();
  }

  _textSpanSignUpView() {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: AppLocalizations.of(context).translate('already_account'),
            style: TextStyleConstant.skipStyle
                .copyWith(color: ColorConstant.grey88)),
        TextSpan(
          text: AppLocalizations.of(context).translate('log_in'),
          style: TextStyleConstant.skipStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              clearController();
              Navigator.pushNamed(context, Routes.login);
            },
        )
      ]),
    );
  }

  _checkValidation() {
    */
/* if (widget.formKey!.currentState!.validate()) {
      dismissKeyboard(context);
      setState(() {
        model.isValidForm = true;
      });*/ /*

    Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
    */
/* } else {
      setState(() {
        model.isValidForm = false;
      });
    }*/ /*

  }

  _formView() {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          customTextField(
              keyboardType: TextInputType.emailAddress,
              validator: (email) => emailValidation(email: email),
              controller: model.emailController,
              hintText: AppLocalizations.of(context).translate("enter_email"),
              labelText: AppLocalizations.of(context).translate("email"),
              prefixIcon: IconConstant.msgBox),
          if (model.invalidEmail.isNotEmpty)
            errorText(errorText: model.invalidEmail),
          SizedBox(height: VarConstant.rightMargin20),
          customTextField(
              obscure: true,
              validator: (password) {
                model.invalidPassword = '';
                if (password!.isEmpty) {
                  model.invalidPassword = AppLocalizations.of(context)
                      .translate('enter_password_val');
                } else if (password.length < 8) {
                  model.invalidPassword = AppLocalizations.of(context)
                      .translate('password_validation');
                }
                setState(() {});

                return null;
              },
              maxWidth: 40,
              controller: model.passwordController,
              hintText:
                  AppLocalizations.of(context).translate("enter_password"),
              labelText: AppLocalizations.of(context).translate("password"),
              suffixIcon: IconConstant.passwordHide,
              prefixIcon: IconConstant.lock),
          if (model.invalidPassword.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                errorText(errorText: model.invalidPassword),
                if (!widget.fromRegister)
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(
                        AppLocalizations.of(context).translate("forgot_pass"),
                        style: TextStyleConstant.grey12),
                  )
              ],
            ),
          if (widget.fromRegister) SizedBox(height: VarConstant.rightMargin20),
          if (widget.fromRegister)
            customTextField(
                obscure: true,
                validator: (cPassword) {
                  model.invalidConfirmPassword = '';
                  if (cPassword!.isEmpty) {
                    model.invalidConfirmPassword = AppLocalizations.of(context)
                        .translate('enter_confirm_password_val');
                  }
                  // else if (cPassword.length < 8) {
                  //    model.invalidConfirmPassword = AppLocalizations.of(context)
                  //        .translate('password_validation');
                  //     }
                  else if (cPassword != model.passwordController.text) {
                    model.invalidConfirmPassword = AppLocalizations.of(context)
                        .translate('both_password_match');
                  }
                  setState(() {});
                  return null;
                },
                maxWidth: 40,
                controller: model.confirmPasswordController,
                hintText: AppLocalizations.of(context)
                    .translate("enter_confirm_password"),
                labelText:
                    AppLocalizations.of(context).translate("confirm_password"),
                suffixIcon: IconConstant.passwordHide,
                prefixIcon: IconConstant.lock),
          if (widget.fromRegister && model.invalidConfirmPassword.isNotEmpty)
            errorText(errorText: model.invalidConfirmPassword),
          if (widget.fromRegister) const SizedBox(height: 16),
          if (widget.fromRegister)
            customCheckBox(
              checked: model.checked,
              onChanged: (value) {
                model.checked = value!;
                setState(() {});
              },
              text: AppLocalizations.of(context).translate('agree_terms'),
            ),
        ],
      ),
    );
  }

  emailValidation({required email}) {
    model.invalidEmail = '';
    if (email!.isEmpty) {
      model.invalidEmail =
          AppLocalizations.of(context).translate('enter_email_val');
      return;
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      model.invalidEmail =
          AppLocalizations.of(context).translate("email_not_valid");
    }
    setState(() {});
    return null;
  }
}
*/
