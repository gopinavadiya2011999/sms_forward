import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/icon_constant.dart';
import 'package:auto_forward_sms/core/constant/text_style_constant.dart';
import 'package:auto_forward_sms/core/model/history_list.dart';
import 'package:auto_forward_sms/core/view_model/base_view.dart';
import 'package:auto_forward_sms/core/view_model/home_view_model/history_view_model.dart';
import 'package:auto_forward_sms/ui/check_network/check_network.dart';
import 'package:auto_forward_sms/ui/view/src/slidable_view/src/actions.dart';
import 'package:auto_forward_sms/ui/widget/custom_app_bar.dart';
import 'package:auto_forward_sms/ui/widget/white_square_button.dart';
import 'package:flutter/material.dart';
import '../../../core/localization/app_localization.dart';
import '../src/slidable_view/src/action_pane_motions.dart';
import '../src/slidable_view/src/slidable.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  HistoryViewModel model = HistoryViewModel();

  @override
  Widget build(BuildContext context) {
    return BaseView<HistoryViewModel>(
      builder: (buildContext, model, child) {
        return CheckNetwork(
            child: Scaffold(
                body: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _appBar(),
                const SizedBox(height: 23),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                        enabled: true,
                        key: ObjectKey(historyList[index]),
                        startActionPane:
                            ActionPane(motion: const ScrollMotion(), children: [
                          CustomSlidableAction(
                            onPressed: (context) {
                              historyList.removeAt(index);
                              setState(() {});
                            },
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                topLeft: Radius.circular(8)),
                            backgroundColor: ColorConstant.orange270,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [Text("Delete")],
                            ),
                          ),
                        ]),
                        child: Container(
                          height: 85,
                          decoration: customBoxDecoration(),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color: ColorConstant.orange270,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5)),
                                  )),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(historyList[index].title!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyleConstant.black12),
                                        Text(historyList[index].desc!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyleConstant.grey12)
                                      ]),
                                ),
                              )
                            ],
                          ),
                        ));
                  },
                )
              ],
            ),
          ),
        )));
      },
      onModelReady: (model) {
        this.model = model;
      },
    );
  }

  _appBar() {
    return customAppBar(
      arrowHeight: 19,
      noHelp: true,
      arrowWidth: 11,
      icon: IconConstant.leftArrow,
      lastIcon:
          whiteShadowButton(icon: IconConstant.delete, width: 18, height: 20),
      middleText: AppLocalizations.of(context).translate('history'),
      onFirstIconTap: () {
        Navigator.pop(context);
      },
    );
  }
}
