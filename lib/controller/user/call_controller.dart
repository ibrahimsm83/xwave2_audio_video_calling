import 'dart:async';
import 'package:chat_app_with_myysql/controller/user/dashboard_controller.dart';
import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/model/interface.dart';
import 'package:chat_app_with_myysql/model/voice_call.dart';
import 'package:chat_app_with_myysql/resources/integer.dart';
import 'package:chat_app_with_myysql/service/call_service.dart';
import 'package:chat_app_with_myysql/service/repository/call_repository.dart';
import 'package:chat_app_with_myysql/util/MyPraf.dart';
import 'package:chat_app_with_myysql/util/navigation.dart';
import 'package:chat_app_with_myysql/view/user/dashboard/call/call_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class CallController extends GetxController implements CallEventHandler{
  static const int MAX_CALL_PARTICIPANTS=4;


  final DashboardController _dashboardController=Get.find<DashboardController>();

  final CallRepository callRepository=CallRepository();
  CallService? _callService;

  VoiceCall? _currentCall;

  Timer? _timer,_elapsed_timer;

  final RxInt _elapsed_time=0.obs;

  VoiceCall? get currentCall => _currentCall;

  bool get onCall => _currentCall!=null;

  int get elapsed_time => _elapsed_time.value;

  bool get isAudioMuted=>_callService?.isAudioMuted??false;
  bool get isVideoMuted=>_callService?.isVideoMuted??false;
  bool get isLoudSpeakerOn=>_callService?.onLoudSpeaker??true;

  void _initCallService(){
    _callService = CallService(call: _currentCall!,callEventHandler: this);
    _callService!.init();
  }

  void _destroyCallService(){
    if(_callService!=null) {
      _callService!.destroy();
      _callService=null;
    }
  }

  void _initiateCallTimer(){
    _timer=Timer(const Duration(milliseconds: AppInteger.INCOMING_CALL_TIMEOUT), (){
      if (onCall && _currentCall!.status == VoiceCall.STATUS_IDLE) {
        endCall(notify: false);
      }
    });
  }

  void _cancelCallTimer(){
    _timer?.cancel();
  }

  void _initiateElapsedTimer(){
    _elapsed_timer=Timer.periodic(
        const Duration(seconds: 1), (timer) {
      _elapsed_time.value=timer.tick;
    });
  }

  void _cancelElapsedTimer(){
    _elapsed_timer?.cancel();
    _elapsed_time.value=0;
  }

  void switchVideo(AnimationController cont){
    if(_callService!=null) {
      _callService!.switchAudioVideo();
      _callService!.toggleLoudSpeaker(true);
      cont.forward();
    }
  }

  void muteAudio(){
    _callService?.muteUnmuteAudio(!_callService!.isAudioMuted);
    update();
  }

  void muteVideo(){
    _callService?.muteUnmuteVideo(!_callService!.isVideoMuted);
    update();
  }

  void toggleLoudSpeaker(){
    _callService?.toggleLoudSpeaker(!_callService!.onLoudSpeaker);
    update();
  }

  Widget renderLocalView(){
    return _callService!.localView();
  }

  Widget renderRemoteView(int id){
    return _callService!.remoteView(id);
  }

  void videoCall(User_model receiver){
    _dial(receiver,VoiceCall.TYPE_VIDEO);
    //  AppNavigator.navigateTo(VideoCallScreen());
  }

  void audioCall(User_model receiver){
    _dial(receiver,VoiceCall.TYPE_AUDIO);
    //AppNavigator.navigateTo(CallScreen());
  }

  void _dial(User_model receiver,String type) async{
    _currentCall = VoiceCall(
      dialer: _dashboardController.user_model,
      receiver: receiver, type: type,category: VoiceCall.CATEGORY_SINGLE,
      side: VoiceCall.SIDE_DIALER,);
    if(await _checkForPermission()) {
     // playCallSound();
      final String token=await getToken_praf();
      callRepository.makeCall(token,receiver.id,type)
          .then((value) {
        if(onCall && value!=null){
          currentCall!.id=value.id;
          currentCall!.channel=value.channel;
          currentCall!.token=value.token;
          _initiateCallTimer();
        }
      });
    }
    AppNavigator.navigateTo(CallScreen());
  }

  void receiveCall() async{
    if(await _checkForPermission()) {
      _updateCallStatus(VoiceCall.STATUS_CONNECTING);
      final String token=await getToken_praf();
      callRepository.callAction(token,_currentCall!.id!,_currentCall!.status!);
      /*_notificationService.removeNotification(VoiceCall.CALL_ID);
      _database.removeCurrentCall();*/
      _cancelCallTimer();
      _initCallService();
    }
  }


  // handles for dialer
  void _joinCall(){
    _updateCallStatus(VoiceCall.STATUS_CONNECTING);
    //stopCallSound();
    _cancelCallTimer();
    _initCallService();
  }

  void endCall({bool notify=true}) async{
    if(onCall) {
      _currentCall!.status = VoiceCall.STATUS_ENDED;
      if(notify) {
        final String token=await getToken_praf();
        callRepository.callAction(token,_currentCall!.id!,_currentCall!.status!);
      }
      if (!_currentCall!.isDialed) {
     /*   print("call is not dialed");
        _notificationService.removeNotification(VoiceCall.CALL_ID);
        _database.removeCurrentCall();*/
      }
      else{
       // stopCallSound();
      }
      _cancelCallTimer();
      _destroyCallService();
      _cancelElapsedTimer();
      if(Get.currentRoute==CallScreen.route) {
        AppNavigator.pop();
      }
      _currentCall = null;
    }

  }

  // handles at receiver side
  void handleIncomingCall(VoiceCall call,{bool shownotification=true,bool savecall=true}) {
    // if(onCall) {
    if (!onCall) {
      if(call.isIdle) {
        _currentCall = call;
/*        if (savecall) {
          _database.saveCurrentCall(call);
        }
        if (shownotification) {
          showCallNotification(_currentCall!, _notificationService);
        }*/
        print("going to call screen");
        AppNavigator.navigateTo(CallScreen());
        _initiateCallTimer();
      }
    }
    else {
      if((call.id==_currentCall!.id) && !call.isGroup){
        if(call.isConnecting){
          _joinCall();
        }
        else if(call.isEnded){
          endCall(notify: false);
        }
      }
    }

  }

  Future<bool> _checkForPermission() async{
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.camera,
    ].request();
    bool status= (statuses[Permission.microphone]==PermissionStatus.granted &&
        statuses[Permission.camera]==PermissionStatus.granted);
    print("permission status: $status");
    return status;
  }

  void _updateCallStatus(String status){
    _currentCall!.status=status;
    update();
  }


  @override
  void onUserJoined(int id) {
    // TODO: implement onUserJoined
  }

  @override
  void onUserLeave(int id) {
    // TODO: implement onUserLeave
  }

  @override
  void onSelfJoin() {
    // TODO: implement onSelfJoin
  }
}