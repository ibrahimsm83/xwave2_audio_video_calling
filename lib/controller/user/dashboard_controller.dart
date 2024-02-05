import 'package:chat_app_with_myysql/Models/User_model.dart';
import 'package:chat_app_with_myysql/util/apis/apis.dart';
import 'package:get/get.dart';

import '../../util/apis/ApiService.dart';

class DashboardController extends GetxController{
  User_model? user_model;

  final ApiService apiService=ApiService();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

}