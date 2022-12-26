import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/icon_constant.dart';
import 'package:auto_forward_sms/core/constant/text_style_constant.dart';
import 'package:auto_forward_sms/core/localization/app_localization.dart';
import 'package:auto_forward_sms/core/routing/routes.dart';
import 'package:auto_forward_sms/core/utils/common_helper.dart';
import 'package:auto_forward_sms/core/utils/dismiss_keyboard.dart';
import 'package:auto_forward_sms/core/utils/flutter_toast.dart';
import 'package:auto_forward_sms/core/utils/utils.dart';
import 'package:auto_forward_sms/core/view_model/base_view.dart';
import 'package:auto_forward_sms/core/view_model/home_view_model/new_filter_view_model.dart';
import 'package:auto_forward_sms/main.dart';
import 'package:auto_forward_sms/region.dart';
import 'package:auto_forward_sms/region_picker.dart';
import 'package:auto_forward_sms/store.dart';
import 'package:auto_forward_sms/ui/check_network/check_network.dart';
import 'package:auto_forward_sms/ui/widget/custom_app_bar.dart';
import 'package:auto_forward_sms/ui/widget/custom_orange_button.dart';
import 'package:auto_forward_sms/ui/widget/custom_switch.dart';
import 'package:auto_forward_sms/ui/widget/custom_text_field.dart';
import 'package:auto_forward_sms/ui/widget/error_text.dart';
import 'package:auto_forward_sms/ui/widget/inkwell.dart';
import 'package:auto_forward_sms/ui/widget/rounded_floating_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:open_settings/open_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_number/phone_number.dart';
// import 'package:yodo1mas/testmasfluttersdktwo.dart';

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

    if (widget.smsForwardRoute.phone.isEmpty) {
      model.invalidMailPhone = '';
      model.invalidFilter = '';
      model.countryCodeController.clear();
      model.emailPhoneController.clear();
      model.filterNameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CheckNetwork(
      child: BaseView<NewFilterViewModel>(
        builder: (buildContext, model, child) {
          return WillPopScope(
            onWillPop: () async {
              bool? adsOpen = CommonHelper.interstitialAds();

              if (adsOpen == null || adsOpen) {
                // Yodo1MAS.instance.showInterstitialAd();
              }
              return true;
            },
            child: Scaffold(
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
                              Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      _textField2(),
                                      if (model.invalidFilter.isNotEmpty)
                                        const SizedBox(height: 2),
                                      if (model.invalidFilter.isNotEmpty)
                                        errorText(
                                            errorText: model.invalidFilter),
                                      const SizedBox(height: 20),
                                      _textField(),
                                      if (model.invalidMailPhone.isNotEmpty)
                                        const SizedBox(height: 2),
                                      if (model.invalidMailPhone.isNotEmpty)
                                        errorText(
                                            errorText: model.invalidMailPhone),
                                    ],
                                  )),
                              const SizedBox(height: 8),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      AppLocalizations.of(context)
                                          .translate('sms_sent_info'),
                                      style: TextStyleConstant.grey12)),
                              const SizedBox(height: 20),
                              _switchRowView(),
                              SizedBox(
                                  height: Utils.calculateGridHeight(
                                      context: context,
                                      size:
                                          MediaQuery.of(context).size.height >=
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
                              const SizedBox(height: 20),
                              // Yodo1MASNativeAd(
                              //   size: NativeSize.NativeLarge,
                              //   backgroundColor: "BLACK",
                              //   onLoad: () => print('Native Ad loaded:'),
                              //   onClosed: () => print('Native Ad clicked:'),
                              //   onLoadFailed: (message) =>
                              //       print('Native Ad $message'),
                              // ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        onModelReady: (model) async {
          this.model = model;
          simCards = await MobileNumber.getSimCards;
          print(" simCards!.first.number +++${simCards!.map((e) => e.number)}");

          getRegion();
          model.emailPhoneController.text = widget.smsForwardRoute.phone.trim();
          model.countryCodeController.text =
              widget.smsForwardRoute.countryCode.trim();
          model.filterNameController.text =
              widget.smsForwardRoute.filterName.trim();
          model.switchOff = widget.smsForwardRoute.otpSwitch;
          // Yodo1MAS.instance.init(
          //     "jopV935IZE",
          //     true,
          //     (successful) =>
          //         print("@@@@@@@@@@@@@@@@successs  ${successful.toString()}"));
        },
      ),
    );
  }

  List<SimCard>? simCards = [];

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
      context: context,
      arrowWidth: 11,
      icon: IconConstant.leftArrow,
      middleText: AppLocalizations.of(context).translate('new_filter'),
      onFirstIconTap: () {
        bool? adsOpen = CommonHelper.interstitialAds();

        if (adsOpen == null || adsOpen) {
          // Yodo1MAS.instance.showInterstitialAd();
          Navigator.pop(context);
        }
      },
    );
  }

  //Choose Region Method
  Region? region;

  final store = Store(PhoneNumberUtil());

  Future<void> chooseRegions() async {
    dismissKeyboard(context);

    final regions = await store.getRegions();

    final route = MaterialPageRoute<Region>(
      fullscreenDialog: true,
      builder: (_) => RegionPicker(regions: regions),
    );

    final selectedRegion = await Navigator.of(context).push<Region>(route);

    if (selectedRegion != null) {
      model.countryCodeController.text = "+${selectedRegion.prefix}";
      setState(() => region = selectedRegion);
    }
  }

  getRegion() async {
    String code = "+91";
    model.countryCodeController.text = '+91';

    final regions = await store.getRegions();

    regions.forEach((element) {
      if (element.prefix == code.replaceAll("+", "")) {
        region = element;
      }
    });
  }

  _textField() {
    return customTextField(
        countryPrefix: inkWell(
          onTap: chooseRegions,
          child: IgnorePointer(
            child: TextFormField(
              onChanged: (value) {},
              style: TextStyleConstant.skipStyle
                  .merge(TextStyle(color: ColorConstant.black22)),
              textAlign: TextAlign.center,
              controller: model.countryCodeController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyleConstant.skipStyle
                    .merge(TextStyle(color: ColorConstant.black22)),
                hintText: model.countryCodeController.text.isEmpty
                    ? "+91 "
                    : "${model.countryCodeController.text} ",
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[+0-9]")),
        ],
        keyboardType: TextInputType.number,
        validator: (value) {
          model.invalidMailPhone = '';
          if (value!.isEmpty) {
            model.invalidMailPhone =
                AppLocalizations.of(context).translate('enter_phone_val');
          } else if (value.length < 8 || value.length > 12) {
            model.invalidMailPhone = "Please enter valid mobile number";
          }

          setState(() {});
          return null;
        },
        hintText: AppLocalizations.of(context).translate('enter_email_phone'),
        labelText: AppLocalizations.of(context).translate('email_phone'),
        controller: model.emailPhoneController);
  }

  _textField2() {
    return customTextField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[0-9 a-zA-z]")),
        ],
        keyboardType: TextInputType.text,
        validator: (value) {
          model.invalidFilter = '';
          if (value!.isEmpty) {
            model.invalidFilter = "Please enter filter name";
          }
          setState(() {});
          return null;
        },
        hintText: "Enter Filter Name",
        labelText: "Filter Name",
        controller: model.filterNameController);
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
    if (_formKey.currentState!.validate() &&
        model.invalidMailPhone.isEmpty &&
        model.invalidFilter.isEmpty) {
      dismissKeyboard(context);
      setState(() {
        model.isValidForm = true;
        model.invalidFilter = '';
        model.invalidMailPhone = '';
      });

      bool? adsOpen = CommonHelper.interstitialAds();

      if (adsOpen == null || adsOpen) {
        //Yodo1MAS.instance.showInterstitialAd();

        if (simCards!.isNotEmpty) {
          String simCardNo = simCards!.first.number.toString();
          if (model.countryCodeController.text.isEmpty) {
            model.countryCodeController.text = "+91";
            setState(() {});
          }

          //917096968574
          // +918980225073
          print(
              "simcard:: ${simCardNo} || ${model.countryCodeController.text} || ${model.countryCodeController.text.replaceAll("+", '')}");
          if (("+$simCardNo") ==
                  (model.countryCodeController.text.isNotEmpty
                          ? model.countryCodeController.text
                          : "+91") +
                      model.emailPhoneController.text ||
              simCardNo == model.emailPhoneController.text ||
              simCardNo ==
                  (model.countryCodeController.text.isNotEmpty
                          ? model.countryCodeController.text.replaceAll("+", '')
                          : "91") +
                      model.emailPhoneController.text ||
              ("${model.countryCodeController.text}$simCardNo") ==
                  (model.countryCodeController.text.isNotEmpty
                          ? model.countryCodeController.text
                          : "+91") +
                      model.emailPhoneController.text) {
            showBottomLongToast("Please don't enter your sim number");
          } else {}
        } else {
          if (model.emailPhoneController.text.trim() !=
                  widget.smsForwardRoute.phone.trim() ||
              model.countryCodeController.text.trim() !=
                  widget.smsForwardRoute.countryCode.trim() ||
              model.filterNameController.text.trim() !=
                  widget.smsForwardRoute.filterName.trim() ||
              model.switchOff != widget.smsForwardRoute.otpSwitch) {
            Navigator.pop(context, [
              model.emailPhoneController.text.trim(),
              model.filterNameController.text.trim(),
              model.countryCodeController.text.isNotEmpty
                  ? model.countryCodeController.text.trim()
                  : "+91",
              model.switchOff
            ]);
          } else {
            Navigator.pop(context);
          }
        }
      }
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
  final String filterName;
  final bool otpSwitch;
  final String countryCode;

  SmsForwardRoute(
      {required this.otpSwitch,
      required this.phone,
      required this.filterName,
      required this.countryCode});
}
