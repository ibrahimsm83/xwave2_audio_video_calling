import 'package:chat_app_with_myysql/controller/binding/initial_binding.dart';
import 'package:chat_app_with_myysql/view/auth/Login.dart';
import 'package:chat_app_with_myysql/view/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitialBinding(),
      home: SplashScreen(),
       builder: EasyLoading.init(),
    );
  }
}

