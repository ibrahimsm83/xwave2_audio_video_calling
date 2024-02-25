
import 'dart:convert';
import 'dart:io';
import 'package:chat_app_with_myysql/model/ChatModel.dart';
import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/model/group_messages_model.dart';
import 'package:chat_app_with_myysql/model/interface.dart';
import 'package:chat_app_with_myysql/service/network.dart';
import 'package:chat_app_with_myysql/util/MyPraf.dart';
import 'package:chat_app_with_myysql/service/network/ApiService.dart';
import 'package:chat_app_with_myysql/service/network/apis.dart';
import 'package:chat_app_with_myysql/util/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../util/config.dart';

class GroupMessageController extends GetxController with SocketMessageHandler {
  RxBool isLoading = false.obs;
  RxBool isMessageLoading = false.obs;
  RxBool isMicTapped = false.obs;
  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();
  ApiService apiService = ApiService();
  RxList<GroupMessages> groupChatList = <GroupMessages>[].obs;

  // ///Sender User
  // final Rx<User_model> _senderUser =
  //     User_model(id: "", phoneNumber: "", avatar: "", username: "",infoAbout: "").obs;
  //
  // set senderUser(User_model senderUser) => _senderUser.value = senderUser;
  //
  // User_model get senderUser => _senderUser.value;
  //
  // ///Receiver User
  // final Rx<User_model> _receiverUser =
  //     User_model(id: "", phoneNumber: "", avatar: "", username: "",infoAbout: "").obs;
  //
  // set receiverUser(User_model receiverUser) =>
  //     _receiverUser.value = receiverUser;
  //
  // User_model get receiverUser => _receiverUser.value;

  @override
  void onInit() {
    print("ChatController init state called..");
    //fetchChat();
  }
///Fetch Group Chat List
  fetchChat(String receiverId) async {
    groupChatList.value = [];
    EasyLoading.show();
    var response = await apiService.getApiWithToken(fetcAllMessagesOfParticularGroupChat + receiverId);
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      var map=jsonDecode(response.body);
      List<dynamic> list = map['groupMessages'];
      if(list.isEmpty)return;
      for(int i=0;i<list.length;i++){
        groupChatList.add(
            GroupMessages.fromJson(list[i]));
      }
      scrolList(scrollController);
    }
  }
  ///Send Messages Api
  Future sendMessageApi(
      String receiverId,
      {bool isImage = false, bool isVoice = false, String? voiceFile, bool isVideo = false, String? videoPath}
      ) async {
    final String token = await getToken_praf();
    const String url = AppConfig.DIRECTORY + "user/sendMessageInGroup";
    print("getApiContacts url: $url");

    if (isImage == true) {
      final imageFile = await ImagePicker().pickImage(
          source: ImageSource.gallery);
      if (imageFile != null) {
        // String fileName = imageFile.path
        //     .split('/')
        //     .last;
        isLoading.value = true;
        await uploadFiles(imageFile.path ?? "", receiverId, "image", url);
        isLoading.value = false;
      }
      return;
    }
    if (isVoice == true) {
      if (voiceFile != null) {
        isLoading.value = true;
        await uploadFiles(voiceFile, receiverId,"audio",url);
        isLoading.value = false;
      }else{
        return;
      }
    }
    if (isVideo == true) {
      isLoading.value = true;
      await uploadFiles(videoPath ?? "", receiverId,"video",url);
      isLoading.value = false;
    }
    if (messageController.text.isEmpty) return;

      final String body = jsonEncode({"content": messageController.text,
        "groupId":receiverId,
        "mediaType":'chat',
      });
    isLoading.value = true;
    await Network().post(url, body,headers: {
      "Authorization": "Bearer ${token}",
      'Content-type': 'application/json'
    }, onSuccess: (val) {
      print("getApiGroupUsers response--1: ${val}");
      var map = jsonDecode(val);
      print("getApiGroupUsers response--2: ${val}");
      //groupChatList.add(GroupMessages.fromJson(map['message']));
    },
        onError: (e){
          print('Failed to load data: ${e}');
        }
    );
    messageController.clear();
    isLoading.value = false;
    scrolList(scrollController);
  }


  ///Upload Files
  Future<dynamic> uploadFiles(String filePath, String? recid,String mediaType,String Url) async {
    print(filePath);
    print(recid);
    print("-----uploadFiles-------------");
    String header = await getToken_praf();
    print(header);
    var headers = {
      'Authorization': 'Bearer $header',
      'Content-Type': 'multipart/form-data',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(Url));
    request.fields.addAll(
        {
          'groupId': recid ?? '65789d8171514a281b248cbd',
          'content': '',
          'mediaType': mediaType,
        });
    request.files.add(await http.MultipartFile.fromPath('media',
      filePath,
    ));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print("---------my chat response-------1----");
      dynamic data = jsonDecode(await response.stream.bytesToString());
      // String responseBody = await utf8.decode(response.bodyBytes);
      print("---------my chat response------2-----");
      print(data['message']);
     // groupChatList.add(GroupMessages.fromJson(data['message']));
      print("---------my chat response------3-----");
      print(data['message']);
      //scrolList(scrollController);
    }
    else {
      print(response.reasonPhrase);
      print(response.statusCode);
      print(await response.stream.bytesToString());
    }
  }
}