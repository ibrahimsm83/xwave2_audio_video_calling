import 'package:chat_app_with_myysql/controller/user/dashboard_controller.dart';
import 'package:chat_app_with_myysql/util/MyPraf.dart';
import 'package:chat_app_with_myysql/util/apis/ApiService.dart';
import 'package:chat_app_with_myysql/util/apis/SocketManager.dart';
import 'package:chat_app_with_myysql/util/apis/apis.dart';
import 'package:chat_app_with_myysql/util/methods.dart';
import 'package:chat_app_with_myysql/app/resources/myColors.dart';
import 'package:chat_app_with_myysql/util/navigation.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:chat_app_with_myysql/view/dashboard/Home.dart';
import 'package:chat_app_with_myysql/view/Login/Info.dart';
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
  State<Verification> createState() => _VerificationState(nbr,otp);
}

class _VerificationState extends State<Verification> {
  String nbr,otp;

  _VerificationState(this.nbr, this.otp);

  ApiService apiService=ApiService();
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
            onSubmit: (String verificationCode)async{


              EasyLoading.show();
              Map<String,dynamic> body={
                "phoneNumber":nbr,
                "otp":verificationCode

              };

              Response response=await apiService.postApiWithBody(verifyOTP, body);
              print('samak - '+response.body.toString());
              EasyLoading.dismiss();
              if(response.statusCode==400){
                EasyLoading.showError(response.body['message']);
              }
              else if(response.statusCode==200){

                bool newUser=response.body['newUser'];



                if(newUser){
                  //close_all_go_next_page(Info(nbr: nbr,));
                  AppNavigator.navigateToReplaceAll(() {
                    Get.put(DashboardController());
                    return Info(nbr: nbr,);
                  });
                }
                else{
                  String id=response.body['user_id'];
                  String token=response.body['token'];
                  await saveDataToPraf(id, token);
                  initSocket();
                  await checkConected();
                 // close_all_go_next_page(Home());
                  AppNavigator.navigateToReplaceAll(() {
                    Get.put(DashboardController());
                    return  Home();
                  });
                }


              }
              else{
                EasyLoading.showError('invalid otp');
              }


            }, // end onSubmit
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
              onTap: () async{
                print(nbr);
                EasyLoading.show();
                Map<String,dynamic> body={
                  "phoneNumber":nbr
                };
                Response response=await apiService.postApiWithBody(sendOTP, body);
                EasyLoading.dismiss();
                print(response.body);
                if(response.statusCode==200)
                {
                  otp=response.body['otp'];
                  EasyLoading.showSuccess('OTP send');
                }
                else{
                  EasyLoading.showError('try again');
                }
              },
              child: myText(text: 'resend code',color: appYellow)),
        )

      ],)),
    );
  }

  checkConected()async{
    while(socket!=null&&!socket!.connected){
      await Future.delayed(Duration(milliseconds: 100));
    }
  }
}
