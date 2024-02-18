import 'dart:async';
import 'package:chat_app_with_myysql/controller/user/dashboard_controller.dart';
import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/model/interface.dart';
import 'package:chat_app_with_myysql/model/voice_call.dart';
import 'package:chat_app_with_myysql/resources/asset_path.dart';
import 'package:chat_app_with_myysql/resources/integer.dart';
import 'package:chat_app_with_myysql/service/audio.dart';
import 'package:chat_app_with_myysql/service/call_service.dart';
import 'package:chat_app_with_myysql/service/repository/call_repository.dart';
import 'package:chat_app_with_myysql/util/MyPraf.dart';
import 'package:chat_app_with_myysql/util/helper_functions.dart';
import 'package:chat_app_with_myysql/util/navigation.dart';
import 'package:chat_app_with_myysql/view/user/dashboard/call/calling/call_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class CallController extends GetxController implements CallEventHandler {
  static const int MAX_CALL_PARTICIPANTS = 4;

  final DashboardController _dashboardController =
      Get.find<DashboardController>();

  final CallRepository callRepository = CallRepository();
  CallService? _callService;

  VoiceCall? _currentCall;

  Timer? _timer, _elapsed_timer;

  final RxInt _elapsed_time = 0.obs;

  VoiceCall? get currentCall => _currentCall;

  bool get onCall => _currentCall != null;

  int get elapsed_time => _elapsed_time.value;

  bool get isAudioMuted => _callService?.isAudioMuted ?? false;
  bool get isVideoMuted => _callService?.isVideoMuted ?? false;
  bool get isLoudSpeakerOn => _callService?.onLoudSpeaker ?? true;

  final MyAudioPlayer _audioPlayer = MyAudioPlayer();

  List<int> getParticipantsList() {
    return _callService?.joinedUsers.keys.toList() ?? [];
  }

  List<User_model> getParticipantsUsers() {
    return _callService?.joinedUsers.values.toList() ?? [];
  }

  User_model? getParticipant(int id) {
    return _callService?.joinedUsers[id];
  }

  @override
  void onInit() {
    loadCallAudio();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  void loadCallAudio() {
    _audioPlayer.loadFromAsset(AssetPath.AUDIO_DIALING1, loop: true);
  }

  void _playCallSound() {
    if (!_audioPlayer.isplaying) {
      _audioPlayer.play();
    }
  }

  void _stopCallSound() {
    if (_audioPlayer.isplaying) {
      _audioPlayer.stop();
    }
  }

  void _initCallService() async {
    _callService = CallService(call: _currentCall!, callEventHandler: this);
    await _callService!.init();
  }

  void _destroyCallService() {
    print("call service is: $_callService");
    if (_callService != null) {
      _callService!.destroy();
      _callService = null;
    }
  }

  void _initiateCallTimer() {
    _timer ??= Timer(
        const Duration(milliseconds: AppInteger.INCOMING_CALL_TIMEOUT), () {
      if (onCall && _currentCall!.status == VoiceCall.STATUS_IDLE) {
        endCall(notify: false);
      }
    });
  }

  void _cancelCallTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _initiateElapsedTimer() {
    _elapsed_timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsed_time.value = timer.tick;
    });
  }

  void _cancelElapsedTimer() {
    _elapsed_timer?.cancel();
    _elapsed_timer = null;
    _elapsed_time.value = 0;
  }

  void _setCallConnected() {
    _updateCallStatus(VoiceCall.STATUS_CONNECTED);
    _initiateElapsedTimer();
  }

  void switchVideo(AnimationController cont) {
    if (_callService != null) {
      _callService!.switchAudioVideo();
      if (currentCall!.isVideo) {
        _callService!.toggleLoudSpeaker(true);
      } else {
        _callService!.toggleLoudSpeaker(false);
      }
      cont.forward();
      update();
    }
  }

  void switchCamera() {
    _callService?.switchCamera();
  }

  void muteAudio() {
    _callService?.muteUnmuteAudio(!_callService!.isAudioMuted);
    update();
  }

  void muteVideo() {
    _callService?.muteUnmuteVideo(!_callService!.isVideoMuted);
    update();
  }

  void toggleLoudSpeaker() {
    _callService?.toggleLoudSpeaker(!_callService!.onLoudSpeaker);
    update();
  }

  Widget renderLocalView() {
    return _callService!.localView();
  }

  Widget renderRemoteView(
    int id, {
    Key? key,
  }) {
    return _callService!.remoteView(id, key: key);
  }

  void videoCall(User_model receiver) {
    _dial(receiver, VoiceCall.TYPE_VIDEO);
  }

  void audioCall(User_model receiver) {
    _dial(receiver, VoiceCall.TYPE_AUDIO);
  }

  void _dial(User_model receiver, String type) async {
    _currentCall = VoiceCall(
      dialer: _dashboardController.user_model,
      receiver: receiver,
      type: type,
      category: VoiceCall.CATEGORY_SINGLE,
      status: VoiceCall.STATUS_IDLE,
      side: VoiceCall.SIDE_DIALER,
    );
    if (await _checkForPermission()) {
      _playCallSound();
      final String token = await getToken_praf();
      callRepository.makeCall(token, receiver.id, type).then((value) {
        if (onCall && value != null) {
          currentCall!.id = value.id;
          currentCall!.channel = value.channel;
          currentCall!.token = value.token;
          _initiateCallTimer();
        }
      });
    }
    AppNavigator.navigateTo(CallScreen());
  }

  void receiveCall() async {
    if (await _checkForPermission()) {
      _updateCallStatus(VoiceCall.STATUS_CONNECTING);
      if (!_currentCall!.isGroup) {
        postAction(_currentCall!.status!);
      }
      /*_notificationService.removeNotification(VoiceCall.CALL_ID);
      _database.removeCurrentCall();*/
      _cancelCallTimer();
      _initCallService();
    }
  }

  // handles for dialer
  void _joinCall() {
    _updateCallStatus(VoiceCall.STATUS_CONNECTING);
    _stopCallSound();
    _cancelCallTimer();
    _initCallService();
  }

  Future<void> postAction(String status) async {
    if (_currentCall!.id != null) {
      final String token = await getToken_praf();
      callRepository.callAction(token, _currentCall!.id!, status);
    }
  }

  void endCall({bool notify = true}) async {
    print("call ended");
    if (onCall) {
      if (!_currentCall!.isEnded) {
        _updateCallStatus(VoiceCall.STATUS_ENDED);
        if (notify) {
          if (!_currentCall!.isGroup) {
            await postAction(_currentCall!.status!);
          }
        }
        if (!_currentCall!.isDialed) {
          /*   print("call is not dialed");
        _notificationService.removeNotification(VoiceCall.CALL_ID);
        _database.removeCurrentCall();*/
        }
        _stopCallSound();
        _cancelCallTimer();
        _destroyCallService();
        _cancelElapsedTimer();
        await Future.delayed(const Duration(seconds: 1));
        _currentCall = null;
        AppNavigator.popUntil(CallScreen.route);
        if (Get.currentRoute == CallScreen.route) {
          AppNavigator.pop();
        }
      }
    }
  }

  // handles at receiver side
  void handleIncomingCall(VoiceCall call,
      {bool shownotification = true, bool savecall = true}) {
    if (!onCall) {
      if (call.isIdle) {
        _currentCall = call;
/*        if (savecall) {
          _database.saveCurrentCall(call);
        }
        if (shownotification) {
          showCallNotification(_currentCall!, _notificationService);
        }*/
        AppNavigator.navigateTo(CallScreen());
        _initiateCallTimer();
      }
    } else {
      if ((call.id == _currentCall!.id)) {
        if (!call.isGroup) {
          if (call.isConnecting) {
            if (currentCall!.isDialed //&& getParticipantsList().isEmpty
                ) {
              _joinCall();
            }
          } else if (call.isEnded) {
            endCall(notify: false);
          }
        } else {
          _currentCall!.participants = call.participants;
          update();
        }
      }
    }
  }

  Future<bool> _checkForPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.camera,
    ].request();
    bool status =
        (statuses[Permission.microphone] == PermissionStatus.granted &&
            statuses[Permission.camera] == PermissionStatus.granted);
    print("permission status: $status");
    return status;
  }

  void _updateCallStatus(String status) {
    _currentCall!.status = status;
    update();
  }

  @override
  void onUserJoined(int id) {
    final int length = getParticipantsList().length;
    if (length == 1) {
      _setCallConnected();
    } else if (length > 1) {
      currentCall!.category = VoiceCall.CATEGORY_GROUP;
    }
    update();
    // _callService?.enableVideo();
  }

  @override
  void onUserLeave(int id) {
    final int length = getParticipantsList().length;
    if (length <= 0) {
      endCall(notify: false);
    } else {
      if (length <= 1) {
        // currentCall!.category = VoiceCall.CATEGORY_SINGLE;
      }
      update();
    }
  }

  @override
  void onSelfJoin() {
    if (currentCall!.isGroup) {
      _setCallConnected();
    }
  }

  Future<void> inviteCallParticipants(List<String> ids) async {
    if (currentCall != null && currentCall!.id != null) {
      AppLoader.showLoader();
      final String token = await getToken_praf();
      bool status = await callRepository.inviteCallParticipants(
          token, currentCall!.id!, ids);
      AppLoader.dismissLoader();
      if (status) {
        AppNavigator.pop();
      }
    }
  }
}
