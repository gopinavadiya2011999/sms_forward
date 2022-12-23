import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/image_constant.dart';
import 'package:auto_forward_sms/core/utils/utils.dart';
import 'package:auto_forward_sms/ui/widget/inkwell.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../../core/utils/flutter_toast.dart';

class InternetConnectionCheck extends StatefulWidget {
  const InternetConnectionCheck({
    Key? key,
  }) : super(key: key);

  @override
  _InternetConnectionCheckState createState() => _InternetConnectionCheckState(
      //    className: className,
      );
}

class _InternetConnectionCheckState extends State<InternetConnectionCheck> {
//Show dialog if user not connected to an check_network
  _showDialog({
    text,
    context,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(text),
            actions: [
              inkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InternetConnectionCheck(),
                        ));
                  },
                  child: inkWell(
                      onTap: () async {
                        var result = await Connectivity().checkConnectivity();
                        if (result == ConnectivityResult.none) {
                          showBottomLongToast(
                              "Sorry!! You are not connected to network!!!!");
                        } else {
                          showBottomLongToast(
                              "You are connected to network!!!!");
                        }
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          "okay",
                        ),
                      )))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Image.asset(ImageConstant.homeFilter),
            ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("No Internet",
                        style: TextStyle(
                            fontSize: 20, color: ColorConstant.black)),
                    const SizedBox(height: 5),
                    inkWell(
                        onTap: () async {
                          var result = await Connectivity().checkConnectivity();
                          if (result == ConnectivityResult.none) {
                            return _showDialog(
                              context: context,
                              text: "Lost Connection",
                            );
                          } else {
                            showBottomLongToast("Not Connected");
                          }
                        },
                        child: Text("Refresh",
                            style: TextStyle(
                                fontSize: 16,
                                color: ColorConstant.orange,
                                decoration: TextDecoration.underline))),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
