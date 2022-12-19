/*
import 'package:auto_forward_sms/core/constant/icon_constant.dart';
import 'package:auto_forward_sms/core/constant/text_style_constant.dart';
import 'package:auto_forward_sms/core/localization/app_localization.dart';
import 'package:auto_forward_sms/core/model/filter_list.dart';
import 'package:auto_forward_sms/core/routing/routes.dart';
import 'package:auto_forward_sms/core/utils/dismiss_keyboard.dart';
import 'package:auto_forward_sms/core/view_model/base_view.dart';
import 'package:auto_forward_sms/core/view_model/home_view_model/general_setting_view_model.dart';
import 'package:auto_forward_sms/ui/check_network/check_network.dart';
import 'package:auto_forward_sms/ui/widget/custom_app_bar.dart';
import 'package:auto_forward_sms/ui/widget/custom_orange_button.dart';
import 'package:auto_forward_sms/ui/widget/custom_switch.dart';
import 'package:auto_forward_sms/ui/widget/custom_text_field.dart';
import 'package:auto_forward_sms/ui/widget/error_text.dart';
import 'package:auto_forward_sms/ui/widget/inkwell.dart';
import 'package:flutter/material.dart';

class GeneralSettingsView extends StatefulWidget {
  const GeneralSettingsView({Key? key}) : super(key: key);

  @override
  State<GeneralSettingsView> createState() => _GeneralSettingsViewState();
}

class _GeneralSettingsViewState extends State<GeneralSettingsView> {
  GeneralSettingsViewModel model = GeneralSettingsViewModel();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CheckNetwork(
      child: BaseView<GeneralSettingsViewModel>(
        builder: (buildContext, model, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _appBar(),
                      const SizedBox(height: 30),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _textField(),
                              if (model.invalidFilter.isNotEmpty)
                                const SizedBox(height: 5),
                              if (model.invalidFilter.isNotEmpty)
                                errorText(errorText: model.invalidFilter),
                              const SizedBox(height: 30),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: generalSetting.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: MediaQuery.of(context)
                                                .size
                                                .height <=
                                            500
                                        ? EdgeInsets.zero
                                        : EdgeInsets.only(
                                            bottom:
                                                index == generalSetting.length
                                                    ? 0
                                                    : 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(generalSetting[index].text ?? "",
                                            style: TextStyleConstant.black12),
                                        customSwitch(
                                          value: generalSetting[index].switchOn,
                                          onChanged: (value) {
                                            generalSetting[index].switchOn =
                                                value;
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 5.5),
                              inkWell(
                                onTap: () => _checkValidation(),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: customOrangeButton(
                                      icon: IconConstant.backButton,
                                      buttonText: AppLocalizations.of(context)
                                          .translate('next'),
                                      paddingV: 14,
                                      paddingH: 40),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      )
                    ]),
              ),
            ),
          );
        },
        onModelReady: (model) {
          this.model = model;
        },
      ),
    );
  }

  _textField() {
    return Form(
        key: _formKey,
        child: customTextField(
            validator: (value) {
              model.invalidFilter = '';
              if (value!.isEmpty) {
                model.invalidFilter =
                    AppLocalizations.of(context).translate('enter_filter_val');
              }
              setState(() {});

              return null;
            },
            hintText:
                AppLocalizations.of(context).translate('enter_filter_name'),
            labelText: AppLocalizations.of(context).translate('filter_name'),
            controller: model.filterController));
  }

  _appBar() {
    return customAppBar(
      arrowHeight: 19,
      center: true,
      arrowWidth: 11,
      icon: IconConstant.leftArrow,
      noHelp: true,
      middleText: AppLocalizations.of(context).translate('general_setting'),
      onFirstIconTap: () {
        Navigator.pop(context);
      },
    );
  }

  _checkValidation() {
*/
/*    if (_formKey.currentState!.validate() && model.invalidFilter.isEmpty) {
      dismissKeyboard(context);
      setState(() {
        model.isValidForm = true;
      });*/ /*

    Navigator.pushNamed(context, Routes.whereToSend);
*/
/*    } else {
      setState(() {
        model.isValidForm = false;
      });
    }*/ /*

  }
}
*/
