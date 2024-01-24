import 'dart:io';

import 'package:chat_app_with_myysql/Models/User_model.dart';
import 'package:chat_app_with_myysql/helper/apis/ApiService.dart';
import 'package:chat_app_with_myysql/helper/apis/SocketManager.dart';
import 'package:chat_app_with_myysql/helper/myColors.dart';
import 'package:chat_app_with_myysql/helper/widgets/myText.dart';
import 'package:chat_app_with_myysql/helper/widgets/my_profile_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../helper/MyPraf.dart';
import '../helper/apis/apis.dart';
import '../helper/methods.dart';
import 'RunningAudioCall.dart';

class MakingAudioCall extends StatefulWidget {

  final User_model receiver;

  const MakingAudioCall({super.key, required this.receiver});

  @override
  State<MakingAudioCall> createState() => _MakingAudioCallState();
}

class _MakingAudioCallState extends State<MakingAudioCall> {
  String status='Conecting...';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBlack,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [


        
          Center(child: my_profile_container(img: widget.receiver.avatar,width: 126,height: 126,)),
          SizedBox(height: 10,),
          myText(text: widget.receiver.username,color: Colors.white,size: 26,fontWeight: FontWeight.bold,),
          SizedBox(height: 10,),
          myText(text: status,color: Colors.white,size: 18,),

          SizedBox(height: 300,),


          InkWell(
              onTap: () {
                if(chanelID.isEmpty)
                Navigator.pop(context);
                else
                  respondCall();
              },
              child: Image.asset('images/Group 65.png',width: 70,))




        ],),
    );
  }


  ApiService apiService=ApiService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    makeAudioCall();

  }

  String chanelID='';

  makeAudioCall()async{

    Map<String,dynamic> body={
      'receiverId':widget.receiver.id
    };
    Response response=await apiService.postApiWithHeaderAndBody(makeAudioCallApi, body);
    print(response.body);

    // {data: {from: {_id: 65a65609ffdcd322af8fd0f1, phoneNumber: +92100, avatar: https://i.stack.imgur.com/34AD2.jpg},
    //  channelName: 65ae1185c63c3f2335afe38a,
    //  agoraToken: 0068b896c0090924f688a6bbfbf6d20efc6IABMUqWSgDpPiZw4Dwzb1rJCj34ON906q64b6Dsm5FSUr+1ekXwAAAAAIgC4CLshBWOvZQQAAQCVH65lAgCVH65lAwCVH65lBACVH65l,
    //  callId: 65ae1185c63c3f2335afe38a}}


    if(response.statusCode==200) {
      status = 'Ringing...';
      chanelID=response.body['data']['callId'];


      registerEvent('call_accepted', acceptListner);
      registerEvent('call_rejected', rejectListner);

    }

    setState(() {

    });

  }


  respondCall()async{



    Map<String,dynamic> map={
      'callId':chanelID,
      'action':'reject'
    };
    Response response=await apiService.postApiWithHeaderAndBody(audioCallActionsApi, map);
    print(response.body);
  }


  rejectListner(dynamic newMessage)async{
    print(' reject  callsocket - '+newMessage.toString());
    Navigator.pop(context);

  }
  acceptListner(dynamic newMessage)async{
    print('accept call socket - '+newMessage.toString());

    close_current_go_next_page(RunningAudioCall(userModel: widget.receiver, chanaelID: chanelID));
  }


  @override
  void dispose() {


    unregisterEvent('call_accepted');
    unregisterEvent('call_rejected');
    super.dispose();
  }


}
