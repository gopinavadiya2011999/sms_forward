import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/image_constant.dart';
import 'package:auto_forward_sms/core/constant/text_style_constant.dart';
import 'package:auto_forward_sms/core/localization/app_localization.dart';
import 'package:auto_forward_sms/core/model/drawer_list.dart';
import 'package:auto_forward_sms/core/routing/routes.dart';
import 'package:auto_forward_sms/core/utils/utils.dart';
import 'package:auto_forward_sms/ui/view/src/developer_commet_dialog.dart';
import 'package:auto_forward_sms/ui/widget/custom_divider.dart';
import 'package:auto_forward_sms/ui/widget/inkwell.dart';
import 'package:flutter/material.dart';

class HomeDrawerView extends StatelessWidget {
  final Function stateFunction;

  HomeDrawerView({Key? key, required this.stateFunction}) : super(key: key);
  final List<DrawerList> drawerList = drawerListItems;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   margin: EdgeInsets.only(
              //     left: 20,
              //     right: 20,
              //     top: Utils.calculateGridHeight(context: context, size: 58),
              //   ),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text("Lorem Ipsume",
              //           style: TextStyleConstant.skipStyle
              //               .copyWith(color: ColorConstant.black22)),
              //       const SizedBox(height: 12),
              //       Text("loremipsum@gmail.com",
              //           style: TextStyleConstant.grey12.copyWith(
              //               color: ColorConstant.black22, fontSize: 12)),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 25),
              //   customDivider(),
              // const SizedBox(height: 10),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: drawerList.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      inkWell(
                          onTap: () {
                            for (int i = 0; i < drawerList.length; i++) {
                              if (drawerList[i].isSelected == true) {
                                drawerList[i].isSelected = false;
                              }
                              stateFunction();
                            }

                            drawerList[index].isSelected =
                                !drawerList[index].isSelected!;
                            stateFunction();
                            if (drawerList[index].text == 'Filters') {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, Routes.home, (route) => false);
                            }

                            if (drawerList[index].text == 'Privacy Policy') {
                              Navigator.pushNamed(context, Routes.webView,
                                  arguments:
                                      'https://sms-forwarder.com/privacy_policy.php');
                            }

                            if (drawerList.length - 1 == index) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return developerCommentDialog(
                                      cancelTap: () => Navigator.pop(context),
                                      okTap: () => {});
                                },
                              );
                            }
                            /*   if (drawerList[index].text == 'Log Out') {
                              Navigator.pushNamed(context, Routes.splash);
                            } else {
                              // Navigator.pushNamedAndRemoveUntil(
                              //     context,
                              //     drawerList[index].routeName!,
                              //     (route) => false);
                            }*/
                          },
                          child: _customRow(
                              iconHeight: drawerList[index].height,
                              iconWidth: drawerList[index].width,
                              text: drawerList[index].text!,
                              image: drawerList[index].icon,
                              isSelected:
                                  drawerList[index].isSelected ?? false)),
                      //  if (index == 3) const SizedBox(height: 10),
                      //  if (index == 3) customDivider(),
                      //   if (index == 3)
                      //     Container(
                      //       margin: const EdgeInsets.only(
                      //           left: 20, top: 20, bottom: 12),
                      //       child: Text(
                      //           AppLocalizations.of(context).translate('other'),
                      //           style: TextStyleConstant.grey12),
                      //     )
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _customRow(
      {required int iconWidth,
      required int iconHeight,
      required String image,
      required String text,
      bool isSelected = false}) {
    return Stack(
      children: [
        if (isSelected)
          Positioned.fill(
              child: Container(
            margin: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                Image.asset(ImageConstant.drawer2),
                Expanded(
                  child: Image.asset(ImageConstant.drawer1, fit: BoxFit.fill),
                )
              ],
            ),
          )),
        Container(
          color: ColorConstant.transparent,
          margin: isSelected
              ? const EdgeInsets.symmetric(horizontal: 10)
              : EdgeInsets.zero,
          padding: EdgeInsets.symmetric(
              horizontal: isSelected ? 24 : 4, vertical: 10),
          child: Container(
            margin: isSelected
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    image,
                    cacheWidth: iconWidth,
                    cacheHeight: iconHeight,
                    color:
                        isSelected ? ColorConstant.white : ColorConstant.grey88,
                  ),
                  const SizedBox(width: 14),
                  Flexible(
                    child: Text(
                      text,
                      style: TextStyleConstant.skipStyle.copyWith(
                          color: isSelected
                              ? ColorConstant.white
                              : ColorConstant.grey88),
                    ),
                  ),
                ]),
          ),
        ),
      ],
    );
  }
}
