import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_token_service/agora_token_service.dart';
import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/service/network/ApiService.dart';
import 'package:chat_app_with_myysql/service/network/SocketManager.dart';
import 'package:chat_app_with_myysql/service/network/apis.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:chat_app_with_myysql/widget/my_profile_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';



const appId = "15d11305b1954adcaaa33f8c5c946f1b";
// const token = "007eJxTYFj1pNRgR4JUl+Par5PXfpp0uEnem7vmtt1qTj1vH7l9Bj8VGAxNUwwNjQ1MkwwtTU0SU5ITExONjdMskk2TLU3M0gyTgj5LpzYEMjL8eybHxMgAgSA+K0NxYm5iNgMDAHIhIAY=";
var token = "";
var channel = "samak";

final appCertificate = 'e17ded873e50483e9406035bf0882ba7';
final uid = '0';
final role = RtcRole.publisher;

final expirationInSeconds = 3600;
final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
final expireTimestamp = currentTimestamp + expirationInSeconds;

bool mute=false;

class VideoCallForCaller extends StatefulWidget {
  final User_model user_model;
   String chanelName;

   VideoCallForCaller({super.key, required this.user_model, required this.chanelName});

  @override
  State<VideoCallForCaller> createState() => _VideoCallForCallerState();
}

class _VideoCallForCallerState extends State<VideoCallForCaller> {


  ApiService apiService=ApiService();
  bool callAccepted=false;
  String status='Calling';
  int? _remoteUid;
  bool _localUserJoined = false;
 // late RtcEngine _engine;
  RtcEngine? _engine;

  bool show_me_big=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBlack,
      body: Stack(children: [

        afterCallAccept(),

        Visibility(
            visible: !callAccepted,
            child: beforeCallAccepted()),


      ],),
    );
  }

  Widget beforeCallAccepted(){
    return Stack(
      children: [

        profile(),


        Positioned(
          bottom: 10,
          child: Container(
            width: Get.width,
            child: beforeAcceptCallerOption(),
          ),
        )

    ],);
  }

  Widget profile(){
    return Column(

      children: [
        SizedBox(height: 100,),
        Center(child: my_profile_container(img: widget.user_model.avatar,width: 126,height: 126,)),
        SizedBox(height: 10,),
        myText(text: widget.user_model.username,color: Colors.white,size: 26,fontWeight: FontWeight.bold,),
        SizedBox(height: 10,),
        myText(text: status,color: Colors.white,size: 18,),

    ],);
  }
  Widget beforeAcceptCallerOption(){
    return // caller ooptions
      Row(children: [
        Spacer(),
        InkWell(
            onTap: () {

              respondCall('reject');
            },
            child: Image.asset('images/Group 65.png',width: 70,)),
        Spacer(),

      ],);
  }


  Widget afterCallAccept(){
    return Stack(children: [

      videoScreen(),


      Positioned(
        bottom: 10,
        child: Container(
          width: Get.width,
          child:callAccepted? afterAcceptOption():Container(),
        ),
      )

    ],);
  }

  Widget videoScreen(){
    return Stack(children: [
      Container(
        width: Get.width,height: Get.height,
        child:_engine==null?Container(): AgoraVideoView(controller: VideoViewController(
            rtcEngine: _engine!, canvas: VideoCanvas(uid:callAccepted?show_me_big? 0:_remoteUid??0:0,),useAndroidSurfaceView: true)),
      ),
      Positioned(
        bottom: 100,right: 5,
        child: InkWell(
          onTap: () {
            setState(() {
              show_me_big=!show_me_big;
            });
          },
          child: Container(
            child: callAccepted?Container(
              width: 100,height: 150,
              child:_remoteUid==null?Container(): AgoraVideoView(controller: VideoViewController(
                  rtcEngine: _engine!, canvas: VideoCanvas(uid: show_me_big?_remoteUid??0:0,),useAndroidSurfaceView: true)),
            ):Container(),
          ),
        ),
      ),
    ],);
  }


  Widget afterAcceptOption(){
    return Row(children: [

      Spacer(),
      IconButton(onPressed: () {

        _engine!.switchCamera();

      }, icon: Icon(CupertinoIcons.camera_rotate_fill,color: Colors.white,)),

      Spacer(),
      IconButton(onPressed: () {
        setState(() {
          mute=!mute;
        });
        _engine!.muteLocalAudioStream(mute);
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



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    makeCall();

  }


  Future<void> initAgora() async {
    channel=widget.chanelName;
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
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

    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    // require for video

    await _engine!.enableVideo();
    await _engine!.startPreview();
    await _engine!.enableLocalVideo(true);

    // require only for audio
    await _engine!.enableAudio();

    await _engine!.muteLocalAudioStream(true);

    await _engine!.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  makeCall()async{
      Map<String,dynamic> body={
        'receiverId':widget.user_model.id
      };

      var response=await apiService.postApiWithHeaderAndBody(makeVideoCallApi, body);
      print(response.body);
      if(response.statusCode==200){
        status='Ringing';
        var map=jsonDecode(response.body);
        widget.chanelName=map['data']['callId'];
        channel=widget.chanelName;
        print(widget.chanelName);
        initAgora();

        registerEvent('call_accepted', acceptListner);
        registerEvent('call_rejected', rejectListner);
        registerEvent('call_ended', endCallLinstner);
        setState(() {

        });
      }

  }





  respondCall(String action)async{



    Map<String,dynamic> map={
      'callId':widget.chanelName,
      'action':action
    };
    var response=await apiService.postApiWithHeaderAndBody(audioCallActionsApi, map);
    print(response.body);
  }



  endCallLinstner(dynamic newMessage)async{
    print(' ended  callsocket - '+newMessage.toString());

    Navigator.pop(context);
  }


  rejectListner(dynamic newMessage)async{
    print(' reject  callsocket - '+newMessage.toString());
    Navigator.pop(context);

  }
  acceptListner(dynamic newMessage)async{
    print('accept call socket - '+newMessage.toString());
    _engine!.muteLocalAudioStream(false);
    setState(() {
      callAccepted=true;
    });
  }

  @override
  void dispose() {

    unregisterEvent('call_accepted');
    unregisterEvent('call_rejected');
    unregisterEvent('call_ended');

    _engine!.leaveChannel();

    _engine!.release();
    super.dispose();
  }




}
