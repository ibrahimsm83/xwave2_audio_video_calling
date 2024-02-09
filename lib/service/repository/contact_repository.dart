import 'dart:convert';

import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/model/page_model.dart';
import 'package:chat_app_with_myysql/resources/integer.dart';
import 'package:chat_app_with_myysql/service/network.dart';
import 'package:chat_app_with_myysql/util/config.dart';

class ContactRepository {
  Future<PageModel<User_model>?> getAllUsers(
    String token, {
    int page = 1,
    int limit = AppInteger.PAGE_LIMIT,
  }) async {
    PageModel<User_model>? users;
    const String url = AppConfig.DIRECTORY + "user/getAllUsers";
    print("getAllUsers url: $url");

    await Network().get(url, headers: {
      "Authorization": "Bearer ${token}",
      'Content-type': 'application/json'
    }, onSuccess: (val) {
      print("getAllUsers response: ${val}");
      var map = jsonDecode(val);
      var data = map["data"];
      List list = data["results"];
      var meta = data["meta"];
      users = PageModel(
          data: list.map<User_model>((cat) {
            return User_model.fromJson(cat);
          }).toList(),
          total_page: meta["totalPages"]);
    });
    return users;
  }

  Future<PageModel<User_model>?> getApiContacts(
    String token,
    List<Map<String, String>> contacts,
  ) async {
    PageModel<User_model>? users;
    const String url = AppConfig.DIRECTORY + "user/getContactUsers";
    print("getApiContacts url: $url");
    final String body = jsonEncode({"contacts": contacts});
    await Network().post(url,body, headers: {
      "Authorization": "Bearer ${token}",
      'Content-type': 'application/json'
    }, onSuccess: (val) {
      print("getApiContacts response: ${val}");
      var map = jsonDecode(val);
      if (map["status"] == Network.STATUS_SUCCESS) {
        var data = map["data"];
        List list = data["registeredUsers"];
        users = PageModel(
          data: list.map<User_model>((cat) {
            return User_model.fromJson(cat);
          }).toList(),
        );
      }
    });
    return users;
  }
}
