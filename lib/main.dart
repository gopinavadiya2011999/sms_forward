import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/constant.dart';
import 'package:auto_forward_sms/core/localization/app_localization.dart';
import 'package:auto_forward_sms/core/routing/locator.dart';
import 'package:auto_forward_sms/core/routing/router.dart';
import 'package:auto_forward_sms/core/routing/routes.dart';
import 'package:auto_forward_sms/provider/provider_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/view/on_boarding/splash_view.dart';

// GetStorage box = GetStorage();
late SharedPreferences preferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setLocator();
  preferences = await SharedPreferences.getInstance();
  preferences.reload();

  // await GetStorage.init();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.black));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Flutter Demo',
        home: const SplashView(),
        themeMode: ThemeMode.light,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          //brightness: Brightness.light,
          appBarTheme: AppBarTheme(
              color: ColorConstant.black,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              titleTextStyle: const TextStyle(color: Colors.black)),
        ),
        darkTheme: ThemeData(
          //fontFamily: 'Helvetica',
          brightness: Brightness.dark,
          appBarTheme: AppBarTheme(
              color: ColorConstant.transparent,
              titleTextStyle: const TextStyle(color: Colors.black)),
        ),
        locale: const Locale(LANG_ENG, ''),
        supportedLocales: const [
          Locale(LANG_ENG, ''),
          Locale(LANG_ES, ''),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        // initialRoute: Routes.home,
        initialRoute: Routes.splash,
        onGenerateRoute: PageRouter.generateRoutes,
        debugShowCheckedModeBanner: false,
        //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
