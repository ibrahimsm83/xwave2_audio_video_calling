import 'dart:convert';
import 'package:chat_app_with_myysql/model/group_chat_users_model.dart';
import 'package:chat_app_with_myysql/service/network.dart';
import 'package:chat_app_with_myysql/util/config.dart';
import 'package:http/http.dart' as http;

class GroupChatRepository {


  Future<List<GroupChatUsersModel>> getApiGroups(
      String token,
      ) async {
    List<GroupChatUsersModel> groupsList=[];
    const String url = AppConfig.DIRECTORY + "user/fetchGroupChat/";
    print("getApiContacts url: $url");
    await Network().get(url, headers: {
      "Authorization": "Bearer ${token}",
      'Content-type': 'application/json'
    }, onSuccess: (val) {
      print("getApiGroupUsers response: ${val}");
      var map = jsonDecode(val);
      for(int i =0;i<map.length;i++){
        groupsList.add(GroupChatUsersModel.fromJson(map[i]));
      }
    },
      onError: (e){
        print('Failed to load data: ${e}');
      }

    );
    return groupsList ??[];
  }

  Future<dynamic> createGroupApi(String groupName, List<String> usersList,String? imagePath, String token) async {
    print(groupName);
    print(usersList);
    print(imagePath);
    print("-----uploadFiles-------------");
    var headers = {
      'Authorization': 'Bearer $token',
      //'Authorization': 'Bearer $header',
      'Content-Type': 'multipart/form-data',
      //'Cookie': 'connect.sid=s%3AUzoS90auAKH3VbpprDYfj-BBRlL2j8D7.dVGHiwnEzlku21Y0u5rWI7ocb1UcdekdSxaQ2w04Lpk'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://xwavetechnologies.com/user/groupchat'));
    request.fields.addAll(
        {
          'name': groupName ,
          'users':json.encode(usersList)// usersList.join(','),
        });
    request.files.add(await http.MultipartFile.fromPath('media',
      imagePath??"",
    ));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print("--------Group created Successfully-------1----");
      dynamic data = jsonDecode(await response.stream.bytesToString());
      // String responseBody = await utf8.decode(response.bodyBytes);
      print("---------Group created Successfully-------2-----$data");
      return GroupChatUsersModel.fromJson(data) ;

    }
    else {
      print(response.reasonPhrase);
      print(response.statusCode);
      print(await response.stream.bytesToString());
    }
  }
}
