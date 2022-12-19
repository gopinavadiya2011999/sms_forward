import 'dart:io';

import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/icon_constant.dart';
import 'package:auto_forward_sms/core/constant/image_constant.dart';
import 'package:auto_forward_sms/core/constant/text_style_constant.dart';
import 'package:auto_forward_sms/core/localization/app_localization.dart';
import 'package:auto_forward_sms/core/model/filter_list.dart';
import 'package:auto_forward_sms/core/routing/routes.dart';
import 'package:auto_forward_sms/core/utils/flutter_toast.dart';
import 'package:auto_forward_sms/core/utils/utils.dart';
import 'package:auto_forward_sms/core/view_model/base_view.dart';
import 'package:auto_forward_sms/database_helper.dart';
import 'package:auto_forward_sms/main.dart';
import 'package:auto_forward_sms/sms_model.dart';
import 'package:auto_forward_sms/ui/view/home_view/new_filter.dart';
import 'package:auto_forward_sms/ui/view/src/home_drawer_view.dart';
import 'package:auto_forward_sms/core/view_model/home_view_model/home_view_model.dart';
import 'package:auto_forward_sms/ui/check_network/check_network.dart';
import 'package:auto_forward_sms/ui/view/src/slidable_view/src/action_pane_motions.dart';
import 'package:auto_forward_sms/ui/view/src/slidable_view/src/actions.dart';
import 'package:auto_forward_sms/ui/widget/custom_app_bar.dart';
import 'package:auto_forward_sms/ui/widget/custom_switch.dart';
import 'package:auto_forward_sms/ui/widget/rounded_floating_btn.dart';
import 'package:auto_forward_sms/ui/widget/white_square_button.dart';
import 'package:auto_forward_sms/ui/widget/yodo_ads.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yodo1mas/testmasfluttersdktwo.dart';
import '../../../core/services/fore_ground_services.dart';
import '../src/slidable_view/src/slidable.dart';
import '../src/sms_permission_dialog.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

final dbHelper = DatabaseHelper.instance;

class _HomeViewState extends State<HomeView> {
  HomeViewModel model = HomeViewModel();
  static bool _showBanner = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<FilterList> filterList = [];
  AppLifecycleState? notification;
  bool? permissionsGranted;
  List<SmsModel> smsModel = [];

  queryAll() async {
    final allRows = await dbHelper.queryAllRows();

    setState(() {
      smsModel.clear();
      for (var element in allRows) {
        smsModel.add(SmsModel.fromMap(element));
      }
    });
    if (kDebugMode) {
      print('Query done ::${allRows.map((e) => e).toList()}');
    }
  }

  void _insert(
      {required String text,
      required bool switchValue,
      required int index}) async {
    int value = convertBoolToInt(switchOn: switchValue);

    Map<String, dynamic> row = {
      DatabaseHelper.smsId: index,
      DatabaseHelper.text: text,
      DatabaseHelper.switchOn: value
    };
    SmsModel smsModel = SmsModel.fromMap(row);
    await dbHelper.insert(smsModel);
    setState(() {});
  }

  void _update(
      {required int id, required String text, required bool switchOn}) async {
    int value = convertBoolToInt(switchOn: switchOn);

    SmsModel smsModel = SmsModel(smsId: id, text: text, switchOn: value);
    await dbHelper.update(smsModel);
    setState(() {});
  }

  void _delete(
      {required int id, required String text, required bool switchOn}) async {
    int value = convertBoolToInt(switchOn: switchOn);

    SmsModel smsModel = SmsModel(smsId: id, text: text, switchOn: value);
    await dbHelper.delete(smsModel);
    setState(() {});
  }

  convertBoolToInt({required bool switchOn}) {
    int value = 0;
    if (switchOn) {
      value = 1;
      setState(() {});
    } else {
      value = 0;
      setState(() {});
    }

    return value;
  }

  initPlatformState() async {
    permissionsGranted =
        await model.telephony.requestPhoneAndSmsPermissions ?? false;
    if (permissionsGranted != null && permissionsGranted == true) {
      model.telephony.listenIncomingSms(
          onNewMessage: (message) async {
            await queryAll();
            List<FilterList> filterListData = [];
            for (var element in smsModel) {
              filterListData.add(FilterList(
                  text: element.text,
                  index: element.smsId!,
                  switchOn: element.switchOn == 1 ? true : false));
            }
            setState(() {});

            // final String decodeData = box.read('save');
            // List<FilterList> filterListData = FilterList.decode(decodeData);

            filterListData = filterListData
                .where((element) => element.switchOn == true)
                .toList();
            if (kDebugMode) {
              print("^^^^^ ${filterListData.map((e) => e.text)}");
            }
            setState(() {});
            if (message.body != null) {
              for (int i = 0; i < filterListData.length; i++) {
                if (kDebugMode) {
                  print("***fg ${message.body!}:: ${filterListData[i].text}");
                }
                model.telephony.sendSms(
                    to: filterListData[i].text!, message: message.body!);
              }
              showBottomLongToast("SMS forwarded successfully !!");

              setState(() {});
            }
          },
          onBackgroundMessage: onBackgroundMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      builder: (buildContext, model, child) {
        return CheckNetwork(
          child: Scaffold(
              key: _key,
              drawerEdgeDragWidth: 100,
              //drawerEnableOpenDragGesture: false,
              drawer: HomeDrawerView(stateFunction: () {
                setState(() {});
              }),
              floatingActionButton: _floatingBtn(),
              body: _bodyView()),
        );
      },
      onModelReady: (model) async {
        this.model = model;
        String? deviceId = await _getId();
        print("device idd====== ${deviceId}");
        Yodo1MAS.instance.init("852XRc1nYX", true /*enablePrivacyDialog*/,
            (successful) => debugPrint(successful.toString()));
        initPlatformStates();
        getPrefList();
      },
    );
  }

  Future<void> initPlatformStates() async {
    Yodo1MAS.instance.showBannerAd();

    print("^^^^^^^%^^^r44545}");
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  _bodyView() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                customAppBar(
                  icon: IconConstant.drawer,
                  onHelpTap: () {
                    Navigator.pushNamed(context, Routes.webView,
                        arguments: 'https://sms-forwarder.com/support/');
                  },
                  middleText: AppLocalizations.of(context).translate('filters'),
                  onFirstIconTap: () {
                    _key.currentState!.openDrawer();
                  },
                ),
                if (filterList.isNotEmpty) const SizedBox(height: 30),
                filterList.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: filterList.length,
                        itemBuilder: (context, index) {
                          return _filterList(filterList[index], index);
                        },
                      )
                    : _noFilters(),
              ],
            )),
      ),
    );
  }

  getPrefList() async {
    // final String? decodeData = box.read('save');
    // if (decodeData != null) {
    // filterList = FilterList.decode(decodeData);
    await queryAll();
    for (var element in smsModel) {
      filterList.add(FilterList(
          index: element.smsId!,
          text: element.text,
          switchOn: element.switchOn == 1 ? true : false));
    }
    setState(() {});
    //   }
    // permissionFuc(filterList: filterList);
  }

  // permissionFuc({required List<FilterList> filterList}) {
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  //     model.getPermission().then((value) async {
  //       bool permissionsGranted =
  //           await model.telephony.requestPhoneAndSmsPermissions ?? false;
  //       if (permissionsGranted) {
  //         model.initForeGroundTask(context: context, filterList: filterList);
  //         if (value) {
  //           if (await FlutterForegroundTask.isRunningService) {
  //             final newReceivePort = await FlutterForegroundTask.receivePort;
  //             model.registerReceivePort(
  //                 filterList: filterList,
  //                 context: context,
  //                 receivePortData: newReceivePort);
  //           }
  //         }
  //       }
  //     });
  //   });
  // }

  Widget _filterList(FilterList filterList, int index) {
    return Slidable(
      enabled: true /*filterList.slide*/,
      key: ObjectKey(filterList),
      endActionPane: ActionPane(motion: const StretchMotion(), children: [
        _slideActionBtn(
            iconData: Icons.edit,
            index: index,
            onPressed: (context) {
              Navigator.pushNamed(context, Routes.newFilter,
                      arguments: SmsForwardRoute(phone: filterList.text!))
                  .then((value) async {
                if (value != null) {
                  bool checkValidation = checkSameNo(value: value.toString());
                  if (!checkValidation) {
                    for (var value1 in this.filterList) {
                      if (value1.text == filterList.text) {
                        value1.text = value.toString();
                      }
                    }
                    _update(
                        id: filterList.index,
                        text: value.toString(),
                        switchOn: filterList.switchOn);
                    setState(() {});
                    showBottomLongToast("Updated successfully !!");

                    queryAll();
                    // String encodeData = FilterList.encode(this.filterList);
                    // box.remove('save');
                    // box.write('save', encodeData);
                    // box.save();
                    // setState(() {});
                    await initPlatformState();

                    //await permissionFuc(filterList: this.filterList);
                  } else {
                    showBottomLongToast("Mobile number already exist");
                  }
                }
              });
            }),
        _slideActionBtn(
            iconData: Icons.delete,
            index: index,
            onPressed: (context) async {
              _delete(
                  id: filterList.index,
                  text: filterList.text.toString(),
                  switchOn: filterList.switchOn);
              this.filterList.removeAt(index);
              showBottomLongToast(
                  "Deleted ${filterList.text.toString()} successfully !!");

              setState(() {});
              // String encodeData = FilterList.encode(this.filterList);
              // box.remove('save');
              // box.write('save', encodeData);
              // box.save();
              // setState(() {});

              queryAll();
              await initPlatformState();

              //await permissionFuc(filterList: this.filterList);
            }),
      ]),
      child: Container(
        height: 40,
        padding: const EdgeInsets.only(/*top: 10, bottom: 10,*/ left: 8),
        // margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: customBoxDecoration(),
        child: Row(mainAxisSize: MainAxisSize.max, children: [
          customSwitch(
            value: filterList.switchOn,
            onChanged: (value) async {
              filterList.switchOn = value;
              setState(() {});
              _update(
                  id: filterList.index,
                  text: filterList.text.toString(),
                  switchOn: filterList.switchOn);
              // String encodeData = FilterList.encode(this.filterList);
              // box.write('save', '');
              // box.write('save', encodeData);
              // box.save();
              setState(() {});
              queryAll();
              if (value) {
                showBottomLongToast("SMS Forwarding on for ${filterList.text}");
              } else {
                showBottomLongToast(
                    "SMS Forwarding off for ${filterList.text}");
              }
              await initPlatformState();

              //await permissionFuc(filterList: this.filterList);
            },
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(filterList.text ?? "",
                style: TextStyleConstant.skipStyle
                    .copyWith(color: ColorConstant.black22)),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(5),
                  topRight: Radius.circular(5)),
              color: ColorConstant.orange270,
            ),
            height: double.infinity,
            width: 10,
          )
          // inkWell(
          //     onTap: () {
          //       // Slidable.of(context)?.enableEndActionPane;
          //       // // filterList.slide = !filterList.slide;
          //       // setState(() {});
          //     },
          //     child: const Icon(Icons.more_vert)),
        ]),
      ),
    );
  }

  PermissionStatus? status;

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
  }

  _floatingBtn() {
    return customRoundFloatingBtn(
        context: context,
        onPressed: () async {
          Yodo1MAS.instance.showBannerAd();

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const YoDoAds()));
          //Yodo1MAS.instance.showInterstitialAd();
          //permissionsGranted = box.read('granted');

          status = await Permission.sms.status;
          switch (status) {
            case PermissionStatus.granted:
              box.write('granted', true);

              redirectToFilterScreen();
              break;
            case PermissionStatus.denied:
              status = await Permission.sms.request();

              if (status!.isDenied) {
                box.write('granted', false);
                await openAppSettings();

                if (status!.isGranted) {
                  box.write('granted', true);

                  redirectToFilterScreen();
                }
              }
              if (status!.isPermanentlyDenied) {
                await openAppSettings();
                if (status == PermissionStatus.granted) {
                  box.write('granted', true);
                } else {
                  box.write('3', false);
                }
              }
              break;
            default:
          }
          //   if (permissionsGranted != null &&
          //       (status == PermissionStatus.granted ||
          //           permissionsGranted == true)) {
          //     redirectToFilterScreen();
          //   } else {
          //     showDialog(
          //       context: context,
          //       builder: (context) => smsPermissionDialog(okTap: () async {
          //         Navigator.pop(context);
          //         status = await Permission.sms.request();
          //         if (status != null && status!.isGranted) {
          //           redirectToFilterScreen();
          //         } else {
          //           status = await Permission.sms.status;
          //           switch (status) {
          //             case PermissionStatus.granted:
          //               box.write('granted', true);
          //
          //               redirectToFilterScreen();
          //               break;
          //             case PermissionStatus.denied:
          //               status = await Permission.sms.request();
          //
          //               if (status!.isDenied) {
          //                 box.write('granted', false);
          //                 await openAppSettings();
          //
          //                 if (status!.isGranted) {
          //                   box.write('granted', true);
          //
          //                   redirectToFilterScreen();
          //                 }
          //               }
          //               if (status!.isPermanentlyDenied) {
          //                 await openAppSettings();
          //                 if (status == PermissionStatus.granted) {
          //                   box.write('granted', true);
          //                 } else {
          //                   box.write('3', false);
          //                 }
          //               }
          //               break;
          //             default:
          //           }
        }
        //       }, cancelTap: () {
        //         Navigator.pop(context);
        //       }),
        );
  }

  //  });

  int index = 1;

  redirectToFilterScreen() {
    Navigator.pushNamed(context, Routes.newFilter,
            arguments: SmsForwardRoute(phone: ''))
        .then((value) async {
      if (value != null) {
        bool checkValidation = checkSameNo(value: value.toString());
        if (!checkValidation) {
          _insert(
              text: value.toString(),
              switchValue: filterList.isNotEmpty ? false : true,
              index: filterList.isNotEmpty ? filterList.last.index + 1 : index);
          filterList.add(FilterList(
              text: value.toString(),
              switchOn: filterList.isNotEmpty ? false : true,
              index:
                  filterList.isNotEmpty ? filterList.last.index + 1 : index));
          setState(() {});

          //String encodeData = FilterList.encode(filterList);
          //box.write('save', encodeData);
          //box.save();
          //setState(() {});

          queryAll();
          await initPlatformState();
          //await permissionFuc(filterList: filterList);

        } else {
          showBottomLongToast("Mobile number already exist");
        }
      }
    });
  }

  bool checkSameNo({required String value}) {
    bool checkNo = false;
    if (filterList.isNotEmpty) {
      for (var element in filterList) {
        if (element.text.toString() == value.toString()) {
          checkNo = true;
          setState(() {});
        } else {
          checkNo = false;
          setState(() {});
        }
      }
    } else {
      checkNo = false;
      setState(() {});
    }
    return checkNo;
  }

  _slideActionBtn(
      {required int index,
      required IconData iconData,
      SlidableActionCallback? onPressed}) {
    return CustomSlidableAction(
      onPressed: onPressed,
      borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(8), topRight: Radius.circular(8)),
      backgroundColor: ColorConstant.orange270,
      foregroundColor: Colors.white,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(iconData)],
      ),
    );
  }

  _noFilters() {
    return Column(
      children: [
        SizedBox(height: Utils.calculateGridHeight(context: context, size: 50)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Image.asset(ImageConstant.homeFilter),
        ),
        const SizedBox(height: 20),
        Text(AppLocalizations.of(context).translate('no_filter'),
            style: TextStyleConstant.skipStyle
                .copyWith(color: ColorConstant.grey88))
      ],
    );
  }
}
