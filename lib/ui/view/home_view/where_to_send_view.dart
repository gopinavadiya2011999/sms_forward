import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/icon_constant.dart';
import 'package:auto_forward_sms/core/constant/image_constant.dart';
import 'package:auto_forward_sms/core/constant/text_style_constant.dart';
import 'package:auto_forward_sms/core/localization/app_localization.dart';
import 'package:auto_forward_sms/core/model/where_to_send.dart';
import 'package:auto_forward_sms/core/routing/routes.dart';
import 'package:auto_forward_sms/core/utils/utils.dart';
import 'package:auto_forward_sms/core/view_model/base_view.dart';
import 'package:auto_forward_sms/core/view_model/home_view_model/where_to_send_view_model.dart';
import 'package:auto_forward_sms/ui/check_network/check_network.dart';
import 'package:auto_forward_sms/ui/view/src/email_dialog_view.dart';
import 'package:auto_forward_sms/ui/widget/custom_app_bar.dart';
import 'package:auto_forward_sms/ui/widget/custom_orange_button.dart';
import 'package:auto_forward_sms/ui/widget/inkwell.dart';
import 'package:auto_forward_sms/ui/widget/rounded_floating_btn.dart';
import 'package:auto_forward_sms/ui/widget/white_square_button.dart';
import 'package:flutter/material.dart';

class WhereToSendView extends StatefulWidget {
  const WhereToSendView({Key? key}) : super(key: key);

  @override
  State<WhereToSendView> createState() => _WhereToSendViewState();
}

class _WhereToSendViewState extends State<WhereToSendView> {
  WhereToSendViewModel model = WhereToSendViewModel();
  final _formKey = GlobalKey<FormState>();
  String data = '';


  @override
  Widget build(BuildContext context) {
    return CheckNetwork(
      child: BaseView<WhereToSendViewModel>(
        builder: (buildContext, model, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: MediaQuery
                  .of(context)
                  .size
                  .height >= 500
                  ? _bodyView()
                  : SingleChildScrollView(
                  child: _bodyView()
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


  _bodyView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _appBar(),
          SizedBox(
              height: Utils.calculateGridHeight(
                  context: context,
                  size: data.isNotEmpty
                      ? 30
                      : (MediaQuery
                      .of(context)
                      .size
                      .height >=
                      500
                      ? 124
                      : 0))),
          data.isNotEmpty ? _sendList() : _noSendData(),
          MediaQuery
              .of(context)
              .size
              .height >= 500 ? Expanded(child: _endBtn()) : _endBtn(),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  _floatingBtn() {
    return customRoundFloatingBtn(
      context: context,
      image: IconConstant.plus,
      onPressed: () {
        showDialog(
          // barrierDismissible: false,
          context: context,
          builder: (context) {
            return EmailAlertDialog(context: context, formKey: _formKey);
          },
        ).then((value) {
          if (value != null && value
              .toString()
              .isNotEmpty) {
            data = value;
            for (var element in whereToSend) {
              if (element.type == 'message') {
                element.text = data;
              }
              setState(() {});
            }
            setState(() {});
          }
        });
      },
    );
  }

  _appBar() {
    return customAppBar(
      arrowHeight: 19,
      center: true,
      arrowWidth: 11,
      icon: IconConstant.leftArrow,
      noHelp: true,
      middleText: AppLocalizations.of(context).translate('where_to_send'),
      onFirstIconTap: () {
        Navigator.pop(context);
      },
    );
  }

  _sendList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: whereToSend.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: customBoxDecoration(),
          child: Row(children: [
            Image.asset(
              whereToSend[index].icon!,
              cacheWidth: whereToSend[index].iconWidth,
              cacheHeight: whereToSend[index].iconHeight,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(whereToSend[index].text ?? "",
                  style: TextStyleConstant.skipStyle
                      .copyWith(color: ColorConstant.black22)),
            ),
            const Icon(Icons.more_vert)
          ]),
        );
      },
    );
  }

  _noSendData() {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Image.asset(ImageConstant.whereToSend)),
        const SizedBox(height: 30),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
              AppLocalizations.of(context).translate('where_to_send_desc'),
              textAlign: TextAlign.center,
              style: TextStyleConstant.skipStyle.copyWith(
                  color: ColorConstant.grey88,
                  letterSpacing: 1,
                  wordSpacing: 1)),
        ),
      ],
    );
  }

  _endBtn() {
    return Container(
        margin: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .size
                .height >= 500 ? 40 : 5),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (data.isEmpty)
                inkWell(
                    onTap: () => Navigator.pushNamed(context, Routes.fromWho),
                    child: customOrangeButton(
                        icon: IconConstant.backButton,
                        buttonText:
                        AppLocalizations.of(context).translate('next'),
                        paddingV: 14,
                        paddingH: 40)),
              const SizedBox(width: 20),
              _floatingBtn()
            ],
          ),
        ));
  }
}
