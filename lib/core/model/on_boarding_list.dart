import 'package:auto_forward_sms/core/constant/image_constant.dart';

class OnBoardingList {
  String? image;
  String? title;
  String? desc;

  OnBoardingList({this.image, this.title, this.desc});
}

List<OnBoardingList> onBoarding = [
  OnBoardingList(
      image: ImageConstant.onBoardingOne,
      title: "Automatic SMS Forwarding",
      desc: "Automatically forward your SMS to other places"),
  OnBoardingList(
      image: ImageConstant.onBoardingTwo,
      title: "Choose Where To Send",
      desc:
          "there are many options available where SMS will be sent: email, another phone, telegram, ICQ and others"),
  OnBoardingList(
      image: ImageConstant.onBoardingThree,
      title: "Flexible Rules",
      desc:
          "Set up which SMS to forward: from cretain contacts, by text/regEx"),
];
