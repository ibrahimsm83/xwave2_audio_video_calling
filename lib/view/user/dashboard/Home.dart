

import 'package:chat_app_with_myysql/controller/user/contact_controller.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/view/story_view/story_view_controller.dart';
import 'package:chat_app_with_myysql/widget/bottom_nav/Calls.dart';
import 'package:chat_app_with_myysql/widget/bottom_nav/Chanels.dart';
import 'package:chat_app_with_myysql/widget/bottom_nav/Group.dart';
import 'package:chat_app_with_myysql/widget/bottom_nav/Messages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final ContactController contactController=Get.find<ContactController>();
  //final StoryController storyController=Get.find<StoryController>();



  @override
  void initState() {
    loadData();
    super.initState();
    // initSocket();
    /*registerEvent('incoming_audio_call', incomingCallListner);
    registerEvent('incoming_video_call', incomingVideoCallListner);*/
  }

  void loadData()async{
    ///call contact from device
    print("Load api called...get usersId .List...");
   await contactController.loadApiContacts();
   //storyController.getStoryApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottom_nav(),
      body: screens[selected],
    );
  }

  List<Widget> screens=[Messages(),Group(),Chanels(),Calls()];

  int selected=0;
  Widget bottom_nav(){
    return BottomNavigationBar(
        onTap: (value) {
          setState(() {
            selected=value;
          });
        },
        currentIndex: selected,
        selectedItemColor: appYellow,
        unselectedItemColor: Color(0xff797C7B),
        items: [
      BottomNavigationBarItem(icon: ImageIcon(AssetImage('images/Group 368 (1).png'),size: 50,),label: ''),
      BottomNavigationBarItem(icon: ImageIcon(AssetImage('images/Group 366.png'),size: 50,),label: ''),
      BottomNavigationBarItem(icon: ImageIcon(AssetImage('images/Group 469.png'),size: 50,),label: ''),
      BottomNavigationBarItem(icon: ImageIcon(AssetImage('images/Group 367.png'),size: 50,),label: ''),
    ]);
  }




  @override
  void dispose() {
    super.dispose();
  }
}
