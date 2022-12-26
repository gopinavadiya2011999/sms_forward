import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/icon_constant.dart';
import 'package:auto_forward_sms/core/constant/image_constant.dart';
import 'package:auto_forward_sms/core/constant/text_style_constant.dart';
import 'package:auto_forward_sms/core/localization/app_localization.dart';
import 'package:auto_forward_sms/core/model/filter_list.dart';
import 'package:auto_forward_sms/core/routing/routes.dart';
import 'package:auto_forward_sms/core/utils/flutter_toast.dart';
import 'package:auto_forward_sms/core/utils/string_extensions.dart';
import 'package:auto_forward_sms/core/utils/utils.dart';
import 'package:auto_forward_sms/core/view_model/base_view.dart';
import 'package:auto_forward_sms/database_helper.dart';
import 'package:auto_forward_sms/ui/view/home_view/message_history_view.dart';
import 'package:auto_forward_sms/ui/widget/inkwell.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:uuid/uuid.dart';
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
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/services/fore_ground_services.dart';
import '../src/slidable_view/src/slidable.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

final dbHelper = DatabaseHelper.instance;

class _HomeViewState extends State<HomeView> {
  HomeViewModel model = HomeViewModel();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<FilterList> filterList = [];
  AppLifecycleState? notification;
  bool? permissionsGranted;
  List<SmsModel> smsModel = [];
  List<MessageModel> messageModel = [];

  queryAll() async {
    final allRows = await dbHelper.queryAllRows();

    setState(() {
      smsModel.clear();
      for (var element in allRows) {
        smsModel.add(SmsModel.fromMap(element));
      }
    });
    // print('Query done ::${allRows.map((e) => e).toList()}');
  }

  void _insert(
      {required String text,
      required String filterName,
      required bool smsSwitch,
      required bool otpSwitch,
      required int index,
      required String countryCode}) async {
    int smsSwitchInt = convertBoolToInt(switchOn: smsSwitch);
    int otpSwitchInt = convertBoolToInt(switchOn: otpSwitch);

    Map<String, dynamic> row = {
      DatabaseHelper.smsId: index,
      DatabaseHelper.text: text,
      DatabaseHelper.filterName: filterName,
      DatabaseHelper.otpSwitch: otpSwitchInt,
      DatabaseHelper.switchOn: smsSwitchInt,
      DatabaseHelper.countryCode: countryCode
    };
    SmsModel smsModel = SmsModel.fromMap(row);
    await dbHelper.insert(smsModel);
    setState(() {});
  }

  void _insertSms(
      {required String smsId,
      required String msg,
      required String fromWho,
      required String senderNo,
      required String dateTime}) async {
    Map<String, dynamic> row = {
      DatabaseHelper.msgId: smsId,
      DatabaseHelper.msg: msg,
      DatabaseHelper.fromWho: fromWho,
      DatabaseHelper.dateTime: dateTime,
      DatabaseHelper.senderNo: senderNo,
    };
    MessageModel smsModel = MessageModel.fromMap(row);
    await dbHelper.insertMessage(smsModel);
    setState(() {});
  }

  void _update(
      {required int id,
      required String text,
      required String filterName,
      required String countryCode,
      required bool smsSwitch,
      required bool otpSwitch}) async {
    int smsSwitchInt = convertBoolToInt(switchOn: smsSwitch);
    int otpSwitchInt = convertBoolToInt(switchOn: otpSwitch);

    SmsModel smsModel = SmsModel(
        filterName: filterName,
        otpSwitch: otpSwitchInt,
        smsId: id,
        text: text,
        countryCode: countryCode,
        switchOn: smsSwitchInt);
    await dbHelper.update(smsModel);
    setState(() {});
  }

  void _delete(
      {required int id,
      required String text,
      required String filterName,
      required bool smsSwitch,
      required String countryCode,
      required bool otpSwitch}) async {
    int smsSwitchInt = convertBoolToInt(switchOn: smsSwitch);
    int otpSwitchInt = convertBoolToInt(switchOn: otpSwitch);

    SmsModel smsModel = SmsModel(
        smsId: id,
        countryCode: countryCode,
        text: text,
        switchOn: smsSwitchInt,
        otpSwitch: otpSwitchInt,
        filterName: filterName);
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

  List<MessageModel> messageData = [];

  initPlatformState() async {
    permissionsGranted =
        await model.telephony.requestPhoneAndSmsPermissions ?? false;
    phoneAccess = await MobileNumber.hasPhonePermission;
    if (permissionsGranted != null &&
        permissionsGranted == true &&
        phoneAccess != null &&
        phoneAccess == true) {
      model.telephony.listenIncomingSms(
          onNewMessage: (message) async {
            print("message address :: ${message.address}");
            print("message body:: ${message.body}");

            simCards = await MobileNumber.getSimCards;
            List<FilterList> filterListData = [];
            await queryAll();
            for (var element in smsModel) {
              filterListData.add(FilterList(
                  text: element.text,
                  index: element.smsId!,
                  filterName: element.filterName!,
                  otpSwitch: element.otpSwitch == 1 ? true : false,
                  smsSwitch: element.switchOn == 1 ? true : false,
                  countryCode: element.countryCode!));
            }
            setState(() {});

            // final String decodeData = box.read('save');
            // List<FilterList> filterListData = FilterList.decode(decodeData);

            filterListData = filterListData
                .where((element) => element.smsSwitch == true)
                .toList();
            setState(() {});

            Uuid uuid = const Uuid();
            if (message.body != null) {
              for (int i = 0; i < filterListData.length; i++) {
                if (!filterListData[i].otpSwitch &&
                    (message.body!.contains("otp") ||
                        message.body!.contains("Otp") ||
                        message.body!.contains("oTp") ||
                        message.body!.contains("otP") ||
                        message.body!.contains("OTP"))) {
                  print(
                      "if not sent otp fbg${message.body!}:: ${filterListData[i].text}");
                } else {
                  print(
                      "else ==***fg ${message.body!}:: ${filterListData[i].text}");
                  model.telephony.sendSms(
                      to: filterListData[i].text!, message: message.body!);
                  _insertSms(
                      senderNo: filterListData[i].countryCode.toString() +
                          filterListData[i].text.toString(),
                      smsId: uuid.v1() +
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      msg: message.body.toString(),
                      dateTime:
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      fromWho: message.address.toString());

                  showBottomLongToast("SMS forwarded successfully !!");
                }
              }

              setState(() {});
              await queryAll();
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
        await getPrefList();
      },
    );
  }

  List<SimCard>? simCards = [];

  _bodyView() {
    return SafeArea(
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
                context: context,
              ),
              if (filterList.isNotEmpty) const SizedBox(height: 30),
              filterList.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filterList.length,
                        itemBuilder: (context, index) {
                          return _filterList(filterList[index], index);
                        },
                      ),
                    )
                  : _noFilters(),
            ],
          )),
    );
  }

  getPrefList() async {
    // final String? decodeData = box.read('save');
    // if (decodeData != null) {
    // filterList = FilterList.decode(decodeData);
    await queryAll();
    for (var element in smsModel) {
      filterList.add(FilterList(
          countryCode: element.countryCode.toString(),
          index: element.smsId!,
          text: element.text,
          filterName: element.filterName,
          otpSwitch: element.otpSwitch == 1 ? true : false,
          smsSwitch: element.switchOn == 1 ? true : false));
    }
    setState(() {});
  }

  Widget _filterList(FilterList filterList, int index) {
    return inkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MessageHistoryView(
                      filterList: filterList,
                      deleteFilter: ({BuildContext? context}) {
                        _delete(
                            countryCode: filterList.countryCode,
                            id: filterList.index,
                            text: filterList.text.toString(),
                            smsSwitch: filterList.smsSwitch,
                            filterName: filterList.filterName ?? "",
                            otpSwitch: filterList.otpSwitch);
                        this.filterList.removeAt(index);
                        setState(() {});
                        showBottomLongToast(
                            "Deleted ${filterList.text.toString()} successfully !!");
                        Navigator.pop(context!);
                        Navigator.pop(context);
                      },
                      editTap: () {
                        _onEditTap(filterList: filterList);
                      },
                    )));
      },
      child: Slidable(
        enabled: true,
        key: ObjectKey(filterList),
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          _slideActionBtn(
              iconData: Icons.edit,
              index: index,
              onPressed: (context) {
                _onEditTap(filterList: filterList);
              }),
          _slideActionBtn(
              iconData: Icons.delete,
              index: index,
              onPressed: (context) async {
                _delete(
                    countryCode: filterList.countryCode,
                    id: filterList.index,
                    text: filterList.text.toString(),
                    smsSwitch: filterList.smsSwitch,
                    filterName: filterList.filterName ?? "",
                    otpSwitch: filterList.otpSwitch);
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
              }),
        ]),
        child: Container(
          height: 60,
          padding: const EdgeInsets.only(left: 8),
          decoration: customBoxDecoration(),
          child: Row(mainAxisSize: MainAxisSize.max, children: [
            customSwitch(
              value: filterList.smsSwitch,
              onChanged: (value) async {
                filterList.smsSwitch = value;
                setState(() {});
                _update(
                    countryCode: filterList.countryCode,
                    id: filterList.index,
                    filterName: filterList.filterName ?? "",
                    otpSwitch: filterList.otpSwitch,
                    text: filterList.text.toString(),
                    smsSwitch: filterList.smsSwitch);
                // String encodeData = FilterList.encode(this.filterList);
                // box.write('save', '');
                // box.write('save', encodeData);
                // box.save();
                setState(() {});
                queryAll();
                if (value) {
                  showBottomLongToast(
                      "SMS Forwarding on for ${filterList.text}");
                } else {
                  showBottomLongToast(
                      "SMS Forwarding off for ${filterList.text}");
                }
                await initPlatformState();
              },
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(capitalizeAllSentence(filterList.filterName ?? ""),
                      style: TextStyleConstant.grey18.copyWith(
                          color: ColorConstant.black22,
                          fontWeight: FontWeight.w500)),
                  Text(
                      filterList.countryCode.toString() +
                          filterList.text.toString(),
                      style: TextStyleConstant.skipStyle
                          .copyWith(color: ColorConstant.black22)),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
                color: ColorConstant.orange270,
              ),
              height: double.infinity,
              width: 10,
            )
          ]),
        ),
      ),
    );
  }

  PermissionStatus? status;
  PermissionStatus? status1;
  bool? phoneAccess;

  _floatingBtn() {
    return customRoundFloatingBtn(
        context: context,
        onPressed: () async {
          status = await Permission.sms.request();
          status1 = await Permission.phone.request();
          if (status == PermissionStatus.granted &&
              status1 == PermissionStatus.granted) {
            permissionsGranted = true;
            phoneAccess = true;
            setState(() {});
            redirectToFilterScreen();
          } else {
            if (phoneAccess == true && permissionsGranted == true) {
              redirectToFilterScreen();
            } else {
              if (permissionsGranted == true && phoneAccess == true) {
                redirectToFilterScreen();
              } else {
                await noPermission();
              }
            }
          }
        });
  }

  int index = 1;

  redirectToFilterScreen() {
    Navigator.pushNamed(context, Routes.newFilter,
            arguments: SmsForwardRoute(
                phone: '', filterName: '', otpSwitch: false, countryCode: ''))
        .then((value) async {
      if (value != null) {
        List<String> data = value.toString().split(',');

        bool? checkValidation = checkSameNo(
            value: data.first.replaceAll("[", '').toString(), index: index);
        if (checkValidation != null && !checkValidation) {
          print("********* ${data.contains('+').toString()}");
          _insert(
              text: data.first.replaceAll("[", ''),
              filterName: data[1].toString(),
              countryCode: data[2].toString(),
              smsSwitch: filterList.isNotEmpty ? false : true,
              otpSwitch: data.last.toString().contains('true') ? true : false,
              index: filterList.isNotEmpty ? filterList.last.index + 1 : index);
          filterList.add(FilterList(
              countryCode: data[2].toString(),
              text: data.first.replaceAll("[", ''),
              filterName: data[1].toString(),
              smsSwitch: filterList.isNotEmpty ? false : true,
              otpSwitch: data.last.toString().contains('true') ? true : false,
              index:
                  filterList.isNotEmpty ? filterList.last.index + 1 : index));
          setState(() {});

          //String encodeData = FilterList.encode(filterList);
          //box.write('save', encodeData);
          //box.save();
          //setState(() {});

          queryAll();
          await initPlatformState();
        } else {
          showBottomLongToast("Mobile number already exist");
        }
      }
    });
  }

  bool? checkSameNo({required String value, required int index}) {
    bool? checkNo;

    if (index != 0 && filterList.isNotEmpty) {
      Iterable<FilterList> checkValidNo =
          filterList.where((element) => element.text == value);
      if (checkValidNo.isNotEmpty) {
        checkNo = true;
        setState(() {});
      } else {
        checkNo = false;
        setState(() {});
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

  void _onEditTap({required FilterList filterList}) {
    Navigator.pushNamed(context, Routes.newFilter,
            arguments: SmsForwardRoute(
                countryCode: filterList.countryCode,
                otpSwitch: filterList.otpSwitch,
                phone: filterList.text!,
                filterName: filterList.filterName ?? ""))
        .then((value) async {
      if (value != null) {
        List<String> data = value.toString().split(',');

        //String encodeData = FilterList.encode(filterList);
        //box.write('save', encodeData);
        //box.save();
        //setState(() {});
        bool? checkValidation = checkSameNo(
            index: filterList.index,
            value: data.first.replaceAll("[", '').toString());
        for (var value1 in this.filterList) {
          if (value1.index == filterList.index) {
            value1.text = checkValidation != null && !checkValidation
                ? data[0].replaceAll("[", '')
                : filterList.text;

            value1.otpSwitch =
                data[3].toString().contains('true') ? true : false;
            value1.filterName = data[1].toString();
            value1.countryCode = data[2].toString();
          }
        }
        if (checkValidation != null && checkValidation) {
          showBottomLongToast("Mobile number already exist");
        }
        _update(
            countryCode: data[2].toString(),
            otpSwitch: data.last.toString().contains('true') ? true : false,
            filterName: data[1].toString(),
            smsSwitch: filterList.smsSwitch,
            id: filterList.index,
            text: checkValidation != null && !checkValidation
                ? data.first.replaceAll("[", '')
                : filterList.text!);
        setState(() {});
        showBottomLongToast("Updated successfully !!");

        queryAll();
        // String encodeData = FilterList.encode(this.filterList);
        // box.remove('save');
        // box.write('save', encodeData);
        // box.save();
        // setState(() {});
        await initPlatformState();
      }
    });
  }

  Future<void> noPermission() async {
    if (status == PermissionStatus.granted &&
        status1 == PermissionStatus.granted) {
      permissionsGranted = true;
      phoneAccess = true;
      setState(() {});
      redirectToFilterScreen();
    }
    if (status == PermissionStatus.denied ||
        status1 == PermissionStatus.denied) {
      status = await Permission.sms.request();
      status1 = await Permission.phone.request();

      if (status!.isDenied || status1!.isDenied) {
        permissionsGranted = false;
        phoneAccess = false;
        await openAppSettings();

        if (status!.isGranted && status1!.isGranted) {
          permissionsGranted = true;
          phoneAccess = true;
          setState(() {});
          redirectToFilterScreen();
        }
        if (status!.isPermanentlyDenied || status1!.isPermanentlyDenied) {
          await openAppSettings();
          if (status == PermissionStatus.granted &&
              status1 == PermissionStatus.granted) {
            permissionsGranted = true;
            phoneAccess = true;
            redirectToFilterScreen();
          } else {
            permissionsGranted = false;
            phoneAccess = false;
          }
          setState(() {});
        }
      }
      if (status == PermissionStatus.permanentlyDenied ||
          status1 == PermissionStatus.permanentlyDenied) {
        await openAppSettings();
        if (status == PermissionStatus.granted &&
            status1 == PermissionStatus.granted) {
          permissionsGranted = true;
          phoneAccess = true;
          redirectToFilterScreen();
        } else {
          permissionsGranted = false;
          phoneAccess = false;
        }
        setState(() {});
      }
    }
  }
}
