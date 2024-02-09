import 'package:chat_app_with_myysql/controller/user/controller.dart';
import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/service/network/SocketManager.dart';
import 'package:chat_app_with_myysql/service/repository/auth_repository.dart';
import 'package:chat_app_with_myysql/util/MyPraf.dart';
import 'package:chat_app_with_myysql/util/helper_functions.dart';
import 'package:chat_app_with_myysql/util/navigation.dart';
import 'package:chat_app_with_myysql/view/auth/Verification.dart';
import 'package:chat_app_with_myysql/view/user/dashboard/Home.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{

  final authProvider=AuthRepository();

  Future<void> login(String? phone) async{
    if(phone!=null) {
      AppLoader.showLoader();
      String? otp = await authProvider.loginUser(phone);
      AppLoader.dismissLoader();
      if (otp != null) {
        AppNavigator.navigateTo(Verification(nbr: phone, otp: otp));
      }
    }
  }

  Future<String?> resendCode(String phone) async{
    AppLoader.showLoader();
    String? otp=await authProvider.loginUser(phone);
    AppLoader.dismissLoader();
    return otp;
  }

  Future<void> verifyUser(String phone,String otp) async{
    AppLoader.showLoader();
    User_model? user=await authProvider.verifyUser(phone,otp);
    AppLoader.dismissLoader();
    if(user!=null){
      if(user.profile_completed==true){
        _goToDashboard(user);
      }
      else{
        _goToDashboard(user);
/*        AppNavigator.navigateToReplaceAll(() {
          Get.put(DashboardController());
          return Info(nbr: nbr,);
        });*/
      }
    }
  }

  void _goToDashboard(User_model user) async{
    await saveDataToPraf(user.id, user.access_token!);
    await initSocket();
    //await checkConected();
    // close_all_go_next_page(Home());
    AppNavigator.navigateToReplaceAll(() {
      Get.put(DashboardController());
      Get.put(ContactController());
      Get.put(CallController());
      return Home();
    });

  }

}