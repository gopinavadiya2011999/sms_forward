import 'dart:async';

import 'package:auto_forward_sms/core/constant/image_constant.dart';
import 'package:auto_forward_sms/core/routing/routes.dart';
import 'package:auto_forward_sms/core/view_model/base_view.dart';
import 'package:auto_forward_sms/core/view_model/on_boarding/splash_view_model.dart';
import 'package:auto_forward_sms/main.dart';
import 'package:auto_forward_sms/ui/view/on_boarding/on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  SplashViewModel model = SplashViewModel();

  bool? isLogin;

  @override
  void initState() {
    super.initState();
    isLogin = box.read('login') ?? false;
    // print('login $isLogin');
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    Timer(const Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      if (isLogin != null && isLogin!) {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.home, (routes) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.onBoardingOne, (routes) => false);
      }
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
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Image.asset(ImageConstant.splashLogo),
                    )
                    // Lottie.asset(
                    //   'assets/splash/splash_anim.zip',
                    //   width: 10,
                    //   height: 10,
                    // ),
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
