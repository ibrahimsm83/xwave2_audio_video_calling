import 'package:chat_app_with_myysql/controller/splash_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings{

  @override
  void dependencies() {
    Get.put(SplashController());
  }
}