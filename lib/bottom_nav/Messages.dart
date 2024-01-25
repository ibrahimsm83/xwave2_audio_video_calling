import 'dart:io';

import 'package:chat_app_with_myysql/Contacts.dart';
import 'package:chat_app_with_myysql/Models/OnetoOneChatRoomModel.dart';
import 'package:chat_app_with_myysql/Models/User_model.dart';
import 'package:chat_app_with_myysql/one_to_one_chat/OneToOneChat.dart';
import 'package:chat_app_with_myysql/helper/MyPraf.dart';
import 'package:chat_app_with_myysql/helper/apis/ApiService.dart';
import 'package:chat_app_with_myysql/helper/apis/SocketManager.dart';
import 'package:chat_app_with_myysql/helper/apis/apis.dart';
import 'package:chat_app_with_myysql/helper/methods.dart';
import 'package:chat_app_with_myysql/helper/myColors.dart';
import 'package:chat_app_with_myysql/helper/widgets/myText.dart';
import 'package:chat_app_with_myysql/helper/widgets/my_profile_container.dart';
import 'package:chat_app_with_myysql/one_to_one_chat/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  ApiService apiService=ApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBlack,
      floatingActionButton: flottingBtn(),
      body: SafeArea(
        child: Column(children: [

          header(),
          chatRoomContainer(),



        ],),
      ),
    );
  }

  Widget header(){
    return Row(children: [
      
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('images/Group 370.png',width: 36.2,height: 36.2,),
      ),
      Spacer(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('images/Logo (1).png',width: 90,height: 30,),
      ),
      Spacer(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: my_profile_container(img: user_model==null?'https://static-00.iconduck.com/assets.00/profile-circle-icon-2048x2048-cqe5466q.png':user_model!.avatar),
      )
      
    ],);
  }
  
  Widget chatRoomContainer(){
    return Container(
      width: Get.width,height: Get.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
        child: ListView.builder(
            itemCount: chatRoomsModels.length,
            itemBuilder: (context, index) {

              OnetoOneChatRoomModel model=chatRoomsModels[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(

                  onTap: () {

                    ChatController chatController = Get.put(ChatController());
                    chatController.fetchChat(model.user_model.id);
                    chatController.senderUser=user_model!;
                    chatController.receiverUser=model.user_model;
                    next_page(OneToOneChat(chatID: model.chatID, sender: user_model!, receiver: model.user_model));
                  },
                  child: Row(children: [

                    my_profile_container(img: model.user_model.avatar),
                    SizedBox(width:10 ,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      myText(text: model.user_model.username,color: Colors.black,size: 16,fontWeight: FontWeight.w500,),
                      myText(text: model.msg,color: appSilver,size: 10,),

                    ],)

                  ],),
                ),
              );

            },),
      ),
    );
  }
  

  Widget flottingBtn(){
    return FloatingActionButton(onPressed: () async{

      await Permission.contacts.request();
      bool b=await Permission.contacts.isGranted;
      if(b)
      next_page(Contacts());
    },backgroundColor: appYellow,child: Icon(CupertinoIcons.add,color: Colors.white,),);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRooms();
    getUserInfo();
    registerEvent('chatListUpdate', roomsUpdateListner);
  }

  List<OnetoOneChatRoomModel> chatRoomsModels=[];

  fetchRooms()async{

    Response response=await apiService.getApiWithToken(fetch1To1chatRooms);
     print(response.body.toString());
    // // [{_id: 65a65648ffdcd322af8fd0fd,
    // // users: [{_id: 65a2d97b556f1776a25a4d4f, phoneNumber: +9210, avatar: https://i.stack.imgur.com/34AD2.jpg, username: n10}],
    // // latestMessages: [], isGroupChat: false, createdAt: 2024-01-16T10:11:20.266Z, updatedAt: 2024-01-18T10:32:14.131Z, __v: 0,
    // // latestMessage: {_id: 65a66689a5f9aadb8d666f94, content: hlo}}]
    //
    if(response.statusCode!=200)
      return;

    chatRoomsModels.clear();

    List<dynamic> list=response.body;

    list.forEach((element) {
      String chatID='';
      String time='';
      String msg='';

      chatID=element['_id'];
      time=element['updatedAt'];
      if(element['latestMessage'] != null&&element['latestMessage']['content']!=null)
      msg=element['latestMessage']['content'];

      List<dynamic> users=element['users'];
      User_model user_model=User_model.fromJson(users[0]);


      OnetoOneChatRoomModel model=OnetoOneChatRoomModel(chatID: chatID, time: time, msg: msg, user_model: user_model);
      chatRoomsModels.add(model);


    });
    setState(() {

    });

  }

  User_model? user_model;
  getUserInfo()async{

    Response response=await apiService.getApiWithToken(userInfo);
    print('info '+response.body.toString());

    // {status: success, userData: {user_id: 65a65609ffdcd322af8fd0f1, phoneNumber: +92100, avatar: https://i.stack.imgur.com/34AD2.jpg, infoAbout: sdsdsd, username: n100}}

    if(response.body['userData']==null)
      return;
    String id=response.body['userData']['user_id'];
    String name=response.body['userData']['username'];
    String phone=response.body['userData']['phoneNumber'];
    String avatar=response.body['userData']['avatar'];

    user_model=User_model(id: id, phoneNumber: phone, avatar: avatar, username: name);
    setState(() {

    });

  }



  roomsUpdateListner(dynamic newMessage) async{


      print('msg socket - '+newMessage.toString());
      chatRoomsModels.clear();

      List<dynamic> list=newMessage;

      list.forEach((element) {
        String chatID='';
        String time='';
        String msg='';

        chatID=element['_id'];
        time=element['updatedAt'];
        if(element['latestMessage'] != null &&element['latestMessage']['content']!=null)
          msg=element['latestMessage']['content'];

        List<dynamic> users=element['users'];
        User_model user_model=User_model.fromJson(users[0]);

        OnetoOneChatRoomModel model=OnetoOneChatRoomModel(chatID: chatID, time: time, msg: msg, user_model: user_model);
        chatRoomsModels.add(model);


      });
      setState(() {

      });


  }

  @override
  void dispose() {

    unregisterEvent('chatListUpdate');
    super.dispose();
  }

}
