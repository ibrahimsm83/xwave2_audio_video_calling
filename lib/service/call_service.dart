import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_token_service/agora_token_service.dart';
import 'package:chat_app_with_myysql/model/interface.dart';
import 'package:chat_app_with_myysql/model/voice_call.dart';
import 'package:chat_app_with_myysql/util/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/user/dashboard/OnetoOneCall/RunningAudioCall.dart';

class CallService extends GetxService{
  late RtcEngine _engine;

  bool _initialized=false;

  final VoiceCall call;
  final CallEventHandler callEventHandler;

  bool _isAudioMuted=false;
  bool _isVideoMuted=false;
  bool _loudSpeaker=false;

  CallService({required this.call,required this.callEventHandler,}){
    _loudSpeaker=(call.type==VoiceCall.TYPE_VIDEO);
  }


  void init() async{
    _engine = createAgoraRtcEngine();
    print("engine initilizing");
    await _engine.initialize(const RtcEngineContext(
      appId: AppConfig.AGORA_APP_ID,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    print("engine initilized");
    _addListeners();
    //  await _engine.enableWebSdkInteroperability(true);
   // await _engine.setEnableSpeakerphone(_loudSpeaker);
    await _engine.setClientRole(role:ClientRoleType.clientRoleBroadcaster);
    if(call.type==VoiceCall.TYPE_VIDEO) {
      await _engine.enableVideo();
    }

    await _engine.startPreview();
    print("preview started");

    // await _engine.enableWebSdkInteroperability(true);
    //await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    // await _engine.setChannelProfile(ChannelProfile.Communication);

    await _joinChannel();
    await _engine.setEnableSpeakerphone(_loudSpeaker);
    print("loudspeaker: ${await _engine.isSpeakerphoneEnabled()}");

  }

  void destroy() async{
    await _engine.leaveChannel();
    await _engine.release();
  }


  bool get initialized => _initialized;

  Future<void> _joinChannel() async{
    print("call token: ${call.token}");
    String token=getToken();
    print("new call token 1: ${token}");
/*    await _engine.joinChannel(token:token, channelId:call.channel!,
        uid:0,
        options: const ChannelMediaOptions(),
      // ChannelMediaOptions(publishLocalAudio: true, publishLocalVideo: true)
    );*/
    _engine.joinChannelWithUserAccount(token:token, channelId:call.channel!,
        userAccount:call.user.id,options: const ChannelMediaOptions());
  }

  String getToken(){
    var token= RtcTokenBuilder.build(
      appId: AppConfig.AGORA_APP_ID,
      appCertificate: AppConfig.AGORA_APP_SECRET,
      channelName: call.channel!,
      //uid: "0",
      uid: call.user.id,
      role: role,
      expireTimestamp: expireTimestamp,
    );
    return token;
  }


  bool get isAudioMuted => _isAudioMuted;
  bool get isVideoMuted => _isVideoMuted;
  bool get onLoudSpeaker => _loudSpeaker;

  void muteUnmuteAudio(bool value){
    _isAudioMuted=value;
    _engine.muteLocalAudioStream(value);
  }

  void muteUnmuteVideo(bool value){
    _isVideoMuted=value;
    _engine.muteLocalVideoStream(value);
  }

  void switchAudioVideo(){
    if(call.type==VoiceCall.TYPE_VIDEO){
      call.type=VoiceCall.TYPE_AUDIO;
      _engine.disableVideo();
    }
    else if(call.type==VoiceCall.TYPE_AUDIO){
      call.type=VoiceCall.TYPE_VIDEO;
      _engine.enableVideo();
    }
  }

  void switchCamera(){
    _engine.switchCamera();
  }

  void toggleLoudSpeaker(bool value){
    _loudSpeaker=value;
    print("loud spealer toggle: $_loudSpeaker");
    _engine.setEnableSpeakerphone(value);
  }

  void _addListeners() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (error,err){
          print("error is: $error $err");
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("join channel success ${connection.localUid} joined");
          callEventHandler.onSelfJoin();
        },
        onLocalUserRegistered: (uid,info){
          print("localUserRegistered: $uid ${info}");
          //  _engine.joinChannelWithUserAccount(call.token, call.channel, info);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          callEventHandler.onUserJoined(remoteUid);
        },
        onUserInfoUpdated: (uid,info){
          print("userInfoUpdated: $uid ${info.toJson()}");
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          callEventHandler.onUserLeave(remoteUid);
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
        onLeaveChannel: (con,stats) {
          print("leaveChannel: $con $stats");
        },
      ),
    );
  }


  Widget localView() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
/*    return Container(
      child: const rtc_local_view.TextureView(),
    );*/
  }
  Widget remoteView(int id) {
    return Container(child: AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine,
        canvas: VideoCanvas(uid: id),
        connection: RtcConnection(channelId: call.channel!),
      ),
    ));
/*    return Container(child: rtc_remote_view.TextureView(
      uid: id,
      //  uid: call.guest.num_id,
      //uid: 1000000005,
      channelId: call.channel,
    ),);*/
    /*  return rtc_remote_view.SurfaceView(
      uid: call.guest.num_id,
      channelId: call.channel,
    );*/
  }


}