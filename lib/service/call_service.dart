import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chat_app_with_myysql/model/interface.dart';
import 'package:chat_app_with_myysql/model/voice_call.dart';
import 'package:chat_app_with_myysql/util/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    await _engine.initialize(const RtcEngineContext(
      appId: AppConfig.AGORA_APP_ID,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    _addListeners();
    //  await _engine.enableWebSdkInteroperability(true);
    if(call.type==VoiceCall.TYPE_VIDEO) {
      await _engine.enableVideo();
    }
    await _engine.setEnableSpeakerphone(_loudSpeaker);
    await _engine.startPreview();

    // await _engine.enableWebSdkInteroperability(true);
    //await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    // await _engine.setChannelProfile(ChannelProfile.Communication);
    await _engine.setClientRole(role:ClientRoleType.clientRoleBroadcaster);
    await _joinChannel();
  }

  void destroy(){
    _engine.release();
  }


  bool get initialized => _initialized;

  Future<void> _joinChannel() async{
    await _engine.joinChannel(token:call.token!, channelId:call.channel!,
        uid:call.user.num_id,
        options: const ChannelMediaOptions(),
      // ChannelMediaOptions(publishLocalAudio: true, publishLocalVideo: true)
    );
    // _engine.registerLocalUserAccount(AppConfig.AGORA_APP_ID, call.user.name);
    //_engine.joinChannelWithUserAccount(call.token, call.channel, "{\"uid\":\"${call.user.id!}\"}");
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

  void toggleLoudSpeaker(bool value){
    _loudSpeaker=value;
    _engine.setEnableSpeakerphone(value);
  }

  void _addListeners() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (error,err){
          print("error is: $error $err");
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          callEventHandler.onSelfJoin();
        },
        onLocalUserRegistered: (uid,info){
          print("localUserRegistered: $uid ${info}");
          //  _engine.joinChannelWithUserAccount(call.token, call.channel, info);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
        },
        onUserInfoUpdated: (uid,info){
          print("userInfoUpdated: $uid ${info.toJson()}");
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
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