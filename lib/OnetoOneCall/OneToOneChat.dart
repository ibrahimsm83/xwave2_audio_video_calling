import 'dart:io';

import 'package:chat_app_with_myysql/Models/ChatModel.dart';
import 'package:chat_app_with_myysql/Models/User_model.dart';
import 'package:chat_app_with_myysql/OnetoOneCall/VideoCallForCaller.dart';
import 'package:chat_app_with_myysql/helper/MyPraf.dart';
import 'package:chat_app_with_myysql/helper/apis/ApiService.dart';
import 'package:chat_app_with_myysql/helper/apis/SocketManager.dart';
import 'package:chat_app_with_myysql/helper/methods.dart';
import 'package:chat_app_with_myysql/helper/myColors.dart';
import 'package:chat_app_with_myysql/helper/widgets/myBtn.dart';
import 'package:chat_app_with_myysql/helper/widgets/myText.dart';
import 'package:chat_app_with_myysql/helper/widgets/my_input.dart';
import 'package:chat_app_with_myysql/helper/widgets/my_profile_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'MakingAudioCall.dart';
import '../helper/apis/apis.dart';
import '../helper/widgets/ChatHolder.dart';

class OneToOneChat extends StatefulWidget {
  final String chatID;
  final User_model sender,receiver;
  const OneToOneChat({super.key, required this.chatID, required this.sender, required this.receiver});

  @override
  State<OneToOneChat> createState() => _OneToOneChatState();
}

class _OneToOneChatState extends State<OneToOneChat> {
  ApiService apiService=ApiService();
  ScrollController scrollController=ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(children: [

        myappBar(),
        chatListWight(),
        chatOptionsWight(),



      ],)
    );
  }

  Widget myappBar(){
    return Container(
      width: Get.width,height: 100,
      decoration: BoxDecoration(
        color: appback
      ),
      child:Column(children: [

        SizedBox(height: 30,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(onPressed: () {
              Get.back();
            }, icon: Icon(Icons.arrow_back,color: appYellow,)),
            my_profile_container(img: widget.receiver.avatar),SizedBox(width: 10,),
            myText(text: widget.receiver.username,color: Colors.white,size: 16,fontWeight: FontWeight.w500,),
            Spacer(),
            IconButton(onPressed: () {

              next_page(MakingAudioCall(receiver: widget.receiver));


            }, icon: Icon(CupertinoIcons.phone,color: appYellow,)),
            IconButton(onPressed: () {

              next_page(VideoCallForCaller( user_model: widget.receiver, chanelName: '',));
            }, icon: Icon(CupertinoIcons.video_camera,color: appYellow,)),

          ],),
      ],)


    );
  }

  Widget chatListWight(){
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemCount: chatList.length,
          itemBuilder: (context, index) {

            ChatModel model=chatList[index];

            if(model.sender.id==widget.sender.id) {
              return Align(
                  alignment: Alignment.centerRight,
                  child: chatHolder(model: model, chatBoxColor: appYellow));
            }
            else{
              return Align(
                  alignment: Alignment.centerLeft,
                  child: chatHolder(model: model, chatBoxColor: applightWhite));
            }


          },),
    );
  }
  
  Widget chatOptionsWight(){
    return Row(children: [
      IconButton(onPressed: () {
        
      }, icon: Icon(Icons.emoji_emotions_outlined)),
      chatInputWight(),
      IconButton(onPressed: () {
        sendTextMSg();
      }, icon: Icon(Icons.send,color: appYellow,))
    ],);
  }

  var textMsgControler=TextEditingController();
  Widget chatInputWight(){
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(children: [
          
          Expanded(child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: my_inputWithHint(controler: textMsgControler, hint: 'Message',),
          )),

          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Icon(Icons.attach_file),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Icon(Icons.camera_alt_outlined),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Icon(Icons.mic),
          ),

        ],),
      ),
    ) ;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    valuesPrint();

   registerEvent('new-message', msgListner);
    fetchChat();
  }

  valuesPrint()async{

    print('chat id - '+widget.chatID);
    print('sender id - '+widget.sender.id);
    print('receiver id - '+widget.receiver.id);
    String token=await getToken_praf();
    print('token - $token');
  }


  List<ChatModel> chatList=[];
  fetchChat()async{


    EasyLoading.show();
    Response response=await apiService.getApiWithToken(fetch1To1chat+widget.receiver.id);
    print(response.body);



    EasyLoading.dismiss();


    if(response.statusCode==200){
      List<dynamic> list=response.body;


      list.forEach((element) {
        String contant='';
        String mediaType='';
        String url='';
        String lati='',longi='';
        String time='';

        User_model sender=User_model.fromJson(element['sender']);
        User_model receiver=User_model.fromJson(element['receiver']);


        time=element['createdAt'];



        if(element['location']!=null){
          lati=element['location']['latitude'].toString();
          longi=element['location']['longitude'].toString();
        }


        if(element['content']!=null){
          contant=element['content'];

        }
        mediaType=element['media']['type'];
        if(element['media']['url']!=null){
          url=element['media']['url'];

        }

        chatList.add(ChatModel(content: contant, mediaType: mediaType, url: url, lati: lati, longi: longi, time: time, sender: sender, receiver: receiver));

      });

      setState(() {

      });


      scrolList(scrollController);


    }



    }

  sendTextMSg()async{

    if(textMsgControler.text.isEmpty)
      return;

    // XFile? xFile=await ImagePicker().pickImage(source: ImageSource.gallery);
    // if(xFile==null)
    //   return;
    //
    //
    // File file=File(xFile.path);
    // print(basename(file.path));
    // EasyLoading.show();
    Map<String,dynamic> map={
      'receiver':widget.receiver.id,
      'content':textMsgControler.text,
      // 'media':MultipartFile(file.path, filename: basename(file.path)),
      // 'latitude':'0',
      // 'longitude':'0',
    };

    Response response=await apiService.postApiWithFromDataAndHeaderAndContantType(send1To1Msg, map);

    // EasyLoading.dismiss();
    print(response.body);

    if(response.statusCode!=200)
      return;

    textMsgControler.text='';
    // {message: {_id: 65a8f0d47167cd6905ca637a, content: ty,
    // media: {type: none}, location: {},
    // sender: {_id: 65a2d97b556f1776a25a4d4f, username: n10, avatar: https://i.stack.imgur.com/34AD2.jpg},
    //  chat: {_id: 65a65648ffdcd322af8fd0fd, users: [{_id: 65a2d97b556f1776a25a4d4f, phoneNumber: +9210, username: n10}, {_id: 65a65609ffdcd322af8fd0f1, phoneNumber: +92100, username: n100}],
    //  isGroupChat: false, createdAt: 1/18/2024, 2:35:16 PM, updatedAt: 1/18/2024, 2:35:16 PM}}}




    String contant='';
    String mediaType='';
    String url='';
    String lati='',longi='';
    String time='';




    time=response.body['message']['chat']['updatedAt'];



    if(response.body['message']['location']!=null){

      if(response.body['message']['location']['latitude']!=null) {
        lati = response.body['message']['location']['latitude'].toString();
        longi = response.body['message']['location']['longitude'].toString();
      }
    }


    if(response.body['message']['content']!=null){
      contant=response.body['message']['content'];

    }
    mediaType=response.body['message']['media']['type'];
    if(response.body['message']['media']['url']!=null){
      url=response.body['message']['media']['url'];

    }

    chatList.add(ChatModel(content: contant, mediaType: mediaType, url: url, lati: lati, longi: longi, time: time, sender: widget.sender, receiver: widget.receiver));


    setState(() {

    });


    scrolList(scrollController);

  }





  msgListner(dynamic newMessage) async{



      print('msg - '+newMessage.toString());



      String contant='';
      String mediaType='';
      String url='';
      String lati='',longi='';
      String time='';




      time=newMessage['createdAt'];



      if(newMessage['location']!=null){

        if(newMessage['location']['latitude']!=null) {
          lati = newMessage['location']['latitude'].toString();
          longi = newMessage['location']['longitude'].toString();
        }
      }


      if(newMessage['content']!=null){
      contant=newMessage['content'];

      }
      mediaType=newMessage['media']['type'];
      if(newMessage['media']['url']!=null){
      url=newMessage['media']['url'];

      }

      chatList.add(ChatModel(content: contant, mediaType: mediaType, url: url, lati: lati, longi: longi, time: time, sender: widget.receiver, receiver: widget.sender));


      setState(() {

      });


      scrolList(scrollController);



  }



  @override
  void dispose() {

    unregisterEvent('new-message');
    super.dispose();
  }
}


