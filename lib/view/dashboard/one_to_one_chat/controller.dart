
import 'dart:convert';
import 'dart:io';
import 'package:chat_app_with_myysql/Models/ChatModel.dart';
import 'package:chat_app_with_myysql/Models/User_model.dart';
import 'package:chat_app_with_myysql/util/MyPraf.dart';
import 'package:chat_app_with_myysql/service/network/ApiService.dart';
import 'package:chat_app_with_myysql/service/network/apis.dart';
import 'package:chat_app_with_myysql/util/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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
      User_model(id: "", phoneNumber: "", avatar: "", username: "",infoAbout: "").obs;

  set senderUser(User_model senderUser) => _senderUser.value = senderUser;

  User_model get senderUser => _senderUser.value;

  ///Receiver User
  final Rx<User_model> _receiverUser =
      User_model(id: "", phoneNumber: "", avatar: "", username: "",infoAbout: "").obs;

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
    var response = await apiService.getApiWithToken(fetch1To1chat + receiverId);
    print(response.body);
    EasyLoading.dismiss();
    //isLoading.value = false;

    if (response.statusCode == 200) {
      var map=jsonDecode(response.body);
      List<dynamic> list = map;

      list.forEach((element) {
        String contant = '';
        String mediaType = '';
        String url = '';
        String lati = '',
            longi = '';
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

  sendTextMSg(String receiverId, User_model senderM, User_model receiverM,
      {bool isImage = false, bool isVoice = false, String? voiceFile, bool isVideo = false, String? videoPath}) async {
    if (isImage == true) {
      final imageFile = await ImagePicker().pickImage(
          source: ImageSource.gallery);
      if (imageFile != null) {
        // isLoading.value = true;
        String fileName = imageFile.path
            .split('/')
            .last;
        Map<String, String> map = {
          'receiver': receiverId, //:widget.receiver.id,
          'content': messageController.text,
          'mediaType': 'image',
         // 'media': MultipartFile(File(imageFile.path), filename: fileName),
        };
        print("---map--------$map");
        print("---imageFile.path--------${imageFile.path}");
        print("---fileName--------$fileName");
        print("---File(imageFile.path)--------${File(imageFile.path)}");
        /*
         ---map--------{receiver: 65b2c5a00fe1b62f19a71e35, content: , media: Instance of 'MultipartFile'}
I/flutter (17085): ---imageFile.path--------/data/user/0/com.example.chat_app_with_myysql/cache/fd6d2b96-0f78-4e82-95ba-f0700c61b978/Screenshot_20231114-004115.png
I/flutter (17085): ---fileName--------Screenshot_20231114-004115.png
I/flutter (17085): ---File(imageFile.path)--------File: '/data/user/0/com.example.chat_app_with_myysql/cache/fd6d2b96-0f78-4e82-95ba-f0700c61b978/Screenshot_20231114-004115.png'
I/flutter (17085): --ApiServices Response-headers-postApiWithFromDataAndHeaderAndContantType --null
I/flutter (17085): --ApiServices Response body- --null
E/flutter (17085): [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: TimeoutException after 0:00:05.000000: Future not completed
         */
        isLoading.value = true;
        var response = await apiService
            .postApiWithFromDataAndHeaderAndContantType(send1To1Msg, map,
            files: [
              await http.MultipartFile.fromPath("media", imageFile.path,filename: fileName),
            ]);
        isLoading.value = false;
        print("-------response-------");
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
        String lati = '',
            longi = '';
        String time = '';
        Stream stream = response.stream.transform(const Utf8Decoder());
        String body = await stream.first;
        var map1=jsonDecode(body);
        time = map1['message']['chat']['updatedAt'];
        if (map1['message']['location'] != null) {
          if (map1['message']['location']['latitude'] != null) {
            lati = map1['message']['location']['latitude'].toString();
            longi =
                map1['message']['location']['longitude'].toString();
          }
        }
        if (map1['message']['content'] != null) {
          contant = map1['message']['content'];
        }
        mediaType = map1['message']['media']['type'];
        print("----Media type-----${mediaType}");
        if (map1['message']['media']['url'] != null) {
          url = map1['message']['media']['url'];
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

    if (isVoice == true) {
      print("----Media type--is---${isVoice}");
      print("----FilePath---${voiceFile}");
      // isLoading.value = true;
      if (voiceFile != null) {
        //  await uploadFiles(voiceFile,receiverId);
        // // await uploadFiles('storage/emulated/0/Download/big_buck_bunny_720p_1mb.mp4',receiverId);
        // //await uploadFiles('/storage/emulated/0/Download/file_example_MP3_2MG.mp3',receiverId);
        // // //storage/emulated/0/Download/big_buck_bunny_720p_1mb.mp4
        //  return;
        String fileName = voiceFile
            .split('/')
            .last;
        Map<String, String> map = {
          'receiver': receiverId,
          //:widget.receiver.id,
          'content': '',
          'mediaType': 'audio',
          //'media': MultipartFile(File('/storage/emulated/0/Download/file_example_MP3_2MG.mp3'),filename: 'sampleFile',contentType: 'multipart/form-data'),
          // 'media': MultipartFile(File('/storage/emulated/0/Download/file_example_WAV_2MG.wav'),filename: fileName),
         // 'media': MultipartFile(File(voiceFile), filename: fileName),
        };
        print("---map--------${map}");
        print("---imageFile.path--------${voiceFile}");
        print("---fileName--------$fileName");
        print("---File(imageFile.path)--------${File(voiceFile)}");
        print("---File(imageFile.path)--------${MultipartFile(
            File(voiceFile), filename: fileName)}");

        isLoading.value = true;
        var response = await apiService
            .postApiWithFromDataAndHeaderAndContantType(send1To1Msg, map,files: [
          await http.MultipartFile.fromPath("media", voiceFile,filename: fileName),
        ]);
        isLoading.value = false;
        print("-------dddd-------");
        if (response.statusCode != 200) return;

        // messageController.clear();
        // {message: {_id: 65a8f0d47167cd6905ca637a, content: ty,
        // media: {type: none}, location: {},
        // sender: {_id: 65a2d97b556f1776a25a4d4f, username: n10, avatar: https://i.stack.imgur.com/34AD2.jpg},
        //  chat: {_id: 65a65648ffdcd322af8fd0fd, users: [{_id: 65a2d97b556f1776a25a4d4f, phoneNumber: +9210, username: n10}, {_id: 65a65609ffdcd322af8fd0f1, phoneNumber: +92100, username: n100}],
        //  isGroupChat: false, createdAt: 1/18/2024, 2:35:16 PM, updatedAt: 1/18/2024, 2:35:16 PM}}}

        String contant = '';
        String mediaType = '';
        String url = '';
        String lati = '',
            longi = '';
        String time = '';
        Stream stream = response.stream.transform(const Utf8Decoder());
        String body = await stream.first;
        var map1=jsonDecode(body);
        time = map1['message']['chat']['updatedAt'];
        if (map1['message']['location'] != null) {
          if (map1['message']['location']['latitude'] != null) {
            lati = map1['message']['location']['latitude'].toString();
            longi =
                map1['message']['location']['longitude'].toString();
          }
        }
        if (map1['message']['content'] != null) {
          contant = map1['message']['content'];
        }
        mediaType = map1['message']['media']['type'];
        print("----Media type-----${mediaType}");

        if (map1['message']['media']['url'] != null) {
          url = map1['message']['media']['url'];
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
        print("-------------");
        print(chatList);
        scrolList(scrollController);
      }
    }

    if (isVideo == true) {
      isLoading.value = true;
      await uploadFiles(videoPath ?? "", receiverId);
      isLoading.value = false;
      print("----isVideo--is---${isVideo}");
      print("----videoPath---${videoPath}");
      // isLoading.value = true;
      /*
      if(videoPath !=null){
        //  return;
        String fileName = videoPath.split('/').last;
        Map<String, dynamic> map = {
          'receiver': receiverId, //:widget.receiver.id,
          'content': '',
          'mediaType':'video',
          'media': MultipartFile(File(videoPath),filename: fileName),
        };
        print("---map--------${map}");
        print("---videoPath.path--------${videoPath}");
        print("---fileName--------$fileName");
        print("---File(videoPath.path)--------${File(videoPath)}");
        print("---File(videoPath.path)--------${MultipartFile(File(videoPath),filename: fileName)}");

        isLoading.value = true;
        Response response = await apiService
            .postApiWithFromDataAndHeaderAndContantType(send1To1Msg, map);
        isLoading.value = false;
        print("-------dddd-------");
        print(response.body);
        if (response.statusCode != 200) return;

        // messageController.clear();
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
        print("-------------");
        print(chatList);
        scrolList(scrollController);
      }
     */
    }


    if (messageController.text.isEmpty) return;
    Map<String, String> map = {
      'receiver': receiverId, //:widget.receiver.id,
      'content': messageController.text,
    };
    isLoading.value = true;
    var response = await apiService
        .postApiWithFromDataAndHeaderAndContantType(send1To1Msg, map);
    isLoading.value = false;

    if (response.statusCode != 200) return;

    messageController.clear();
    // {message: {_id: 65a8f0d47167cd6905ca637a, content: ty,
    // media: {type: none}, location: {},
    // sender: {_id: 65a2d97b556f1776a25a4d4f, username: n10, avatar: https://i.stack.imgur.com/34AD2.jpg},
    // chat: {_id: 65a65648ffdcd322af8fd0fd, users: [{_id: 65a2d97b556f1776a25a4d4f, phoneNumber: +9210, username: n10}, {_id: 65a65609ffdcd322af8fd0f1, phoneNumber: +92100, username: n100}],
    // isGroupChat: false, createdAt: 1/18/2024, 2:35:16 PM, updatedAt: 1/18/2024, 2:35:16 PM}}}
    String contant = '';
    String mediaType = '';
    String url = '';
    String lati = '',
        longi = '';
    String time = '';
    Stream stream = response.stream.transform(const Utf8Decoder());
    String body = await stream.first;
    var map1=jsonDecode(body);
    time = map1['message']['chat']['updatedAt'];
    if (map1['message']['location'] != null) {
      if (map1['message']['location']['latitude'] != null) {
        lati = map1['message']['location']['latitude'].toString();
        longi = map1['message']['location']['longitude'].toString();
      }
    }
    if (map1['message']['content'] != null) {
      contant = map1['message']['content'];
    }
    mediaType = map1['message']['media']['type'];
    if (map1['message']['media']['url'] != null) {
      url = map1['message']['media']['url'];
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
    String lati = '',
        longi = '';
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
        User_model(id: senderId, phoneNumber: '', avatar: '', username: '',infoAbout: ""),
        receiver: User_model(
            id: receiverId, phoneNumber: '', avatar: '', username: '',infoAbout: "")));

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

  Future<dynamic> uploadFiles(String filePath, String? recid) async {
    print(filePath);
    print(recid);
    print("-----uploadFiles-------------");
    String header = await getToken_praf();
    print(header);
    var headers = {
      'Authorization': 'Bearer $header',
      'Content-Type': 'multipart/form-data',
      //'Cookie': 'connect.sid=s%3AUzoS90auAKH3VbpprDYfj-BBRlL2j8D7.dVGHiwnEzlku21Y0u5rWI7ocb1UcdekdSxaQ2w04Lpk'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://xwavetechnologies.com/user/sendmesseges'));
    request.fields.addAll(
        {
          'receiver': recid ?? '65789d8171514a281b248cbd',
          'content': '',
          'mediaType': 'video',
        });
    request.files.add(await http.MultipartFile.fromPath('media',
      //'/Users/apple/Downloads/ast01.dev.itpvoice.net-1704835631.25357.mp3'
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
      print(data['message']['media']['type']);
       print(data['message']['media']['url']);

          //print(apiRes);


      //
      String contant = '';
      String mediaType = '';
      String url = '';
      String lati = '', longi = '';
      String time = '';
      time = data['message']['chat']['updatedAt'];
      if (data['message']['location'] != null) {
        if (data['message']['location']['latitude'] != null) {
          lati = data['message']['location']['latitude'].toString();
          longi = data['message']['location']['longitude'].toString();
        }
      }
      if (data['message']['content'] != null) {
        contant = data['message']['content'];
      }
      mediaType = data['message']['media']['type'];
      print("----Media type-----${mediaType}");
      print(data['message']['media']['type']);

      if (data['message']['media']['url'] != null) {
        url = data['message']['media']['url'];
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
      print("-------------");
      print(chatList);
      scrolList(scrollController);
    }
    else {
      print(response.reasonPhrase);
      print(response.statusCode);
      print(await response.stream.bytesToString());
    }
  }
}