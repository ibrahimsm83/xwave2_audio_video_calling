import 'dart:convert';

import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/service/network.dart';
import 'package:chat_app_with_myysql/util/config.dart';
import 'package:chat_app_with_myysql/util/helper_functions.dart';

class AuthRepository {
  Future<String?> loginUser(
    String phone,
  ) async {
    String? user;
    const String url = AppConfig.DIRECTORY + "auth/send-otp";
    print("login url: $url");
    final map = {
      "phoneNumber": phone,
    };
    print("login map: $map");
    await Network().post(
      url,
      map,
     // headers: {'Content-type': 'application/json'},
      onSuccess: (val) {
        print("login response: $val");
        var map = jsonDecode(val);
        bool status = map["status"] == Network.STATUS_SUCCESS;
        if (status) {
          user = map["otp"];
        }
        AppMessage.showMessage(map["message"].toString());
      },
    );
    return user;
  }

  Future<User_model?> verifyUser(
      String phone,String otp
      ) async {
    User_model? user;
    const String url = AppConfig.DIRECTORY + "auth/verify-otp";
    print("verify url: $url");
    final map = {
      "phoneNumber":phone,
      "otp":otp
    };
    print("verify map: $map");
    await Network().post(
      url,
      map,
      // headers: {'Content-type': 'application/json'},
      onSuccess: (val) {
        print("verify response: $val");
        var map = jsonDecode(val);
        bool status = map["status"] == Network.STATUS_SUCCESS;
        if (status) {
            user=User_model.empty(id: map["user_id"], phoneNumber: map["phoneNumber"],
                profile_completed: !map["newUser"],access_token: map["token"],);
        //  user = map["otp"];
        }
        AppMessage.showMessage(map["message"].toString());
      },
    );
    return user;
  }

}
