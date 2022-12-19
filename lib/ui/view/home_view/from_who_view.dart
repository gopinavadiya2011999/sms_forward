/*
import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/icon_constant.dart';
import 'package:auto_forward_sms/core/constant/image_constant.dart';
import 'package:auto_forward_sms/core/constant/text_style_constant.dart';
import 'package:auto_forward_sms/core/localization/app_localization.dart';
import 'package:auto_forward_sms/core/routing/routes.dart';
import 'package:auto_forward_sms/core/utils/utils.dart';
import 'package:auto_forward_sms/core/view_model/base_view.dart';
import 'package:auto_forward_sms/ui/check_network/check_network.dart';
import 'package:auto_forward_sms/ui/widget/custom_app_bar.dart';
import 'package:auto_forward_sms/ui/widget/rounded_floating_btn.dart';
import 'package:flutter/material.dart';

import '../../../core/view_model/home_view_model/from_who_view_model.dart';

class FromWhoView extends StatefulWidget {
  const FromWhoView({Key? key}) : super(key: key);

  @override
  State<FromWhoView> createState() => _FromWhoViewState();
}

class _FromWhoViewState extends State<FromWhoView> {
  FromWhoViewModel model = FromWhoViewModel();

  @override
  Widget build(BuildContext context) {
    return BaseView<FromWhoViewModel>(
      builder: (buildContext, model, child) {
        return CheckNetwork(
            child: Scaffold(
          floatingActionButton: _floatingBtn(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _appBar(),
                    SizedBox(
                        height: Utils.calculateGridHeight(
                            context: context, size: 124)),
                    _noSendData()
                  ],
                ),
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

  _floatingBtn() {
    return customRoundFloatingBtn(
      context: context,
      image: IconConstant.plus,
      onPressed: () {
        Navigator.pushNamed(context, Routes.textRule);
      },
    );
  }

  _noSendData() {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Image.asset(ImageConstant.fromWho)),
        const SizedBox(height: 30),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(AppLocalizations.of(context).translate('desc_from_view'),
              textAlign: TextAlign.center,
              style: TextStyleConstant.skipStyle.copyWith(
                  color: ColorConstant.grey88,
                  letterSpacing: .5,
                  wordSpacing: .5)),
        ),
      ],
    );
  }

  _appBar() {
    return customAppBar(
      arrowHeight: 19,
      center: true,
      arrowWidth: 11,
      icon: IconConstant.leftArrow,
      noHelp: true,
      middleText: AppLocalizations.of(context).translate('from_who'),
      onFirstIconTap: () {
        Navigator.pop(context);
      },
    );
  }
}
*/
