import 'dart:async';

import 'package:auto_forward_sms/core/constant/image_constant.dart';
import 'package:auto_forward_sms/core/view_model/base_view.dart';
import 'package:auto_forward_sms/core/view_model/on_boarding/splash_view_model.dart';
import 'package:auto_forward_sms/ui/view/on_boarding/on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  SplashViewModel model = SplashViewModel();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      // if (_isLogin) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const OnBoardingOne()));
      // } else {
      //  flag = true;
      setState(() {});
      //  }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<SplashViewModel>(
      builder: (buildContext, model, child) {
        return Scaffold(
          body: SafeArea(
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  const Color(0xffFFB0B8).withOpacity(0.05),
                  const Color(0xffEE5E70).withOpacity(0.1)
                ])),
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  alignment: AlignmentDirectional.center,
                  children: [
                    Positioned.fill(
                        child: Image.asset(
                      ImageConstant.splashBack,
                      color: const Color(0xffEE5E70),
                    )),
                    Lottie.asset(
                      'assets/splash/splash_anim.zip',
                      width: 10,
                      height: 10,
                    ),
                  ],
                )),
          ),
        );
      },
      onModelReady: (model) {
        this.model = model;
      },
    );
  }
}
