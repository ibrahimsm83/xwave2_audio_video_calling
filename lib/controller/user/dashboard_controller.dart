
import 'package:chat_app_with_myysql/controller/auth_controller.dart';
import 'package:chat_app_with_myysql/controller/user/call_controller.dart';
import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/model/group_messages_model.dart';
import 'package:chat_app_with_myysql/model/interface.dart';
import 'package:chat_app_with_myysql/model/voice_call.dart';
import 'package:chat_app_with_myysql/service/socket.dart';
import 'package:chat_app_with_myysql/util/MyPraf.dart';
import 'package:chat_app_with_myysql/util/config.dart';
import 'package:chat_app_with_myysql/util/methods.dart';
import 'package:chat_app_with_myysql/util/navigation.dart';
import 'package:chat_app_with_myysql/view/login/login_screen.dart';

import 'package:get/get.dart';

import '../../service/network/ApiService.dart';
import '../../view/group_chat_screen/controller.dart';

class DashboardController extends GetxController with SocketMessageHandler{
  User_model? user_model;

 // final ApiService apiService=ApiService();

  final SocketService socketService=SocketService(AppConfig.SERVER);

  late CallController callController;
   GroupMessageController groupController=Get.put(GroupMessageController());

  @override
  void onInit() {
    socketService.connect(this,events: [SocketEvent.AUDIO_CALL,SocketEvent.VIDEO_CALL,
     SocketEvent.PARTICIPANTS_ADDED,
     // SocketEvent.CHAT_LIST_UPDATE
    ]);
    super.onInit();
  }

  @override
  void onReady() {
    callController=Get.find<CallController>();
    // groupController=Get.find<GroupMessageController>();

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
          type: (name==SocketEvent.AUDIO_CALL)?VoiceCall.TYPE_AUDIO:VoiceCall.TYPE_VIDEO,
          category: VoiceCall.CATEGORY_SINGLE);
      call.id=call.channel;
      callController.handleIncomingCall(call);
    }
    else if(name==SocketEvent.PARTICIPANTS_ADDED){
      // group call
      var map=Map<String,User_model>.fromIterable(data["updatedParticipants"],key: (val){
        return val["_id"];
      },value: (val){
        return User_model.fromCallJson(val);
      });
      VoiceCall call=VoiceCall.fromMap(data,side: VoiceCall.SIDE_RECEIVER,
          status: VoiceCall.STATUS_IDLE,type: VoiceCall.TYPE_AUDIO,
          user: user_model,participants: map,
          category: VoiceCall.CATEGORY_GROUP);
      call.channel=call.id;
      callController.handleIncomingCall(call);
    }
    else if(name==SocketEvent.HANDLE_CALL_EVENT){
      VoiceCall call=VoiceCall.fromMap(
        data,
        status: data["action"],
        category: VoiceCall.CATEGORY_SINGLE,);
      callController.handleIncomingCall(call);
    }else if(name==SocketEvent.NEW_GROUP_MESSAGE){
      groupController.groupChatList.add(GroupMessages.fromJson(data['message']));
      scrolList(groupController.scrollController);
      print("----------------------3--33------------");
      print(  groupController.groupChatList);

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