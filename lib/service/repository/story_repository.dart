import 'dart:convert';
import 'package:chat_app_with_myysql/model/group_chat_users_model.dart';
import 'package:chat_app_with_myysql/service/network.dart';
import 'package:chat_app_with_myysql/util/config.dart';
import 'package:chat_app_with_myysql/view/story_view/model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class StoryViewRepository {


  Future<List<StoryViewModel>> getApiOwnStory(
      String token,
      ) async {
     List<StoryViewModel>? statusList=[];
    const String url = AppConfig.DIRECTORY + "user/getOwnStatus";
    print("getApiget own Status url: $url");
    await Network().get(url, headers: {
      "Authorization": "Bearer ${token}",
      'Content-type': 'application/json'
    }, onSuccess: (val) {
      print("getApiGroupUsers response: ${val}");
      var map = jsonDecode(val);
      for(int i =0;i<map.length;i++){
        statusList.add(StoryViewModel.fromJson(map[i]));
      }
    },
        onError: (e){
          print('Failed to load data: ${e}');
        }

    );
    return statusList;
  }

  Future<List<StoryViewModel>> getUsersStoryAPI(
      String token,
      ) async {
     List<StoryViewModel>? statusList=[];
    const String url = AppConfig.DIRECTORY + "user/getAllStatus";
    print("getApiget own Status url: $url");
    await Network().get(url, headers: {
      "Authorization": "Bearer ${token}",
      'Content-type': 'application/json'
    }, onSuccess: (val) {
      print("getApiGroupUsers response: ${val}");
      var map = jsonDecode(val);
      for(int i =0;i<map.length;i++){
        statusList.add(StoryViewModel.fromJson(map[i]));
      }
    },
        onError: (e){
          print('Failed to load data: ${e}');
        }

    );
    return statusList;
  }

  Future<dynamic> createStoryApi(String? text, String imagePath, String token,String mediaType) async {

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://xwavetechnologies.com/user/uploadStatus'));
    request.fields.addAll(
        {
          'text': text??"" ,
          'mediaType':mediaType,// usersList.join(','),
        });
    request.files.add(await http.MultipartFile.fromPath('media',
      imagePath,
    ));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 201) {
      print("--------Story created Successfully-------1----");
      dynamic data = jsonDecode(await response.stream.bytesToString());
      // String responseBody = await utf8.decode(response.bodyBytes);
      print("---------Story created Successfully-------2-----$data");
     // return  "Story Successfully Added" //GroupChatUsersModel.fromJson(data) ;

    }
    else {
      print(response.reasonPhrase);
      print(response.statusCode);
      print(await response.stream.bytesToString());
    }
  }
}
