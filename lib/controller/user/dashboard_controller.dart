
import 'package:chat_app_with_myysql/controller/auth_controller.dart';
import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/service/network/apis.dart';
import 'package:chat_app_with_myysql/util/MyPraf.dart';
import 'package:chat_app_with_myysql/util/navigation.dart';
import 'package:chat_app_with_myysql/view/auth/Login.dart';
import 'package:get/get.dart';

import '../../service/network/ApiService.dart';

class DashboardController extends GetxController{
  User_model? user_model;

 // final ApiService apiService=ApiService();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
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