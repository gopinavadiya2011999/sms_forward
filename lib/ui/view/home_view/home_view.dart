import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/icon_constant.dart';
import 'package:auto_forward_sms/core/constant/image_constant.dart';
import 'package:auto_forward_sms/core/constant/text_style_constant.dart';
import 'package:auto_forward_sms/core/localization/app_localization.dart';
import 'package:auto_forward_sms/core/model/filter_list.dart';
import 'package:auto_forward_sms/core/routing/routes.dart';
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
import 'package:auto_forward_sms/ui/widget/inkwell.dart';
import 'package:auto_forward_sms/ui/widget/rounded_floating_btn.dart';
import 'package:auto_forward_sms/ui/widget/white_square_button.dart';
import 'package:flutter/material.dart';
import '../../../core/services/fore_ground_services.dart';
import '../src/slidable_view/src/slidable.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  HomeViewModel model = HomeViewModel();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final dbHelper = DatabaseHelper.instance;
  List<FilterList> filterList = [];
  AppLifecycleState? notification;

  List<SmsModel> smsModel = [];

  //insert controllers
  String? text;

  bool? switchValue;

  //update controllers
  String? textUpdate;

  bool? switchValueUpdate;
  int? id;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    setState(() {
      notification = state;
    });
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        //box.save();
        //print("INACTIVE :: ${box.read('save')}");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        // box.save();
        print("PAUSED :: ${box.read('save')}");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  void _queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    smsModel.clear();
    allRows.forEach((element) => smsModel.add(SmsModel.fromMap(element)));
    print('Query done');
    setState(() {});
  }

  void _insert({required String text, required bool switchValue}) async {
    Map<String, dynamic> row = {
      DatabaseHelper.text: text,
      DatabaseHelper.switchOn: switchValue,
    };

    SmsModel smsModel = SmsModel.fromMap(row);
    final id = await dbHelper.insert(smsModel);
    print("^^^insert ID::: ${id}");
  }

  void _update(
      {required int id, required String text, required bool switchOn}) async {
    SmsModel smsModel = SmsModel(smsId: id, text: text, switchOn: switchOn);
    final rowsAffected = await dbHelper.update(smsModel);
    print("update::  ${rowsAffected} rows");
  }

  void _delete({required int id}) async {
    final rowsAffected = await dbHelper.delete(id);
    print("Delete::  ${rowsAffected} rows");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool? permissionsGranted;

  initPlatformState() async {
    permissionsGranted =
        await model.telephony.requestPhoneAndSmsPermissions ?? false;
    if (permissionsGranted != null && permissionsGranted == true) {
      model.telephony.listenIncomingSms(
          onNewMessage: (message) {
            final String decodeData = box.read('save');

            List<FilterList> filterListData = FilterList.decode(decodeData);
            filterListData = filterListData
                .where((element) => element.switchOn == true)
                .toList();
            print("^^^^^ ${filterListData.map((e) => e.text)}");
            setState(() {});
            if (message.body != null) {
              for (int i = 0; i < filterListData.length; i++) {
                print("***fg ${message.body!}:: ${filterListData[i].text}");
                model.telephony.sendSms(
                    to: filterListData[i].text!, message: message.body!);
              }
              setState(() {});
            }
          },
          onBackgroundMessage: onBackgroundMessage);

      /* model.initForeGroundTask(context: context);

      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = await FlutterForegroundTask.receivePort;
        model.registerReceivePort(
            context: context, receivePortData: newReceivePort);
      }*/
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
      onModelReady: (model) {
        this.model = model;
        WidgetsBinding.instance.addObserver(this);
        getPrefList();
      },
    );
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

  getPrefList() {
    final String? decodeData = box.read('save');
    if (decodeData != null) {
      filterList = FilterList.decode(decodeData);

      setState(() {});
    }
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
                  for (var value1 in this.filterList) {
                    if (value1.text == filterList.text) {
                      _update(
                          id: index,
                          text: value1.text.toString(),
                          switchOn: value1.switchOn);
                      value1.text = value.toString();
                    }
                  }
                  setState(() {});
                  String encodeData = FilterList.encode(this.filterList);
                  box.remove('save');
                  box.write('save', encodeData);
                  box.save();
                  setState(() {});
                  print(
                      "%%%% EDIT ${this.filterList.map((e) => e.text).toList()}  %%% ${box.read('save')}");
                  await initPlatformState();
                  _queryAll();
                  //await permissionFuc(filterList: this.filterList);
                }
              });
            }),
        _slideActionBtn(
            iconData: Icons.delete,
            index: index,
            onPressed: (context) async {
              this.filterList.removeAt(index);
              _delete(id: index);
              setState(() {});
              String encodeData = FilterList.encode(this.filterList);
              box.remove('save');
              box.write('save', encodeData);
              box.save();
              setState(() {});

              print(
                  "%%%% DELETE % ${this.filterList.map((e) => e.text).toList()} %% ${box.read('save')}");
              await initPlatformState();
              _queryAll();

              //     await permissionFuc(filterList: this.filterList);
            }),
      ]),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        // margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: customBoxDecoration(),
        child: Row(mainAxisSize: MainAxisSize.max, children: [
          customSwitch(
            value: filterList.switchOn,
            onChanged: (value) async {
              filterList.switchOn = value;
              setState(() {});
              _update(
                  id: index,
                  text: filterList.text.toString(),
                  switchOn: filterList.switchOn);

              String encodeData = FilterList.encode(this.filterList);
              box.write('save', '');
              box.write('save', encodeData);
              box.save();
              print(
                  "%%%% SWITCH ${this.filterList.map((e) => e.text)} TAP %%% ${box.read('save')}");

              setState(() {});
              await initPlatformState();
              _queryAll();
              //  await permissionFuc(filterList: this.filterList);
            },
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(filterList.text ?? "",
                style: TextStyleConstant.skipStyle
                    .copyWith(color: ColorConstant.black22)),
          ),
          inkWell(
              onTap: () {
                // Slidable.of(context)?.enableEndActionPane;
                // // filterList.slide = !filterList.slide;
                // setState(() {});
              },
              child: const Icon(Icons.more_vert)),
        ]),
      ),
    );
  }

  _floatingBtn() {
    return customRoundFloatingBtn(
        context: context,
        onPressed: () {
          /*  if (permissionsGranted == null) {
            showDialog(
              context: context,
              builder: (context) => smsPermissionDialog(okTap: () async {
                Navigator.pop(context);
                await initPlatformState();
                if (permissionsGranted == true) {
                  redirectToFilterScreen();
                }
              }, cancelTap: () {
                Navigator.pop(context);
              }),
            );
          } else {*/
          redirectToFilterScreen();
          // }
        });
  }

  redirectToFilterScreen() {
    Navigator.pushNamed(context, Routes.newFilter,
            arguments: SmsForwardRoute(phone: ''))
        .then((value) async {
      if (value != null) {
        _insert(text: value.toString(), switchValue: true);
        filterList.add(FilterList(text: value.toString(), switchOn: true));
        setState(() {});

        String encodeData = FilterList.encode(filterList);
        box.write('save', encodeData);
        box.save();
        setState(() {}); // filterLi

        print(
            "%%%% ON ADD TAP ${filterList.map((e) => e.text)}%%% ${box.read('save')}");
        await initPlatformState();
        _queryAll();
        //   await permissionFuc(filterList: filterList);
      }
    });
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
