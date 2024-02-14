import 'dart:convert';
import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/service/network.dart';
import 'package:chat_app_with_myysql/util/config.dart';
import 'package:chat_app_with_myysql/util/helper_functions.dart';
import 'package:http/http.dart' as http;

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
            user=User_model.fromJson2(map,access_token: map["token"]);
        }
        AppMessage.showMessage(map["message"].toString());
      },
    );
    return user;
  }

  Future<User_model?> updateProfile(String phone, String name,String info,
      {String? image,}) async {
    User_model? stak;
    const String url = AppConfig.DIRECTORY + "auth/infoabout";
    print("updateProfile url: ${url}");
    final List<http.MultipartFile> files=[];

    final Map<String,String> body={'username':name,
      'infoAbout':info,
      'phoneNumber':phone,};
    print("updateProfile body: ${body}");

    if (image != null) {
      files.add(await http.MultipartFile.fromPath("avatar", image));
    }
    await Network().multipartPost(url, body,
        //headers: {"Authorization": "Bearer ${token}",},
        files: files,onSuccess: (val){
          print("updateProfile response: ${val}");
          var map=jsonDecode(val);
          if(map["status"]==Network.STATUS_SUCCESS){
            var us=map["userData"];
            stak=User_model.fromJson2(us,access_token: map["token"]);
          }
          AppMessage.showMessage(map["message"]);
        });
    return stak;
  }

}
