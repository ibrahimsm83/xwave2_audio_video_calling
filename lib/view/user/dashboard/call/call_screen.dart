import 'package:chat_app_with_myysql/controller/user/call_controller.dart';
import 'package:chat_app_with_myysql/controller/user/controller.dart';
import 'package:chat_app_with_myysql/model/voice_call.dart';
import 'package:chat_app_with_myysql/resources/integer.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/service/socket.dart';
import 'package:chat_app_with_myysql/view/user/dashboard/call/audio.dart';
import 'package:chat_app_with_myysql/view/user/dashboard/call/video.dart';
import 'package:chat_app_with_myysql/widget/background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class CallScreen extends StatefulWidget {

  static const route="/CallScreen";

  const CallScreen({Key? key}) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> with TickerProviderStateMixin{

  late Animation<double> animation;
  late AnimationController animationController;

  final DashboardController dashboardController=Get.find<DashboardController>();

  @override
  void initState(){
    dashboardController.socketService.addEvent(SocketEvent.HANDLE_CALL_EVENT);
    animationController=AnimationController(vsync: this,
        duration: const Duration(//milliseconds: 3000,
            milliseconds: AppInteger.SWIPE_DURATION_MILLI
        ));
    animation=animationController.drive(Tween<double>(begin: 0,end: 180));
    super.initState();
  }

  @override
  void dispose() {
    dashboardController.socketService.removeEvent(SocketEvent.HANDLE_CALL_EVENT);
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: CustomBackground(
            bgColor: AppColor.appBlack,
            child: Scaffold(
                backgroundColor: AppColor.colorTransparent,
                body: GetBuilder<CallController>(
                    builder: (cont){
                      final VoiceCall? currentCall = cont.currentCall;
                      return currentCall!=null?AnimatedBuilder(
                        animation: animationController,

                        builder: (con,child){
                          print("child is ${animationController.value}: $child");
                          if(animationController.isAnimating) {
                            if(animationController.value>=0 && animationController.value<=0.5){
                              child=currentCall.type==VoiceCall.TYPE_AUDIO? VideoCallLayout(
                                callController: cont,onTypeChanged: (){
                                  cont.switchVideo(animationController);
                              },):
                              AudioCallLayout(callController: cont,onTypeChanged: (){
                                cont.switchVideo(animationController);
                              },);
                            }
                            else{
                              child=buildLayout(cont, currentCall);
                            }
                          }
                          else{
                            child=buildLayout(cont, currentCall);
                            animationController.reset();
                          }
                          return Transform(
                            transform: Matrix4.rotationY(degToRadian(animation.value)),
                            alignment: Alignment.center,
                            child: child,);
                        },//child: buildLayout(cont,currentCall),
                        /*  child: (currentCall.type==VoiceCall.TYPE_AUDIO?
        AudioCallLayout(cont:cont,controller: animationController,): VideoCallLayout(cont: cont,
          controller: animationController,)),*/
                      ):Container();
                    }))));
  }

  Widget buildLayout(CallController cont,VoiceCall currentCall){
    return currentCall.type==VoiceCall.TYPE_AUDIO?
    AudioCallLayout(callController: cont,onTypeChanged: (){
      cont.switchVideo(animationController);
    },):
    VideoCallLayout(callController: cont,onTypeChanged: (){
      cont.switchVideo(animationController);
    },);
  }

  double degToRadian(double deg){
    return (deg/180)*math.pi;
  }
}
