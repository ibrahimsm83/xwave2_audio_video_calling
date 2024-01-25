import 'package:chat_app_with_myysql/Group/CreateGroup.dart';
import 'package:chat_app_with_myysql/helper/apis/ApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Contacts/Contacts.dart';
import '../Models/User_model.dart';
import '../helper/apis/apis.dart';
import '../helper/methods.dart';
import '../helper/myColors.dart';
import '../helper/widgets/my_profile_container.dart';

class Group extends StatefulWidget {
  const Group({super.key});

  @override
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBlack,
      floatingActionButton: flottingBtn(),
      body: SafeArea(child: Column(children: [

      ],)),
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

  Widget flottingBtn(){
    return FloatingActionButton(onPressed: () async{

      await Permission.contacts.request();
      bool b=await Permission.contacts.isGranted;
      if(b)
        next_page(CreateGroup());
    },backgroundColor: appYellow,child: Icon(CupertinoIcons.add,color: Colors.white,),);
  }

  ApiService apiService=ApiService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();

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




}
