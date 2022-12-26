import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/image_constant.dart';
import 'package:auto_forward_sms/core/model/filter_list.dart';
import 'package:auto_forward_sms/core/utils/common_helper.dart';
import 'package:auto_forward_sms/core/utils/string_extensions.dart';
import 'package:auto_forward_sms/core/utils/utils.dart';
import 'package:auto_forward_sms/core/view_model/base_view.dart';
import 'package:auto_forward_sms/core/view_model/home_view_model/message_history_view_model.dart';
import 'package:auto_forward_sms/sms_model.dart';
import 'package:auto_forward_sms/ui/view/home_view/home_view.dart';
import 'package:auto_forward_sms/ui/widget/inkwell.dart';
import 'package:flutter/material.dart';

// import 'package:yodo1mas/testmasfluttersdktwo.dart';
import '../../../core/constant/icon_constant.dart';
import '../../../core/constant/text_style_constant.dart';
import '../../widget/white_square_button.dart';

class MessageHistoryView extends StatefulWidget {
  final FilterList? filterList;
  final Function? editTap;
  final Function({BuildContext? context})? deleteFilter;

  const MessageHistoryView(
      {Key? key, this.filterList, this.editTap, this.deleteFilter})
      : super(key: key);

  @override
  State<MessageHistoryView> createState() => _MessageHistoryViewState();
}

class _MessageHistoryViewState extends State<MessageHistoryView> {
  List<MessageModel> messageModel = [];
  SmsHistoryViewModel model = SmsHistoryViewModel();
  bool deleteTap = false;
  bool isDelete = false;

  @override
  dispose() {
    super.dispose();
    messageModel.clear();
    deleteTap = false;
    isDelete = false;
  }

  getAllSms() async {
    final allRows = await dbHelper.getAllSms();

    setState(() {
      messageModel.clear();
      for (var element in allRows) {
        messageModel.add(MessageModel.fromMap(element));

        setState(() {});
      }
    });
    // print('Message done ::${allRows.map((e) => e).toList()}');
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<SmsHistoryViewModel>(
      builder: (buildContext, model, child) {
        return WillPopScope(
          onWillPop: () async {
            bool? adsOpen = CommonHelper.interstitialAds();

            // if (adsOpen == null || adsOpen) {
            //   Yodo1MAS.instance.showInterstitialAd();
            // }
            return true;
          },
          child: Scaffold(
            body: SafeArea(
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  children: [
                    _customAppBar(),
                    SizedBox(height: MediaQuery.of(context).size.height / 25),
                    if (deleteTap &&
                        messageModel
                            .where((element) => element.isDeleted == true)
                            .toList()
                            .isNotEmpty)
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            height: 22,
                            width: 22,
                            child: Checkbox(
                                activeColor: ColorConstant.orange270,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                side: BorderSide(
                                    color: ColorConstant.orange270, width: 1.5),
                                value: isDelete,
                                onChanged: (value) {
                                  isDelete = !isDelete;
                                  setState(() {});

                                  if (isDelete) {
                                    for (var element in messageModel) {
                                      if (element.senderNo ==
                                          widget.filterList!.text) {
                                        element.isDeleted = true;
                                        setState(() {});
                                      }
                                    }
                                  } else {
                                    for (var element in messageModel) {
                                      if (element.senderNo ==
                                          widget.filterList!.text) {
                                        element.isDeleted = false;
                                      }
                                      deleteTap = false;
                                      setState(() {});
                                    }
                                  }
                                })),
                      ),
                    if (messageModel.isNotEmpty)
                      _listView()
                    else
                      Expanded(child: Center(child: _noSendData()))
                  ],
                ),
              ),
            ),
          ),
        );
      },
      onModelReady: (model) async {
        this.model = model;
        await getAllSms();
        messageModel = messageModel
            .where((element) =>
                element.senderNo == widget.filterList!.text.toString())
            .toList();

        // Yodo1MAS.instance.init(
        //     "jopV935IZE",
        //     true,
        //     (successful) =>
        //         print("@@@@@@@@@@@@@@@@successs  ${successful.toString()}"));
      },
    );
  }

  _customAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        inkWell(
            onTap: () {
              bool? adsOpen = CommonHelper.interstitialAds();
              if (adsOpen == null || adsOpen) {
                // Yodo1MAS.instance.showInterstitialAd();
                isDelete = false;
                deleteTap = false;
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: whiteShadowButton(
                customIcon: Image.asset(
              IconConstant.leftArrow,
              color: ColorConstant.orange270,
              cacheHeight: 19,
              cacheWidth: 11,
            ))),
        Flexible(
          child: Text(
            capitalizeAllSentence(widget.filterList!.filterName!),
            style: TextStyleConstant.black12
                .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
        Row(
          children: [
            inkWell(
              onTap: () {
                deleteTap = false;
                isDelete = false;

                setState(() {});
                widget.editTap!();
              },
              child: whiteShadowButton(
                  customIcon: Icon(
                    Icons.edit,
                    color: ColorConstant.orange270,
                  ),
                  height: 15,
                  width: 17),
            ),
            const SizedBox(width: 10),
            inkWell(
              onTap: () async {
                if (messageModel.isNotEmpty) {
                  if (deleteTap &&
                      messageModel
                          .where((element) => element.isDeleted == true)
                          .toList()
                          .isNotEmpty) {
                    deleteDialog();
                  } else {
                    deleteTap = !deleteTap;
                    isDelete = false;
                    setState(() {});
                  }
                } else {
                  deleteDialog(
                      text: "Are you sure you want to delete this filter ?",
                      yesTap: () {
                        widget.deleteFilter!(context: context);
                      });
                }
              },
              child: whiteShadowButton(
                  customIcon: Icon(
                    Icons.delete,
                    color: ColorConstant.orange270,
                  ),
                  height: 15,
                  width: 17),
            )
          ],
        )
      ],
    );
  }

  _noSendData() {
    return Column(
      children: [
        SizedBox(height: Utils.calculateGridHeight(context: context, size: 50)),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Image.asset(ImageConstant.whereToSend)),
        const SizedBox(height: 30),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Text("Message history not found",
              textAlign: TextAlign.center,
              style: TextStyleConstant.skipStyle.copyWith(
                  color: ColorConstant.grey88,
                  letterSpacing: 1,
                  wordSpacing: 1)),
        ),
      ],
    );
  }

  _listView() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 10),
        shrinkWrap: true,
        itemCount: messageModel.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              // if (index == 0) bannerAds(),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(10),
                decoration: customBoxDecoration(),
                child: Row(
                  children: [
                    Expanded(
                      child: inkWell(
                        onTap: () {
                          if (deleteTap) {
                            messageModel[index].isDeleted =
                                !messageModel[index].isDeleted;
                            setState(() {});

                            if (messageModel
                                .where((element) => element.isDeleted == true)
                                .toList()
                                .isEmpty) {
                              deleteTap = false;
                              isDelete = false;
                              setState(() {});
                            }
                          } else {
                            openDialog(messageModel: messageModel[index]);
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(messageModel[index].msg ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyleConstant.grey12
                                    .copyWith(fontSize: 18)),
                            Text("(From: ${messageModel[index].fromWho ?? ""})",
                                style: TextStyleConstant.grey12),
                          ],
                        ),
                      ),
                    ),
                    if (deleteTap &&
                        messageModel
                            .where((element) =>
                                element.senderNo == widget.filterList!.text)
                            .toList()
                            .isNotEmpty)
                      SizedBox(
                        height: 22,
                        width: 22,
                        child: Checkbox(
                            activeColor: ColorConstant.orange270,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            side: BorderSide(
                                color: ColorConstant.orange270, width: 1.5),
                            value: messageModel[index].isDeleted,
                            onChanged: (value) {
                              messageModel[index].isDeleted =
                                  !messageModel[index].isDeleted;
                              setState(() {});

                              if (messageModel
                                  .where((element) =>
                                      element.isDeleted == true &&
                                      element.senderNo ==
                                          widget.filterList!.text)
                                  .toList()
                                  .isEmpty) {
                                deleteTap = false;
                                isDelete = false;
                                setState(() {});
                              }
                            }),
                      )
                    // : inkWell(
                    //     onTap: () async {
                    //       await deleteSms(
                    //           smsId: messageModel[index].msgId!,
                    //           msg: messageModel[index].msg!,
                    //           fromWho: messageModel[index].fromWho!,
                    //           dateTime: messageModel[index].dateTime!);
                    //       messageModel.removeAt(index);
                    //       setState(() {});
                    //     },
                    //     child: Icon(Icons.delete,
                    //         size: 26, color: ColorConstant.orange270),
                    //   )
                  ],
                ),
              ),
              // if (index ==
              //         messageModel
              //                 .where((element) =>
              //                     element.senderNo == widget.filterList!.text)
              //                 .length -
              //             1 ||
              //     index + 1 ==
              //         (messageModel
              //                 .where((element) =>
              //                     element.senderNo == widget.filterList!.text)
              //                 .length ~/
              //             2))
              //   bannerAds()
            ],
          );
        },
      ),
    );
  }

  void openDialog({required MessageModel messageModel}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(CommonHelper.readTimestamp(
                  int.parse(messageModel.dateTime.toString()))),
              Text(
                messageModel.msg!,
                style: TextStyleConstant.grey12.copyWith(fontSize: 18),
                maxLines: 10,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              Text("(From: ${messageModel.fromWho ?? ""})",
                  style: TextStyleConstant.grey12),
            ],
          ),
          actions: [
            inkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 5),
                child: Text(
                  'close'.toUpperCase(),
                  style: TextStyleConstant.skipStyle
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void deleteDialog({String? text, GestureTapCallback? yesTap}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  text ?? "Are you sure you want to delete selected messages ?",
                  textAlign: TextAlign.center,
                  style: TextStyleConstant.black12.copyWith(fontSize: 20)),
            ],
          ),
          actions: [
            inkWell(
              onTap: () {
                deleteTap = false;
                isDelete = false;
                setState(() {});
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 5),
                child: Text(
                  'close'.toUpperCase(),
                  style: TextStyleConstant.skipStyle
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
            ),
            inkWell(
              onTap: yesTap ??
                  () async {
                    for (var value in messageModel) {
                      if (value.isDeleted &&
                          value.senderNo == widget.filterList!.text) {
                        await dbHelper.deleteSms(MessageModel(
                            msgId: value.msgId,
                            msg: value.msg,
                            fromWho: value.fromWho,
                            dateTime: value.dateTime));
                      }
                    }
                    messageModel
                        .removeWhere((element) => element.isDeleted == true);
                    setState(() {});
                    deleteTap = false;
                    isDelete = false;
                    setState(() {});
                    Navigator.pop(context);
                  },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 5),
                child: Text(
                  'Yes'.toUpperCase(),
                  style: TextStyleConstant.skipStyle
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
            )
          ],
        );
      },
    );
  }
//
// bannerAds() {
//   return Yodo1MASBannerAd(
//     size: BannerSize.Banner,
//     onLoad: () => print('Banner loaded:'),
//     onOpen: () => print('Banner clicked:'),
//     onClosed: () => print('Banner clicked:'),
//     onLoadFailed: (message) => print('Banner Ad $message'),
//     onOpenFailed: (message) => print('Banner Ad $message'),
//   );
// }
}
