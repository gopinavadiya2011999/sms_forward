import 'package:auto_forward_sms/core/localization/app_localization.dart';
import 'package:auto_forward_sms/core/routing/routes.dart';
import 'package:auto_forward_sms/provider/connectivity_provider.dart';
import 'package:auto_forward_sms/ui/check_network/no_internert.dart';
import 'package:auto_forward_sms/ui/view/home_view/message_history_view.dart';
import 'package:auto_forward_sms/ui/view/home_view/web_view_data.dart';
import 'package:auto_forward_sms/ui/view/src/home_drawer_view.dart';
import 'package:auto_forward_sms/ui/view/home_view/home_view.dart';
import 'package:auto_forward_sms/ui/view/home_view/new_filter.dart';
import 'package:auto_forward_sms/ui/view/on_boarding/on_boarding.dart';
import 'package:auto_forward_sms/ui/view/on_boarding/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageRouter {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) {
      final isOnline = Provider.of<ConnectivityProvider>(context).isOnline;
      if (isOnline == false) {
        return const InternetConnectionCheck();
      }
      switch (settings.name) {
        case Routes.splash:
          return const SplashView(
              // flag: settings.arguments == null ? false : settings.arguments as bool,
              );
        case Routes.onBoardingOne:
          return const OnBoardingOne();
        case Routes.smsHistory:
          return const MessageHistoryView();
        // case Routes.login:
        //   return const LoginView();
        // case Routes.register:
        //   return const RegisterView();
        // case Routes.customLoginRegister:
        //   return CustomLoginRegisterView(
        //       titleText: settings.arguments as String,
        //       buttonText: settings.arguments as String);
        case Routes.home:
          return const HomeView();
        case Routes.homeDrawer:
          return HomeDrawerView(stateFunction: settings.arguments as Function);
        case Routes.newFilter:
          return NewFilterView(
              smsForwardRoute: settings.arguments as SmsForwardRoute);
        // case Routes.generalSetting:
        //   return const GeneralSettingsView();
        // case Routes.whereToSend:
        //   return const WhereToSendView();

        // case Routes.emailAlertDialog:
        //   return EmailAlertDialog(
        //       context: settings.arguments as BuildContext,
        //       formKey: settings.arguments as GlobalKey<FormState>);
        // case Routes.fromWho:
        //   return const FromWhoView();
        // case Routes.textRule:
        //   return const TextRuleView();
        // case Routes.history:
        //   return const HistoryView();
        case Routes.webView:
          return WebViewScreen(url: settings.arguments as String);
        default:
          return Scaffold(
              body: Center(
            child:
                Text(AppLocalizations.of(context).translate("page_not_found")),
          ));
      }
    });
  }
}
