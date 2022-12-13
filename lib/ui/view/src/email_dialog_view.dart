import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/icon_constant.dart';
import 'package:auto_forward_sms/core/constant/text_style_constant.dart';
import 'package:auto_forward_sms/core/localization/app_localization.dart';
import 'package:auto_forward_sms/core/routing/routes.dart';
import 'package:auto_forward_sms/core/utils/dismiss_keyboard.dart';
import 'package:auto_forward_sms/core/utils/utils.dart';
import 'package:auto_forward_sms/ui/widget/custom_check_box.dart';
import 'package:auto_forward_sms/ui/widget/custom_divider.dart';
import 'package:auto_forward_sms/ui/widget/custom_orange_button.dart';
import 'package:auto_forward_sms/ui/widget/custom_text_field.dart';
import 'package:auto_forward_sms/ui/widget/error_text.dart';
import 'package:auto_forward_sms/ui/widget/inkwell.dart';
import 'package:flutter/material.dart';

class EmailAlertDialog extends StatefulWidget {
  final BuildContext context;
  final GlobalKey<FormState> formKey;

  const EmailAlertDialog(
      {Key? key, required this.context, required this.formKey})
      : super(key: key);

  @override
  State<EmailAlertDialog> createState() => _EmailAlertDialogState();
}

class _EmailAlertDialogState extends State<EmailAlertDialog> {
  final TextEditingController emailController = TextEditingController();

  bool isValidForm = false;
  bool openSlide = false;
  String invalidEmail = '';

  bool checked1 = false;

  bool checked2 = true;

  @override
  void dispose() {
    emailController.clear();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _alertDialogView();
  }

  _cancelSaveBtn() {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          inkWell(
            onTap: () => Navigator.pop(widget.context),
            child: Text(
                AppLocalizations.of(widget.context)
                    .translate('cancel')
                    .toUpperCase(),
                style: TextStyleConstant.grey18),
          ),
          SizedBox(
              width:
                  Utils.calculateGridWidth(context: widget.context, size: 31)),
          inkWell(
            onTap: () => _checkValidation(),
            child: Text(
                AppLocalizations.of(widget.context)
                    .translate('save')
                    .toUpperCase(),
                style: TextStyleConstant.grey18
                    .copyWith(color: ColorConstant.orange270)),
          )
        ],
      ),
    );
  }

  _checkBoxView({required StateSetter setState}) {
    return Column(
      children: [
        customCheckBox(
          checked: checked1,
          color: ColorConstant.black22,
          onChanged: (value) {
            checked1 = value!;
            setState(() {});
          },
          text: AppLocalizations.of(widget.context).translate('over_wifi'),
        ),
        SizedBox(
            height:
                Utils.calculateGridHeight(context: widget.context, size: 20)),
        customCheckBox(
          checked: checked2,
          color: ColorConstant.black22,
          onChanged: (value) {
            checked2 = value!;
            setState(() {});
          },
          text: AppLocalizations.of(widget.context).translate('delay_sending'),
        ),
      ],
    );
  }

  _titleView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(IconConstant.msgBox,
              color: ColorConstant.black22, cacheWidth: 25, cacheHeight: 20),
          Text(
            AppLocalizations.of(widget.context).translate("to_on_email"),
            style: TextStyleConstant.skipStyle
                .copyWith(color: ColorConstant.black22),
          ),
          inkWell(
              onTap: () {
                openSlide = !openSlide;
                setState(() {});
              },
              child: Icon(
                  !openSlide
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 35))
        ],
      ),
    );
  }

  _alertDialogView() {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 12, vertical: openSlide ? 25 : 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _titleView(),
                  customDivider(),
                  if (openSlide)
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        _textField(setState: setState),
                        if (invalidEmail.isNotEmpty) const SizedBox(height: 5),
                        if (invalidEmail.isNotEmpty)
                          errorText(errorText: invalidEmail),
                        const SizedBox(height: 12),
                        Text(
                            AppLocalizations.of(context)
                                .translate('where_SMS_send'),
                            style: TextStyleConstant.grey12),
                        SizedBox(
                            height: Utils.calculateGridHeight(
                                context: context, size: 20)),
                        _checkBoxView(setState: setState),
                        SizedBox(
                            height: Utils.calculateGridHeight(
                                context: context, size: 40)),
                        inkWell(
                            onTap: () =>
                                Navigator.pushNamed(context, Routes.fromWho),
                            child: customOrangeButton(
                              buttonText: AppLocalizations.of(context)
                                  .translate('message_template'),
                              paddingH: 15,
                              paddingV: 15,
                            )),
                        SizedBox(
                            height: Utils.calculateGridHeight(
                                context: context, size: 34)),
                        _cancelSaveBtn()
                      ],
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _textField({required StateSetter setState}) {
    return Form(
        key: widget.formKey,
        child: customTextField(
            validator: (email) {
              invalidEmail = '';
              if (email!.isEmpty) {
                invalidEmail = AppLocalizations.of(widget.context)
                    .translate('enter_email_val');
                return;
              } else if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(email)) {
                invalidEmail = AppLocalizations.of(widget.context)
                    .translate("email_not_valid");
              }
              setState(() {});
              return null;
            },
            hintText:
                AppLocalizations.of(widget.context).translate('test_email'),
            labelText: AppLocalizations.of(widget.context).translate('email'),
            controller: emailController));
  }

  _checkValidation() {
    if (widget.formKey.currentState!.validate() && invalidEmail.isEmpty) {
      dismissKeyboard(context);
      setState(() {
        isValidForm = true;
      });
      Navigator.pop(context, emailController.text);
    } else {
      setState(() {
        isValidForm = false;
      });
    }
  }
}
