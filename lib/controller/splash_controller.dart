import 'package:chat_app_with_myysql/controller/auth_controller.dart';
import 'package:chat_app_with_myysql/controller/user/controller.dart';
import 'package:chat_app_with_myysql/resources/integer.dart';
import 'package:chat_app_with_myysql/util/MyPraf.dart';
import 'package:chat_app_with_myysql/util/navigation.dart';
import 'package:chat_app_with_myysql/view/login/login_screen.dart';
import 'package:chat_app_with_myysql/view/story_view/story_view_controller.dart';
import 'package:chat_app_with_myysql/view/user/dashboard/Home.dart';
import 'package:get/get.dart';

class SplashController extends GetxController{

  void proceed() async{
    await Future.delayed(const Duration(seconds: AppInteger.SPLASH_DURATION_SEC));
    bool? b=await getLogin_praf();
    if(b==true){
      final String token = await getToken_praf();
      print("token is: $token");
      _goToDashboard();
    }
    else{
      _goToLogin();
    }

/*    StakeHolder? user=database.getUserToken();
    if(user!=null){
      print("access token: ${user.accesstoken}");
      Map? map=await cd.getInitialMessage();
      _goToDashboard(user,initialMap: map);
    }
    else {
      _goToLogin();
    }*/
  }

  void _goToLogin(){
    Get.delete<SplashController>();
    AppNavigator.navigateToReplace((){
      Get.put(AuthController());
      return Login();
    });
  }

  void _goToDashboard({Map? initialMap}) async{
    //await initSocket();
    //await checkConected();
    Get.delete<SplashController>();
    AppNavigator.navigateToReplaceAll((){
      Get.put(DashboardController());
      Get.put(ContactController());
      Get.put(StoryController());
      Get.put(CallController());
      return Home();
    });

  /*  AppNavigator.navigateToReplace((){
      Get.put(DashboardController(user as User,initialMap: initialMap));
      Get.put(TrackingController());
      return DashboardScreen();
    });*/
  }

}