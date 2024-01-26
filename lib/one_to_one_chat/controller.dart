
import 'dart:io';
import 'package:chat_app_with_myysql/Models/ChatModel.dart';
import 'package:chat_app_with_myysql/Models/User_model.dart';
import 'package:chat_app_with_myysql/helper/apis/ApiService.dart';
import 'package:chat_app_with_myysql/helper/apis/apis.dart';
import 'package:chat_app_with_myysql/helper/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isMessageLoading = false.obs;
  RxBool isMicTapped = false.obs;
  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();
  ApiService apiService = ApiService();
  RxList<ChatModel> chatList = <ChatModel>[].obs;

  ///Sender User
  final Rx<User_model> _senderUser =
      User_model(id: "", phoneNumber: "", avatar: "", username: "").obs;

  set senderUser(User_model senderUser) => _senderUser.value = senderUser;

  User_model get senderUser => _senderUser.value;

  ///Receiver User
  final Rx<User_model> _receiverUser =
      User_model(id: "", phoneNumber: "", avatar: "", username: "").obs;

  set receiverUser(User_model receiverUser) =>
      _receiverUser.value = receiverUser;

  User_model get receiverUser => _receiverUser.value;

  @override
  void onInit() {
    print("ChatController init state called..");
    //fetchChat();
  }

  fetchChat(String receiverId) async {
    print('-----set users----');
    chatList.value = [];
    //isLoading.value = true;
    EasyLoading.show();
    Response response =
        await apiService.getApiWithToken(fetch1To1chat + receiverId);
    print(response.body);
    EasyLoading.dismiss();
    //isLoading.value = false;

    if (response.statusCode == 200) {
      List<dynamic> list = response.body;

      list.forEach((element) {
        String contant = '';
        String mediaType = '';
        String url = '';
        String lati = '', longi = '';
        String time = '';

        User_model sender = User_model.fromJson(element['sender']);
        User_model receiver = User_model.fromJson(element['receiver']);

        time = element['createdAt'];

        if (element['location'] != null) {
          lati = element['location']['latitude'].toString();
          longi = element['location']['longitude'].toString();
        }

        if (element['content'] != null) {
          contant = element['content'];
        }
        mediaType = element['media']['type'];
        if (element['media']['url'] != null) {
          url = element['media']['url'];
        }
        chatList.add(ChatModel(
            content: contant,
            mediaType: mediaType,
            url: url,
            lati: lati,
            longi: longi,
            time: time,
            sender: sender,
            receiver: receiver));
      });

      scrolList(scrollController);
    }
  }

  sendTextMSg(
      String receiverId, User_model senderM, User_model receiverM,{bool isImage = false}) async {
    print("-------receiver id--${receiverId}");
    if(isImage==true){
      final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(imageFile !=null){
        // isLoading.value = true;
        String fileName = imageFile.path.split('/').last;


       // print(imageFile.path);
        Map<String, dynamic> map = {
          'receiver': receiverId, //:widget.receiver.id,
          'content': messageController.text,
          'media': MultipartFile(File(imageFile.path),filename: fileName),
          // 'media':MultipartFile(file.path, filename: basename(file.path)),
          // 'latitude':'0',
          // 'longitude':'0',
        };
        isLoading.value = true;
        Response response = await apiService
            .postApiWithFromDataAndHeaderAndContantType(send1To1Msg, map);
        isLoading.value = false;
        print("-------dddd-------");
        print(response.body);
        if (response.statusCode != 200) return;

        messageController.clear();
        // {message: {_id: 65a8f0d47167cd6905ca637a, content: ty,
        // media: {type: none}, location: {},
        // sender: {_id: 65a2d97b556f1776a25a4d4f, username: n10, avatar: https://i.stack.imgur.com/34AD2.jpg},
        //  chat: {_id: 65a65648ffdcd322af8fd0fd, users: [{_id: 65a2d97b556f1776a25a4d4f, phoneNumber: +9210, username: n10}, {_id: 65a65609ffdcd322af8fd0f1, phoneNumber: +92100, username: n100}],
        //  isGroupChat: false, createdAt: 1/18/2024, 2:35:16 PM, updatedAt: 1/18/2024, 2:35:16 PM}}}

        String contant = '';
        String mediaType = '';
        String url = '';
        String lati = '', longi = '';
        String time = '';
        time = response.body['message']['chat']['updatedAt'];
        if (response.body['message']['location'] != null) {
          if (response.body['message']['location']['latitude'] != null) {
            lati = response.body['message']['location']['latitude'].toString();
            longi = response.body['message']['location']['longitude'].toString();
          }
        }
        if (response.body['message']['content'] != null) {
          contant = response.body['message']['content'];
        }
        mediaType = response.body['message']['media']['type'];
        print("----Media type-----${mediaType}");
        if (response.body['message']['media']['url'] != null) {
          url = response.body['message']['media']['url'];
        }
        chatList.add(ChatModel(
            content: contant,
            mediaType: mediaType,
            url: url,
            lati: lati,
            longi: longi,
            time: time,
            sender: senderUser,
            receiver: receiverUser));
        scrolList(scrollController);

      }
    }


    if (messageController.text.isEmpty) return;

    // XFile? xFile=await ImagePicker().pickImage(source: ImageSource.gallery);
    // if(xFile==null)
    //   return;
    //
    //
    // File file=File(xFile.path);
    // print(basename(file.path));
    // EasyLoading.show();
    Map<String, dynamic> map = {
      'receiver': receiverId, //:widget.receiver.id,
      'content': messageController.text,
      // 'media':MultipartFile(file.path, filename: basename(file.path)),
      // 'latitude':'0',
      // 'longitude':'0',
    };
    isLoading.value = true;
    Response response = await apiService
        .postApiWithFromDataAndHeaderAndContantType(send1To1Msg, map);
    isLoading.value = false;
    // EasyLoading.dismiss();
    print(response.body);

    if (response.statusCode != 200) return;

    messageController.clear();
    // {message: {_id: 65a8f0d47167cd6905ca637a, content: ty,
    // media: {type: none}, location: {},
    // sender: {_id: 65a2d97b556f1776a25a4d4f, username: n10, avatar: https://i.stack.imgur.com/34AD2.jpg},
    //  chat: {_id: 65a65648ffdcd322af8fd0fd, users: [{_id: 65a2d97b556f1776a25a4d4f, phoneNumber: +9210, username: n10}, {_id: 65a65609ffdcd322af8fd0f1, phoneNumber: +92100, username: n100}],
    //  isGroupChat: false, createdAt: 1/18/2024, 2:35:16 PM, updatedAt: 1/18/2024, 2:35:16 PM}}}

    String contant = '';
    String mediaType = '';
    String url = '';
    String lati = '', longi = '';
    String time = '';
    time = response.body['message']['chat']['updatedAt'];
    if (response.body['message']['location'] != null) {
      if (response.body['message']['location']['latitude'] != null) {
        lati = response.body['message']['location']['latitude'].toString();
        longi = response.body['message']['location']['longitude'].toString();
      }
    }
    if (response.body['message']['content'] != null) {
      contant = response.body['message']['content'];
    }
    mediaType = response.body['message']['media']['type'];
    if (response.body['message']['media']['url'] != null) {
      url = response.body['message']['media']['url'];
    }
    chatList.add(ChatModel(
        content: contant,
        mediaType: mediaType,
        url: url,
        lati: lati,
        longi: longi,
        time: time,
        sender: senderUser,
        receiver: receiverUser));
    scrolList(scrollController);
  }

  msgListner(dynamic newMessage) async {
    print('msg - ' + newMessage.toString());

    String contant = '';
    String mediaType = '';
    String url = '';
    String lati = '', longi = '';
    String time = '';
    String senderId = '';
    String receiverId = '';

    time = newMessage['createdAt'];

    if (newMessage['receiver'] != null) {
      receiverId = newMessage['receiver'];
    }
    if (newMessage['sender'] != null) {
      senderId = newMessage['sender'];
    }

    if (newMessage['location'] != null) {
      if (newMessage['location']['latitude'] != null) {
        lati = newMessage['location']['latitude'].toString();
        longi = newMessage['location']['longitude'].toString();
      }
    }

    if (newMessage['content'] != null) {
      contant = newMessage['content'];
    }
    mediaType = newMessage['media']['type'];
    if (newMessage['media']['url'] != null) {
      url = newMessage['media']['url'];
    }
    print("listener is running -----");
    // chatList.add(ChatModel(content: contant, mediaType: mediaType, url: url, lati: lati, longi: longi, time: time, sender:senderUser , receiver: receiverUser));
    chatList.add(ChatModel(
        content: contant,
        mediaType: mediaType,
        url: url,
        lati: lati,
        longi: longi,
        time: time,
        sender:
            User_model(id: senderId, phoneNumber: '', avatar: '', username: ''),
        receiver: User_model(
            id: receiverId, phoneNumber: '', avatar: '', username: '')));

    print("lisntneeeeeeee");
    print(senderUser.id);
    print(receiverUser.id);

    // setState(() {
    //
    // });

    scrolList(scrollController);
  }

//   sendMessage({bool isImage = false}) async {
//     if (isImage == true) {
//       final image = await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         isMessageLoading.value = true;
//         // List numbers = [];
//         // messages!.result!.participants!.where((element) => element.number != myNumber).toList().forEach((element) {
//         //   numbers.add(element.number);
//         // });
//         // String numberString = "{\"list\": [\"${numbers.join(',')}\"]}";
//         Response response=await apiService.postApiWithFromDataAndHeaderAndContantType(send1To1Msg, map);
//         await repo.sendMessage(myNumber, "", numberString, image.path).then((message) {
//           if (message != null) {
//             message.isDelivered = false;
//             _messages.value!.result!.messages!.insert(0, message);
//             isLoading.value = true;
//             isLoading.value = false;
//           } else {
//            // CustomToast.showToast("Please check your internet connvection", true);
//           }
//         });
//         messageController.clear();
//         isMessageLoading.value = false;
//       }
//     } else {
//       if (isLoading.value != true && messageController.text.isNotEmpty && isMessageLoading.value != true) {
//         isMessageLoading.value = true;
//         List numbers = [];
//         messages!.result!.participants!.where((element) => element.number != myNumber).toList().forEach((element) {
//           numbers.add(element.number);
//         });
//         String numberString = "{\"list\": [\"${numbers.join(',')}\"]}";
//         await repo.sendMessage(myNumber, messageController.text, numberString).then((message) {
//           if (message != null) {
//             message.isDelivered = false;
//             _messages.value!.result!.messages!.insert(0, message);
//             isLoading.value = true;
//             isLoading.value = false;
//           } else {
//             CustomToast.showToast("Please check your internet connvection", true);
//           }
//         });
//         messageController.clear();
//         isMessageLoading.value = false;
//       }
//     }
// }
}
