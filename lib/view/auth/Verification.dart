import 'dart:convert';

import 'package:chat_app_with_myysql/controller/auth_controller.dart';
import 'package:chat_app_with_myysql/controller/user/dashboard_controller.dart';
import 'package:chat_app_with_myysql/util/MyPraf.dart';
import 'package:chat_app_with_myysql/service/network/ApiService.dart';
import 'package:chat_app_with_myysql/service/network/SocketManager.dart';
import 'package:chat_app_with_myysql/service/network/apis.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/util/navigation.dart';
import 'package:chat_app_with_myysql/view/user/dashboard/Home.dart';
import 'package:chat_app_with_myysql/view/user/dashboard/settings/profile/Info.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class Verification extends StatefulWidget {
  final String nbr,otp;
  const Verification({super.key, required this.nbr, required this.otp});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  late String otp;

  final AuthController authController=Get.find<AuthController>();

  @override
  void initState() {
    otp=widget.otp;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: myText(text: 'Phone Verification $otp',fontWeight: FontWeight.w500,size: 16,),
        )),
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: myText(text: 'Enter 6 digit verification code sent to your phone number',fontWeight: FontWeight.w500,size: 15,),
        ),


        Padding(
          padding: const EdgeInsets.all(18.0),
          child: OtpTextField(
            numberOfFields: 6,
            borderColor: appYellow,
            //set to true to show as box or false to show as dash
            showFieldAsBox: true,
            //runs when a code is typed in
            onCodeChanged: (String code) {
              //handle validation or checks here
            },
            //runs when every textfield is filled
            onSubmit: (String verificationCode) async{
              authController.verifyUser(widget.nbr, verificationCode);
            }, // end onSubmit
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
              onTap: () async{
                authController.resendCode(widget.nbr).then((value) {
                  if(value!=null){
                    setState(() {
                      otp=value;
                    });
                  }
                });
              },
              child: myText(text: 'resend code',color: appYellow)),
        )

      ],)),
    );
  }

}
