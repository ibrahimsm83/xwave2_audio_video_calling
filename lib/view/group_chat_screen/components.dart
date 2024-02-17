import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

appBarForChatScreen(BuildContext context, {String? image, String? title,String? subtitle}) {
  return PreferredSize(
      preferredSize: Size(double.infinity, 100),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Colors.black,
          //     boxShadow: [
          //   BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 1)
          // ]
          ),
          height: 70,
          child: Padding(
            padding:  EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: InkWell(
                      onTap: () => Get.back(),
                      child:  Icon(Icons.arrow_back,color: appYellow,)),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => DashBoard(page:4),
                    //   ),
                    // );
                  },
                  child: Row(
                    children: [
                    Container(
                      height: 45,
                      width: 45,
                      margin: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(image!), fit: BoxFit.cover),
                        color: Colors.white,
                      ),
                    ),
        
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          myText(text: title??"" ,color: Colors.white,size: 16,fontWeight: FontWeight.w500,),
                          myText(text: "${subtitle} members," ??"",color: Colors.grey,size: 12,fontWeight: FontWeight.w300,),
                        SizedBox(height: 5.0),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                IconButton(onPressed: () {
                  //   callController.audioCall(widget.receiver);
                  //  next_page(MakingAudioCall(receiver: widget.receiver));
        
        
                }, icon: Icon(CupertinoIcons.phone,color: appYellow,)),
                SizedBox(width: 10.0),
                IconButton(onPressed: () {
                 // callController.videoCall(widget.receiver);
                  //next_page(VideoCallForCaller( user_model: widget.receiver, chanelName: '',));
                }, icon: Icon(CupertinoIcons.video_camera,color: appYellow,)),
        
              ],
            ),
          ),
        ),
      ));
}
