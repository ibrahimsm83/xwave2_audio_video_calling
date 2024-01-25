import 'dart:async';
import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_token_service/agora_token_service.dart';
import 'package:chat_app_with_myysql/Models/User_model.dart';
import 'package:chat_app_with_myysql/helper/MyPraf.dart';
import 'package:chat_app_with_myysql/helper/apis/ApiService.dart';
import 'package:chat_app_with_myysql/helper/apis/SocketManager.dart';
import 'package:chat_app_with_myysql/helper/myColors.dart';
import 'package:chat_app_with_myysql/helper/widgets/myText.dart';
import 'package:chat_app_with_myysql/helper/widgets/my_profile_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:socket_io_client/socket_io_client.dart 'as IO;

import '../helper/apis/apis.dart';



const appId = "15d11305b1954adcaaa33f8c5c946f1b";
var channel = "samak";
// const token = "007eJxTYFj1pNRgR4JUl+Par5PXfpp0uEnem7vmtt1qTj1vH7l9Bj8VGAxNUwwNjQ1MkwwtTU0SU5ITExONjdMskk2TLU3M0gyTgj5LpzYEMjL8eybHxMgAgSA+K0NxYm5iNgMDAHIhIAY=";
var token = "";
final appCertificate = 'e17ded873e50483e9406035bf0882ba7';
final uid = '0';
final role = RtcRole.publisher;
final expirationInSeconds = 3600;
final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
final expireTimestamp = currentTimestamp + expirationInSeconds;

class RunningAudioCall extends StatefulWidget {

  final User_model userModel;
  final String chanaelID;


  const RunningAudioCall({super.key, required this.userModel, required this.chanaelID});

  @override
  State<RunningAudioCall> createState() => _RunningAudioCallState();
}

class _RunningAudioCallState extends State<RunningAudioCall> {
  String status='In Call';
  late RtcEngine _engine;

  bool mute=false,loud=false;
  late Timer _callTimer;
  int _elapsedSeconds = 0;
  String _formattedTime = '00:00';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBlack,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [


          Center(child: my_profile_container(img: widget.userModel.avatar,width: 126,height: 126,)),
          SizedBox(height: 10,),
          myText(text: widget.userModel.username,color: Colors.white,size: 26,fontWeight: FontWeight.bold,),
          SizedBox(height: 10,),
          myText(text: status,color: Colors.white,size: 18,),
          SizedBox(height: 10,),
          myText(text: _formattedTime,color: Colors.white,size: 18,),


          SizedBox(height: 300,),


          callOptions(),




        ],),
    );
  }

  Widget callOptions(){
    return Row(children: [

      Spacer(),
      IconButton(onPressed: () {

        setState(() {
          loud=!loud;
        });
        _engine.setEnableSpeakerphone(loud);

      }, icon: Icon(loud?CupertinoIcons.speaker_2_fill:CupertinoIcons.speaker_1_fill,color: Colors.white,)),

      Spacer(),
      IconButton(onPressed: () {
        setState(() {
          mute=!mute;
        });
        _engine.muteLocalAudioStream(mute);
      }, icon: Icon(mute?CupertinoIcons.mic_slash_fill:Icons.mic_outlined,color: Colors.white,)),

      Spacer(),
      InkWell(

          onTap: () {


            respondCall('end');
          },
          child: Image.asset('images/Group 65.png',width: 70,)),

      Spacer(),
    ],);
  }


  ApiService apiService=ApiService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    registerEvent('call_ended', endCallLinstner);
    initAgora();
    _startCallTimer();
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _elapsedSeconds++;
        _formattedTime = _formatTime(_elapsedSeconds);
      });
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${_twoDigits(minutes)}:${_twoDigits(remainingSeconds)}';
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    } else {
      return '0$n';
    }
  }


  Future<void> initAgora() async {
    channel=widget.chanaelID;
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            // _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            //_remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            //_remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    token= RtcTokenBuilder.build(
      appId: appId,
      appCertificate: appCertificate,
      channelName: channel,
      uid: uid,
      role: role,
      expireTimestamp: expireTimestamp,
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    // await _engine.enableVideo();
    // await _engine.startPreview();

    await _engine.enableAudio();

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );

    // if(room.creater_id!=user_model!.id)
    //   _engine.muteLocalAudioStream(true);

  }



  respondCall(String action)async{

    Map<String,dynamic> map={
      'callId':widget.chanaelID,
      'action':action
    };
    Response response=await apiService.postApiWithHeaderAndBody(audioCallActionsApi, map);
    print(response.body);
  }



  endCallLinstner(dynamic newMessage)async{
    print(' ended  callsocket - '+newMessage.toString());

    Navigator.pop(context);
  }


  @override
  void dispose() {

    unregisterEvent('call_ended');

    _engine.leaveChannel();

    _engine.release();
    _callTimer.cancel();
    super.dispose();
  }



}
