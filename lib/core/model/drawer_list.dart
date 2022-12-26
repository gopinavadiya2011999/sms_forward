import 'package:auto_forward_sms/core/constant/icon_constant.dart';
import 'package:auto_forward_sms/core/routing/routes.dart';

class DrawerList {
  final String? text;
  bool? isSelected;
  final String icon;
  final String? routeName;
  final int height;
  final int width;

  DrawerList(
      {required this.height,
      required this.width,
      required this.icon,
      this.text,
      this.isSelected = false,
      this.routeName});
}

List<DrawerList> drawerListItems = [
  DrawerList(
      icon: IconConstant.filter,
      text: "Filters",
      routeName: Routes.home,
      isSelected: true,
      height: 18,
      width: 16),
  /* DrawerList(
      height: 17,
      width: 20,
      icon: IconConstant.contacts,
      text: "Contact Groups",
      routeName: Routes.home),
  DrawerList(
      height: 16,
      width: 22,
      icon: IconConstant.backup,
      text: "Backup",
      routeName: Routes.home),
  DrawerList(
      height: 20,
      width: 20,
      icon: IconConstant.settings,
      text: "Settings",
      routeName: Routes.home),*/
  // DrawerList(
  //     height: 19,
  //     width: 21,
  //     icon: IconConstant.premium,
  //     text: "Change Sim Settings",
  //     routeName: Routes.home),
  DrawerList(
      height: 20,
      width: 20,
      icon: IconConstant.help,
      text: "Privacy Policy",
      routeName: Routes.home),
  DrawerList(
      height: 20,
      width: 20,
      icon: IconConstant.write,
      text: "Write To The Developer",
      routeName: Routes.home),
  // DrawerList(
  //     height: 15,
  //     width: 18,
  //     icon: IconConstant.logout,
  //     text: "Log Out",
  //     routeName: Routes.home),
];
