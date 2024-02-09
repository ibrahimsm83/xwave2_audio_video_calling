import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppMessage {
  static void showMessage(String? message, {Toast length = Toast.LENGTH_SHORT}) {
    Fluttertoast.showToast(
      msg: message ?? "",
      toastLength: length,
    );
  }
}

class AppLoader{

  static bool _showing=false;

  static void showLoader({bool dismissible=true,Widget? loader}){
    EasyLoading.show();
  }

  static void dismissLoader(){
    EasyLoading.dismiss();
  }
}
