
import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/service/network/ApiService.dart';
import 'package:chat_app_with_myysql/service/network/SocketManager.dart';
import 'package:chat_app_with_myysql/service/network/apis.dart';
import 'package:chat_app_with_myysql/util/methods.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:chat_app_with_myysql/widget/my_profile_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_connect/http/src/response/response.dart';
// import 'package:socket_io_client/socket_io_client.dart 'as IO;

import 'RunningAudioCall.dart';

class ReceivingAudioCall extends StatefulWidget {

  final User_model caller;
  final String chanaelID;

  const ReceivingAudioCall({super.key, required this.caller, required this.chanaelID});

  @override
  State<ReceivingAudioCall> createState() => _ReceivingAudioCallState();
}

class _ReceivingAudioCallState extends State<ReceivingAudioCall> {
  String status='Ringing...';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBlack,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [


          Center(child: my_profile_container(img: widget.caller.avatar,width: 126,height: 126,)),
          SizedBox(height: 10,),
          myText(text: widget.caller.username,color: Colors.white,size: 26,fontWeight: FontWeight.bold,),
          SizedBox(height: 10,),
          myText(text: status,color: Colors.white,size: 18,),

          SizedBox(height: 300,),


          Row(children: [
            Spacer(),
            InkWell(
                onTap: () {


                  respondCall('reject');
                },
                child: Image.asset('images/Group 65.png',width: 70,)),
            Spacer(),
            InkWell(
                onTap: () {

                  respondCall('accept');
                },
                child: Image.asset('images/Group 66.png',width: 70,)),
            Spacer(),
          ],)





        ],),
    );
  }


  ApiService apiService=ApiService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    registerEvent('call_accepted', acceptListner);
    registerEvent('call_rejected', rejectListner);
  }




  respondCall(String action)async{

    Map<String,dynamic> map={
      'callId':widget.chanaelID,
      'action':action
    };
    var response=await apiService.postApiWithHeaderAndBody(audioCallActionsApi, map);
    print(response.body);
  }



  rejectListner(dynamic newMessage)async{
    print(' reject  callsocket - '+newMessage.toString());
    Navigator.pop(context);

  }
  acceptListner(dynamic newMessage)async{
    print('accept call socket - '+newMessage.toString());
    close_current_go_next_page(RunningAudioCall(userModel: widget.caller, chanaelID: widget.chanaelID));
  }

  @override
  void dispose() {

    unregisterEvent('call_accepted');
    unregisterEvent('call_rejected');
    super.dispose();
  }



}
