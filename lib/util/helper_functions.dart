import 'package:fluttertoast/fluttertoast.dart';

class AppMessage {
  static void showMessage(String? message, {Toast length = Toast.LENGTH_LONG}) {
    Fluttertoast.showToast(
      msg: message ?? "",
      toastLength: length,
    );
  }
}
