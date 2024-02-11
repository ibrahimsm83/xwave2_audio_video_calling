

import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/service/network/SocketManager.dart';
import 'package:chat_app_with_myysql/util/methods.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/view/user/dashboard/OnetoOneCall/ReceivingAudioCall.dart';
import 'package:chat_app_with_myysql/view/user/dashboard/OnetoOneCall/VideoCallForReceiver.dart';
import 'package:chat_app_with_myysql/widget/bottom_nav/Calls.dart';
import 'package:chat_app_with_myysql/widget/bottom_nav/Chanels.dart';
import 'package:chat_app_with_myysql/widget/bottom_nav/Group.dart';
import 'package:chat_app_with_myysql/widget/bottom_nav/Messages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
  void initState() {
    // TODO: implement initState
    super.initState();
    // initSocket();

    /*registerEvent('incoming_audio_call', incomingCallListner);
    registerEvent('incoming_video_call', incomingVideoCallListner);*/
  }

  incomingCallListner(dynamic newMessage)async{

    print(newMessage);

        String chanelName=newMessage['channelName'];
        String callerID=newMessage['from']['_id'];
        String callerPhone=newMessage['from']['phoneNumber'];
        String callerAvatar=newMessage['from']['avatar'];
        String callerName=newMessage['from']['username'];

        User_model callerModel=User_model(id: callerID, phoneNumber: callerPhone,
            avatar: callerAvatar, username: callerName,infoAbout: "");

        next_page(ReceivingAudioCall(caller: callerModel, chanaelID: chanelName));


  }

  incomingVideoCallListner(dynamic newMessage)async{

    print(newMessage);

        String chanelName=newMessage['channelName'];
        String callerID=newMessage['from']['_id'];
        String callerPhone=newMessage['from']['phoneNumber'];
        String callerAvatar=newMessage['from']['avatar'];
        String callerName=newMessage['from']['username'];

        User_model callerModel=User_model(id: callerID, phoneNumber: callerPhone,
            avatar: callerAvatar, username: callerName,infoAbout: "");

        next_page(VideoCallForReceiver(  user_model: callerModel, chanelName: chanelName,));


  }


  @override
  void dispose() {
    super.dispose();
  }




}
