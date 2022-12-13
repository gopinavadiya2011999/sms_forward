import 'package:fluttertoast/fluttertoast.dart';

//Short bottom toast
void showBottomShortToast(String value) {
  Fluttertoast.showToast(
      msg: value,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1);
}

//Long bottom toast
void showBottomLongToast(String value) {
  Fluttertoast.showToast(
      msg: value,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1);
}
