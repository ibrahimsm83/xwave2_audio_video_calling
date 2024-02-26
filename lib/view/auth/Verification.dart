import 'dart:convert';

import 'package:chat_app_with_myysql/controller/auth_controller.dart';
import 'package:chat_app_with_myysql/controller/user/dashboard_controller.dart';
import 'package:chat_app_with_myysql/util/MyPraf.dart';
import 'package:chat_app_with_myysql/service/network/ApiService.dart';
import 'package:chat_app_with_myysql/service/network/SocketManager.dart';
import 'package:chat_app_with_myysql/service/network/apis.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/util/export.dart';
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

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          InkWell(
            onTap: ()=>Get.back(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(color:
                ColorManager.kPrimaryColor,
                shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Icon(Icons.adaptive.arrow_back,color: ColorManager.kWhiteColor,),
                ),
              ),
            ),
          ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child:Column(
                children: [
                  Text('Phone Verification',style: getSemiBoldStyle(color: ColorManager.kBlackColor,fontSize: 16,fontFamily: FontConstants.fontFamilyJakarta),),
                  Text('$otp',style: getSemiBoldStyle(color: ColorManager.kBlackColor,fontSize: 13,fontFamily: FontConstants.fontFamilyJakarta),),
                ],
              ),

            ),
          const  SizedBox.shrink(),
        ],),

        
        Padding(
          padding: const EdgeInsets.all(15.0),
          child:Text("Enter 6 digit verification code sent to your phone number",style: getSemiBoldStyle(color: ColorManager.kBlackColor,fontSize: 16,fontFamily: FontConstants.fontFamilyJakarta),),

        ),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: OtpTextField(
            numberOfFields: 6,
            borderColor: appYellow,
            fieldWidth: 50,
            enabledBorderColor: ColorManager.kBlackColor.withOpacity(0.5),
            focusedBorderColor: ColorManager.kPrimaryColor,
            textStyle: getBoldStyle(color: ColorManager.kBlackColor,fontSize: 16, fontFamily: FontConstants.fontFamilyJakarta),
            //set to true to show as box or false to show as dash
            showFieldAsBox: true,
            //runs when a code is typed in
            onCodeChanged: (String code) {
              //handle validation or checks here
            },
            borderRadius:const BorderRadius.all(Radius.circular(12),),
            //runs when every textfield is filled
            onSubmit: (String verificationCode) async{
              authController.verifyUser(widget.nbr, verificationCode);
            }, // end onSubmit
          ),
        ),
        SizedBox(height: 10.0),
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
              child:  Text('Resend Code',style: getSemiBoldStyle(color: ColorManager.kPrimaryColor,fontSize: 16,fontFamily: FontConstants.fontFamilyJakarta),),),
        )

      ],)),
    );
  }

}
