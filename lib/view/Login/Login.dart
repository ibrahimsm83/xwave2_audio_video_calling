import 'dart:convert';

import 'package:chat_app_with_myysql/controller/user/dashboard_controller.dart';
import 'package:chat_app_with_myysql/util/MyPraf.dart';
import 'package:chat_app_with_myysql/service/network/ApiService.dart';
import 'package:chat_app_with_myysql/service/network/SocketManager.dart';
import 'package:chat_app_with_myysql/service/network/apis.dart';
import 'package:chat_app_with_myysql/util/methods.dart';
import 'package:chat_app_with_myysql/app/resources/myColors.dart';
import 'package:chat_app_with_myysql/util/navigation.dart';
import 'package:chat_app_with_myysql/widget/myBtn.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:chat_app_with_myysql/view/dashboard/Home.dart';
import 'package:chat_app_with_myysql/view/Login/Verification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  ApiService apiService=ApiService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        
        Expanded(child: Align(
            alignment: Alignment.topLeft,
            child: Image.asset('images/signupbg 1.png',fit: BoxFit.cover,))),
      
        container(),
      
        SizedBox(height: 20,),
        Image.asset('images/Logo.png',width: 100,),
        SizedBox(height: 10,),
        
        
      ],),
    );
  }
  
  Widget container(){
    return Container(
     // width: Get.width,
      height: 320,
      decoration: BoxDecoration(
        color: appBlack,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: myText(text: 'Loign to Your Account',size: 16,color: Colors.white,fontWeight: FontWeight.w500,),
        ),


        Padding(
          padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
          child: myBtn(text: 'Phone Number', color: Colors.white, gestureDetector: GestureDetector(onTap: () {

          },),width: Get.width),
        ),


        phone(),

        Padding(
          padding: const EdgeInsets.all(28.0),
          child: myBtn(text: 'Send OTP', color: appYellow, gestureDetector: GestureDetector(onTap: () async{

            EasyLoading.show();
            Map<String,dynamic> body={
              "phoneNumber":number.phoneNumber
            };
            var response=await apiService.postApiWithBody(sendOTP, body);
            EasyLoading.dismiss();
            print(response.body);
            if(response.statusCode==200)
              {
                var map=jsonDecode(response.body);
                String otp=map['otp'];
                next_page(Verification(nbr: number.phoneNumber!, otp: otp));
              }
            else{
              EasyLoading.showError('try again');
            }

          },),width: Get.width,),
        ),
        
        



      ],),
    );
  }
  PhoneNumber number = PhoneNumber(isoCode: 'PK');
  Widget phone(){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber numbe) {
          print(numbe.phoneNumber);
          number=numbe;
          print(number.phoneNumber);
        },
        onInputValidated: (bool value) {
          print(value);
        },
        selectorConfig: SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          useBottomSheetSafeArea: true,
        ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.disabled,
        selectorTextStyle: TextStyle(color: Colors.white),
        initialValue: number,
        // textFieldController: controller,
        formatInput: true,
        keyboardType:
        TextInputType.numberWithOptions(signed: true, decimal: true),
        inputBorder: OutlineInputBorder(),
        textStyle: TextStyle(color: Colors.white),

        onSaved: (PhoneNumber number) {
          print('On Saved: $number');
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  checkLogin()async{
    bool? b=await getLogin_praf();
    if(b==true){
      initSocket();
      await checkConected();
      //close_all_go_next_page(Home());
      AppNavigator.navigateToReplaceAll((){
        Get.put(DashboardController());
        return Home();
      });
    }

  }


  checkConected()async{
    while(socket!=null&&!socket!.connected){
      await Future.delayed(Duration(milliseconds: 100));
    }
  }
  
}
