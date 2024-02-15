
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/view/group_chat_screen/components.dart';
import 'package:chat_app_with_myysql/widget/my_profile_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupChatScreen extends StatefulWidget {
String? groupImage;
String? title;
String? userCount;

   GroupChatScreen({Key? key,this.groupImage,this.title,this.userCount}) : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarForChatScreen(context,
            image: widget.groupImage!, title: widget.title!,subtitle: widget.userCount),
        backgroundColor: AppColor.appBlack,
        resizeToAvoidBottomInset: true,
        body:
            Column(children: [
              //myappBar(),
              // chatListWight(),
              // Visibility(
              //   visible: !chatController.isMicTapped.value,
              //   child:chatOptionsWight(context),
              //   replacement:audioRecordingSheetWight(),
              // ),
            ],),

    );
  }
  // Widget myappBar(){
  //   return Container(
  //       width: Get.width,height: 100,
  //       decoration: BoxDecoration(
  //           color: appback
  //       ),
  //       child:Column(children: [
  //
  //         SizedBox(height: 30,),
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             IconButton(onPressed: () {
  //               Get.back();
  //             }, icon: Icon(Icons.arrow_back,color: appYellow,)),
  //             my_profile_container(img: widget.receiver.avatar),SizedBox(width: 10,),
  //             //myText(text: widget.receiver.username,color: Colors.white,size: 16,fontWeight: FontWeight.w500,),
  //             Spacer(),
  //             IconButton(onPressed: () {
  //               //callController.audioCall(widget.receiver);
  //               //  next_page(MakingAudioCall(receiver: widget.receiver));
  //
  //
  //             }, icon: Icon(CupertinoIcons.phone,color: appYellow,)),
  //             IconButton(onPressed: () {
  //            //   callController.videoCall(widget.receiver);
  //               //next_page(VideoCallForCaller( user_model: widget.receiver, chanelName: '',));
  //             }, icon: Icon(CupertinoIcons.video_camera,color: appYellow,)),
  //
  //           ],),
  //       ],)
  //
  //
  //   );
  // }

}
