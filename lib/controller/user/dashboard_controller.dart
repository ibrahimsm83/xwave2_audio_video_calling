
import 'package:chat_app_with_myysql/controller/auth_controller.dart';
import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/model/interface.dart';
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

  @override
  void onInit() {
    socketService.connect(this,events: [SocketEvent.AUDIO_CALL,SocketEvent.VIDEO_CALL,
     // SocketEvent.CHAT_LIST_UPDATE
    ]);
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
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