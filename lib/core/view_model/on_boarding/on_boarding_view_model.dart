import 'package:auto_forward_sms/core/model/on_boarding_list.dart';
import 'package:auto_forward_sms/core/view_model/base_model.dart';
import 'package:flutter/material.dart';

class OnBoardingOneViewModel extends BaseModel {
  List<OnBoardingList> onBoardingList = onBoarding;
  PageController controller = PageController();
  int curr = 0;
}
