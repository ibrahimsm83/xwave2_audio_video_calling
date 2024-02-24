import 'package:chat_app_with_myysql/controller/splash_controller.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final SplashController controller=Get.find<SplashController>();

  @override
  void initState() {
    controller.proceed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.appBlack,
      body:Center(child:
        Image(image: AssetImage('assets/splashanim.gif'),),

        ),

      // Column(
      //   children: [
      //     Expanded(
      //         child: Align(
      //             alignment: Alignment.topLeft,
      //             child: Image.asset(
      //               'images/signupbg 1.png',
      //               fit: BoxFit.cover,
      //             ))),
      //     SizedBox(
      //       height: 20,
      //     ),
      //     Image.asset(
      //       'images/Logo.png',
      //       width: 100,
      //     ),
      //     SizedBox(
      //       height: 10,
      //     ),
      //   ],
      // ),
    );
  }
}
