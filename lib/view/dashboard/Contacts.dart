import 'dart:convert';
import 'dart:io';
import 'dart:io';

import 'package:chat_app_with_myysql/Models/User_model.dart';
import 'package:chat_app_with_myysql/service/network/ApiService.dart';
import 'package:chat_app_with_myysql/service/network/apis.dart';
import 'package:chat_app_with_myysql/util/helper_functions.dart';
import 'package:chat_app_with_myysql/util/methods.dart';
import 'package:chat_app_with_myysql/app/resources/myColors.dart';
import 'package:chat_app_with_myysql/view/dashboard/one_to_one_chat/OneToOneChat.dart';
import 'package:chat_app_with_myysql/view/dashboard/one_to_one_chat/controller.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:chat_app_with_myysql/widget/my_profile_container.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appback,
      body: SafeArea(
        child: Column(children: [


          header(),
          contactsList(),
        ],),
      ),
    );
  }

  Widget header(){
    return Row(children: [


      Padding(
        padding: const EdgeInsets.all(18.0),
        child: InkWell(
            onTap: () {
              getContants();
            },
            child: Image.asset('images/Group 370.png',width: 44,height: 44,)),
      ),
      Spacer(),
      myText(text: 'Contacts',color: Colors.white,size: 20,),Spacer(),

      Padding(
        padding: const EdgeInsets.all(18.0),
        child: Image.asset('images/Group 470.png',width: 44,height: 44,),
      ),
    ],);
  }

  Widget contactsList(){
    return Container(
      width: Get.width,height: Get.height-104,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.all(18.0),
            child: myText(text: 'My Contact',size: 16,fontWeight: FontWeight.w500,),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                     User_model model=list[index];
                     return Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: ListTile(
                         onTap: () async{
                           startChat(model.id);

                         },
                        leading: my_profile_container(img: model.avatar),
                        title: myText(text: model.username,size: 18,fontWeight: FontWeight.w500,),
                       ),
                     );


                  },),
            ),
          )


      ],),

    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getContants();
  }

  startChat(String id)async{
    EasyLoading.show();
    Map<String,dynamic> body={
      'receiverId':id
    };

    var response=await apiService.postApiWithHeaderAndBody(createChat1To1, body);
    EasyLoading.dismiss();
    print(response.body);
    if(response.statusCode==200){
      var map=jsonDecode(response.body);
      String chatId=map['chat']['_id'];
      List<dynamic> responseUsersList=map['chat']['users'];
      List<User_model> users=responseUsersList.map((e) => User_model.fromJson(e)).toList();
      print("-------contacts---1-");
      ChatController chatController = Get.put(ChatController());
      chatController.senderUser=users[0];
      chatController.receiverUser=users[1];
      chatController.fetchChat(users[1].id);
      print("-------contacts---2-");
      close_current_go_next_page(OneToOneChat(chatID: chatId, sender: users[0], receiver: users[1]));

    }
    else{
      EasyLoading.showError('try again');
    }

  }


  ApiService apiService=ApiService();
  List<User_model> list=[];
  getContants()async{
    EasyLoading.show();
    List<Contact> contacts = await ContactsService.getContacts();

    AppMessage.showMessage("contacts count: ${contacts.length}");

    List<Map<String,dynamic>> nbrs=[];

    contacts.forEach((element) {


      String n=element.phones![0].value!;
      n=n.replaceAll(' ', '');
      print(n);

      Map<String,dynamic> map={
        'phoneNumber':n
      };
      nbrs.add(map);

    });

    Map<String,dynamic> map={
      'contacts': nbrs
    };

    var response=await apiService.postApiWithHeaderAndBody(appInstallUsers,
        jsonEncode(map));
    EasyLoading.dismiss();
    print(response.body);

    if(response.statusCode==200){
      var map=jsonDecode(response.body);
     // Map<String,dynamic> jsonResponse=jsonDecode(response.body);
     List<dynamic> registerusers=map['data']['registeredUsers'];

     list=registerusers.map((e) => User_model.fromJson(e)).toList();

     setState(() {

     });


    }
    else{
      EasyLoading.showError('try again');
    }



  }

}

