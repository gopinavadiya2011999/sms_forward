import 'package:auto_forward_sms/core/view_model/home_view_model/from_who_view_model.dart';
import 'package:auto_forward_sms/core/view_model/home_view_model/general_setting_view_model.dart';
import 'package:auto_forward_sms/core/view_model/home_view_model/history_view_model.dart';
import 'package:auto_forward_sms/core/view_model/home_view_model/home_view_model.dart';
import 'package:auto_forward_sms/core/view_model/home_view_model/new_filter_view_model.dart';
import 'package:auto_forward_sms/core/view_model/home_view_model/text_rule_view_model.dart';
import 'package:auto_forward_sms/core/view_model/home_view_model/where_to_send_view_model.dart';
import 'package:auto_forward_sms/core/view_model/on_boarding/custom_login_register_model.dart';
import 'package:auto_forward_sms/core/view_model/on_boarding/on_boarding_view_model.dart';
import 'package:auto_forward_sms/core/view_model/on_boarding/splash_view_model.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

setLocator() {
  locator.registerLazySingleton(() => SplashViewModel());
  locator.registerLazySingleton(() => OnBoardingOneViewModel());
//  locator.registerLazySingleton(() => CustomLoginRegisterViewModel());
  locator.registerLazySingleton(() => HomeViewModel());
  locator.registerLazySingleton(() => NewFilterViewModel());
  // locator.registerLazySingleton(() => GeneralSettingsViewModel());
  // locator.registerLazySingleton(() => WhereToSendViewModel());
  // locator.registerLazySingleton(() => FromWhoViewModel());
  // locator.registerLazySingleton(() => TextRuleViewModel());
  // locator.registerLazySingleton(() => HistoryViewModel());
}
