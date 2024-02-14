
import 'package:chat_app_with_myysql/controller/auth_controller.dart';
import 'package:chat_app_with_myysql/controller/user/call_controller.dart';
import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/model/interface.dart';
import 'package:chat_app_with_myysql/model/voice_call.dart';
import 'package:chat_app_with_myysql/service/network/apis.dart';
import 'package:chat_app_with_myysql/service/socket.dart';
import 'package:chat_app_with_myysql/util/MyPraf.dart';
import 'package:chat_app_with_myysql/util/config.dart';
import 'package:chat_app_with_myysql/util/navigation.dart';
import 'package:chat_app_with_myysql/view/auth/Login.dart';
import 'package:get/get.dart';

import '../../service/network/ApiService.dart';

class DashboardController extends GetxController with SocketMessageHandler{
  User_model? user_model;

 // final ApiService apiService=ApiService();

  final SocketService socketService=SocketService(AppConfig.SERVER);

  late CallController callController;

  @override
  void onInit() {
    socketService.connect(this,events: [SocketEvent.AUDIO_CALL,SocketEvent.VIDEO_CALL,
     // SocketEvent.CHAT_LIST_UPDATE
    ]);
    super.onInit();
  }

  @override
  void onReady() {
    callController=Get.find<CallController>();
    super.onReady();
  }

  @override
  void onClose() {
    socketService.disconnect();
    super.onClose();
  }

  @override
  void onConnect(data) {
    super.onConnect(data);
    getID_praf().then((value) {
      socketService.emitData(SocketEvent.REGISTER, value);
    });
  }

  @override
  void onEvent(String name, data) {
    super.onEvent(name, data);
    if(name==SocketEvent.AUDIO_CALL || name==SocketEvent.VIDEO_CALL){
      VoiceCall call=VoiceCall.fromMap(data,side: VoiceCall.SIDE_RECEIVER,
          dialer: User_model.fromCallJson(data["from"]),receiver: user_model,
          status: VoiceCall.STATUS_IDLE,
          category: VoiceCall.CATEGORY_SINGLE);
      call.id=data["channelName"];
      if(name==SocketEvent.AUDIO_CALL){
        call.type=VoiceCall.TYPE_AUDIO;
      }
      else{
        call.type=VoiceCall.TYPE_VIDEO;
      }

      callController.handleIncomingCall(call);
    }
    else if(name==SocketEvent.HANDLE_CALL_EVENT){
      VoiceCall call=VoiceCall.fromMap(
        data,
        status: data["action"],
        category: VoiceCall.CATEGORY_SINGLE,);
      callController.handleIncomingCall(call);
    }

  }

  void logout() async{
    _goToLogin();
/*    AppLoader.showLoader();
    bool status=await _authProvider.logoutUser(user.accesstoken!);
    AppLoader.dismissLoader();
    if(status){
      _goToLogin();
    }*/
  }

  void _goToLogin(){
    clearPreferences();
    AppNavigator.navigateToReplaceAll((){
      Get.put(AuthController());
      return Login();
    });
  }

}