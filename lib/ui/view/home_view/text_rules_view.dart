/*
import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/icon_constant.dart';
import 'package:auto_forward_sms/core/constant/text_style_constant.dart';
import 'package:auto_forward_sms/core/localization/app_localization.dart';
import 'package:auto_forward_sms/core/routing/routes.dart';
import 'package:auto_forward_sms/core/view_model/base_view.dart';
import 'package:auto_forward_sms/core/view_model/home_view_model/text_rule_view_model.dart';
import 'package:auto_forward_sms/ui/check_network/check_network.dart';
import 'package:auto_forward_sms/ui/widget/custom_app_bar.dart';
import 'package:auto_forward_sms/ui/widget/custom_divider.dart';
import 'package:auto_forward_sms/ui/widget/inkwell.dart';
import 'package:auto_forward_sms/ui/widget/white_square_button.dart';
import 'package:flutter/material.dart';

import '../../widget/custom_orange_button.dart';

class TextRuleView extends StatefulWidget {
  const TextRuleView({Key? key}) : super(key: key);

  @override
  State<TextRuleView> createState() => _TextRuleViewState();
}

class _TextRuleViewState extends State<TextRuleView> {
  TextRuleViewModel model = TextRuleViewModel();

  @override
  Widget build(BuildContext context) {
    return BaseView<TextRuleViewModel>(
      builder: (buildContext, model, child) {
        return CheckNetwork(
            child: Scaffold(
          body: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _appBar(),
                  const SizedBox(height: 13),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        _firstBtnRow(),
                        const SizedBox(height: 20),
                        _customWhiteBox(
                            text1: AppLocalizations.of(context)
                                .translate('balance'),
                            text2: AppLocalizations.of(context)
                                .translate('must_contain'),
                            text3: AppLocalizations.of(context)
                                .translate('write_off'),
                            text4: AppLocalizations.of(context)
                                .translate('must_not_contain')),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                              AppLocalizations.of(context)
                                  .translate('or')
                                  .toUpperCase(),
                              style: TextStyleConstant.titleStyle),
                        ),
                        _customWhiteBox(
                            twoButton: true,
                            text1: AppLocalizations.of(context)
                                .translate('crediting'),
                            text2: AppLocalizations.of(context)
                                .translate('must_notification'),
                            text3: AppLocalizations.of(context)
                                .translate('amount'),
                            text4: AppLocalizations.of(context)
                                .translate('must_not_contain')),
                      ],
                    ),
                  )),
                  _nextButton()
                ],
              ),
            ),
          ),
        ));
      },
      onModelReady: (model) {
        this.model = model;
      },
    );
  }

  _customWhiteBox(
      {required String text1,
      required String text2,
      required String text3,
      bool twoButton = false,
      required String text4}) {
    return Container(
      decoration: customBoxDecoration(),
      child: Column(
        children: [
          _customDeleteRow(text1: text1, text2: text2),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: customDivider()),
          _customDeleteRow(text1: text3, text2: text4, topMargin: true),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            customOrangeButton(
                leftButton: true,
                icon: IconConstant.plus,
                iconWidth: 14,
                iconHeight: 14,
                buttonText: AppLocalizations.of(context).translate('rule'),
                paddingH: 25,
                paddingV: 10),
            if (twoButton) const SizedBox(width: 12),
            if (twoButton)
              customOrangeButton(
                  leftButton: true,
                  border: true,
                  icon: IconConstant.plus,
                  iconWidth: 14,
                  iconHeight: 14,
                  buttonText: AppLocalizations.of(context).translate('or'),
                  paddingH: 26,
                  paddingV: 9),
            if (twoButton) const SizedBox(width: 12),
            if (twoButton)
              whiteShadowButton(
                  icon: IconConstant.delete,
                  width: 15,
                  height: 17,
                  buttonHeight: 30,
                  buttonWidth: 30)
          ]),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  _customDeleteRow(
      {required String text1, required String text2, bool topMargin = false}) {
    return Padding(
      padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: topMargin ? 20 : 10,
          top: topMargin ? 10 : 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text1,
                  style: TextStyleConstant.skipStyle
                      .copyWith(color: ColorConstant.black22)),
              const SizedBox(height: 4),
              Text(text2, style: TextStyleConstant.grey12)
            ],
          ),
          whiteShadowButton(
              icon: IconConstant.delete,
              width: 15,
              height: 17,
              buttonHeight: 30,
              buttonWidth: 30)
        ],
      ),
    );
  }

  _customWhiteButton({required String buttonText}) {
    return inkWell(
        child: Container(
      height: MediaQuery.of(context).size.width /
          (MediaQuery.of(context).size.height >= 500 ? 10 : 8),
      width: MediaQuery.of(context).size.width /
          (MediaQuery.of(context).size.height >= 500 ? 2.5 : 2.8),
      decoration: customBoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            IconConstant.plus,
            cacheHeight: 14,
            cacheWidth: 14,
            color: ColorConstant.black22,
          ),
          const SizedBox(width: 12),
          Text(buttonText.toUpperCase())
        ],
      ),
    ));
  }

  _appBar() {
    return customAppBar(
      arrowHeight: 19,
      center: true,
      arrowWidth: 11,
      icon: IconConstant.leftArrow,
      noHelp: true,
      middleText: AppLocalizations.of(context).translate('text_rule'),
      onFirstIconTap: () {
        Navigator.pop(context);
      },
    );
  }

  _nextButton() {
    return inkWell(
        onTap: () {
          Navigator.pushNamed(context, Routes.history);
        },
        child: customOrangeButton(
            icon: IconConstant.backButton,
            buttonText: AppLocalizations.of(context).translate('next'),
            paddingV: 14,
            paddingH: 40));
  }

  _firstBtnRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _customWhiteButton(
            buttonText: AppLocalizations.of(context).translate('rule')),
        _customWhiteButton(
            buttonText: AppLocalizations.of(context).translate('or')),
      ],
    );
  }
}
*/
