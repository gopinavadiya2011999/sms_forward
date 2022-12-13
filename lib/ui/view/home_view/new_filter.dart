import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/icon_constant.dart';
import 'package:auto_forward_sms/core/constant/text_style_constant.dart';
import 'package:auto_forward_sms/core/localization/app_localization.dart';
import 'package:auto_forward_sms/core/routing/routes.dart';
import 'package:auto_forward_sms/core/utils/dismiss_keyboard.dart';
import 'package:auto_forward_sms/core/utils/utils.dart';
import 'package:auto_forward_sms/core/view_model/base_view.dart';
import 'package:auto_forward_sms/core/view_model/home_view_model/new_filter_view_model.dart';
import 'package:auto_forward_sms/ui/check_network/check_network.dart';
import 'package:auto_forward_sms/ui/view/home_view/home_view.dart';
import 'package:auto_forward_sms/ui/widget/custom_app_bar.dart';
import 'package:auto_forward_sms/ui/widget/custom_orange_button.dart';
import 'package:auto_forward_sms/ui/widget/custom_switch.dart';
import 'package:auto_forward_sms/ui/widget/custom_text_field.dart';
import 'package:auto_forward_sms/ui/widget/error_text.dart';
import 'package:auto_forward_sms/ui/widget/inkwell.dart';
import 'package:auto_forward_sms/ui/widget/rounded_floating_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewFilterView extends StatefulWidget {
  final SmsForwardRoute smsForwardRoute;

  NewFilterView({super.key, required this.smsForwardRoute});

  @override
  State<NewFilterView> createState() => _NewFilterViewState();
}

class _NewFilterViewState extends State<NewFilterView> {
  NewFilterViewModel model = NewFilterViewModel();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    model.invalidMailPhone = '';
    model.emailPhoneController.clear();
  }

  SharedPreferences? prefs;

  @override
  Widget build(BuildContext context) {
    return CheckNetwork(
      child: BaseView<NewFilterViewModel>(
        builder: (buildContext, model, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            //floatingActionButton: _floatingBtn(),
            body: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical:
                        MediaQuery.of(context).size.height >= 500 ? 20 : 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _appBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            Text(
                                AppLocalizations.of(context)
                                    .translate('filter_desc'),
                                style: TextStyleConstant.grey12.copyWith(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                    wordSpacing: 0.5)),
                            const SizedBox(height: 20),
                            _textField(),
                            if (model.invalidMailPhone.isNotEmpty)
                              const SizedBox(height: 8),
                            if (model.invalidMailPhone.isNotEmpty)
                              errorText(errorText: model.invalidMailPhone),
                            const SizedBox(height: 8),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                    AppLocalizations.of(context)
                                        .translate('sms_sent_info'),
                                    style: TextStyleConstant.grey12)),
                            const SizedBox(height: 20),
                            //     _switchRowView(),
                            SizedBox(
                                height: Utils.calculateGridHeight(
                                    context: context,
                                    size: MediaQuery.of(context).size.height >=
                                            500
                                        ? 40
                                        : 30)),
                            inkWell(
                                onTap: () => _checkValidation(),
                                child: customOrangeButton(
                                    buttonText: AppLocalizations.of(context)
                                        .translate('detail_setting'),
                                    paddingH:
                                        MediaQuery.of(context).size.height >=
                                                500
                                            ? 38
                                            : 20,
                                    paddingV: 15)),
                            // SizedBox(
                            //     height:
                            //         MediaQuery.of(context).size.height >= 500
                            //             ? 0
                            //             : 10)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        onModelReady: (model) {
          this.model = model;

          model.emailPhoneController.text = widget.smsForwardRoute.phone;
        },
      ),
    );
  }

  _floatingBtn() {
    return customRoundFloatingBtn(
      context: context,
      image: IconConstant.right,
      onPressed: () => {Navigator.pushNamed(context, Routes.whereToSend)},
    );
  }

  _appBar() {
    return customAppBar(
      arrowHeight: 19,
      arrowWidth: 11,
      icon: IconConstant.leftArrow,
      middleText: AppLocalizations.of(context).translate('new_filter'),
      onFirstIconTap: () {
        Navigator.pop(context);
      },
    );
  }

  _textField() {
    return Form(
        key: _formKey,
        child: customTextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[+0-9]")),
            ],
            keyboardType: TextInputType.number,
            validator: (value) {
              model.invalidMailPhone = '';
              if (value!.isEmpty) {
                model.invalidMailPhone =
                    AppLocalizations.of(context).translate('enter_phone_val');
              } else if (value.length < 8 || value.length > 15) {
                model.invalidMailPhone = "Please enter valid mobile number";
              }

              setState(() {});
              return null;
            },
            hintText:
                AppLocalizations.of(context).translate('enter_email_phone'),
            labelText: AppLocalizations.of(context).translate('email_phone'),
            controller: model.emailPhoneController));
  }

  _switchRowView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context).translate('forward_bank_otp'),
          style: TextStyleConstant.skipStyle
              .copyWith(color: ColorConstant.black22),
        ),
        customSwitch(
          value: model.switchOff,
          onChanged: (value) {
            model.switchOff = value;
            setState(() {});
          },
        ),
      ],
    );
  }

  _checkValidation() async {
    if (_formKey.currentState!.validate() && model.invalidMailPhone.isEmpty) {
      dismissKeyboard(context);
      setState(() {
        model.isValidForm = true;
        model.invalidMailPhone = '';
      });

      Navigator.pop(context, model.emailPhoneController.text);
    } else {
      setState(() {
        model.isValidForm = false;
      });
    }
  }
}

//forgot password
class SmsForwardRoute {
  final String phone;

  SmsForwardRoute({
    required this.phone,
  });
}
