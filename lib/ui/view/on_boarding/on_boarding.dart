import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/icon_constant.dart';
import 'package:auto_forward_sms/core/constant/text_style_constant.dart';
import 'package:auto_forward_sms/core/constant/var_constant.dart';
import 'package:auto_forward_sms/core/localization/app_localization.dart';
import 'package:auto_forward_sms/core/utils/utils.dart';
import 'package:auto_forward_sms/core/view_model/base_view.dart';
import 'package:auto_forward_sms/core/view_model/on_boarding/on_boarding_view_model.dart';
import 'package:auto_forward_sms/main.dart';
import 'package:auto_forward_sms/ui/check_network/check_network.dart';
import 'package:auto_forward_sms/ui/widget/arrow_button.dart';
import 'package:auto_forward_sms/ui/widget/custom_orange_button.dart';
import 'package:auto_forward_sms/ui/widget/page_view.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';

import '../../../core/routing/routes.dart';
import '../../widget/inkwell.dart';

class OnBoardingOne extends StatefulWidget {
  const OnBoardingOne({Key? key}) : super(key: key);

  @override
  State<OnBoardingOne> createState() => _OnBoardingOneState();
}

class _OnBoardingOneState extends State<OnBoardingOne> {
  OnBoardingOneViewModel model = OnBoardingOneViewModel();

  @override
  Widget build(BuildContext context) {
    return BaseView<OnBoardingOneViewModel>(
      builder: (buildContext, model, child) {
        print("############:::Height ${MediaQuery.of(context).size.height}");
        print("%%%%%% Width::: ${MediaQuery.of(context).size.width}");
        return Scaffold(
            body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: VarConstant.rightMargin20),
                child: inkWell(
                  onTap: () {
                    box.write('login', true);
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.home, (route) => false);
                    // Navigator.pushNamed(context, Routes.login);
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(AppLocalizations.of(context).translate("skip"),
                        style: TextStyleConstant.skipStyle),
                  ),
                ),
              ),
              Column(
                children: [
                  ExpandablePageView.builder(
                    padEnds: false,
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: model.controller,
                    onPageChanged: (int num) {
                      setState(() {
                        model.curr = num;
                      });
                    },
                    itemCount: model.onBoardingList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: pageView(
                            context: context,
                            description: model.onBoardingList[index].desc,
                            image: model.onBoardingList[index].image,
                            title: model.onBoardingList[index].title),
                      );
                    },
                  ),
                  containerList(),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if ((model.curr != 0 &&
                            !(model.curr == model.onBoardingList.length - 1)) ||
                        (model.curr == model.onBoardingList.length - 1))
                      arrowButton(
                        onTap: () {
                          model.controller.jumpToPage(model.curr - 1);
                        },
                        image: IconConstant.leftArrow,
                        context: context,
                        backColor: ColorConstant.white,
                      ),
                    if (!(model.curr == model.onBoardingList.length - 1))
                      arrowButton(
                          context: context,
                          image: IconConstant.backButton,
                          onTap: () {
                            model.controller.jumpToPage(model.curr + 1);
                          },
                          backColor: ColorConstant.orange,
                          boxShadowColor:
                              ColorConstant.orange.withOpacity(0.5)),
                    if (model.curr == model.onBoardingList.length - 1)
                      inkWell(
                          onTap: () {
                            box.write('login', true);
                            Navigator.pushNamedAndRemoveUntil(
                                context, Routes.home, (route) => false);
                            // Navigator.pushNamed(context, Routes.login);
                          },
                          child: customOrangeButton(
                              margin: true,
                              buttonText: AppLocalizations.of(context)
                                  .translate("to_begin")))
                  ],
                ),
              ),
            ],
          ),
        ));
      },
      onModelReady: (model) {
        this.model = model;
      },
    );
  }

  containerList() {
    return SizedBox(
      height: Utils.calculateGridHeight(context: context, size: 9),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: model.onBoardingList.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return inkWell(
            onTap: () {
              model.curr = index - 1;
              if (model.curr != model.onBoardingList.length - 1) {
                model.controller.jumpToPage(model.curr + 1);
              } else {
                model.controller.jumpToPage(0);
              }
            },
            child: Container(
              width: 9,
              decoration: BoxDecoration(
                border: Border.all(
                  color: model.curr == index
                      ? ColorConstant.orange
                      : ColorConstant.grey88,
                ),
                borderRadius: BorderRadius.circular(50),
                color: model.curr == index
                    ? ColorConstant.orange
                    : ColorConstant.transparent,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 3),
            ),
          );
        },
      ),
    );
  }
}
