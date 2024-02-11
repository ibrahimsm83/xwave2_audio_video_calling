import 'package:chat_app_with_myysql/controller/user/call_controller.dart';
import 'package:chat_app_with_myysql/model/voice_call.dart';
import 'package:chat_app_with_myysql/resources/asset_path.dart';
import 'package:chat_app_with_myysql/resources/dimen.dart';
import 'package:chat_app_with_myysql/resources/lang/strings.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/util/datetime.dart';
import 'package:chat_app_with_myysql/widget/myBtn.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioCallLayout extends StatefulWidget {

  final CallController callController;
  final void Function()? onTypeChanged;
  const AudioCallLayout({Key? key,required this.callController,this.onTypeChanged,})
      : super(key: key);

  @override
  State<AudioCallLayout> createState() => AudioCallLayoutState();
}

class AudioCallLayoutState extends State<AudioCallLayout> {

  final double diameter=50;

  final double spacing=10;

  CallController get callController => widget.callController;

  @override
  Widget build(BuildContext context) {
    final VoiceCall currentCall=callController.currentCall!;
    final double spacing=10;
    var media=MediaQuery.of(context);
    return Container(//width: 1.sw,height: 1.sh,
     // color: AppColor.COLOR_RED1,
      child: Stack(children: [
        Align(alignment: Alignment.center,
          child: buildInfo(currentCall),
        ),
     Positioned(
         bottom: AppDimen.CONTROLS_BOTTOM,left: 0,right: 0,
         child: buildControls(currentCall,)),
    ],),);
  }

  Widget buildInfo(VoiceCall currentCall){
    return Container(child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
        buildCaller(currentCall),
        buildTimer(),
    ],));
  }


  Widget buildCaller(VoiceCall currentCall){
    return CustomText(text:currentCall.isDialed?(
        currentCall.isIdle?"${AppStrings.TEXT_DIALING} ${currentCall.guest.username}...":
        currentCall.isConnecting?"${AppStrings.TEXT_CONNECTING}...":
        currentCall.isConnected?"${AppStrings.TEXT_CONNECTED}":""):
    (currentCall.isIdle?"${AppStrings.TEXT_INCOMING_CALL} ${currentCall.guest.username}":
    currentCall.isConnecting?"${AppStrings.TEXT_CONNECTING}...":
    currentCall.isConnected?"${AppStrings.TEXT_CONNECTED}":""),
      fontweight: FontWeight.bold,fontcolor: AppColor.colorBlue,
    );
  }

  Widget buildTimer(){
    return Obx((){
      return Visibility(
        visible: callController.elapsed_time>0,
        child: CustomText(text:DateTimeManager.getElapsedTime(callController.elapsed_time),
        fontweight:  FontWeight.bold,
          fontcolor:AppColor.colorRed1,),);
    });
  }


  Widget buildButton(String icon,{Color bgColor=AppColor.colorWhite,
    Color iconColor=AppColor.colorBlack, void Function()? onTap}){
    return CircularButton(diameter: diameter, icon: icon,onTap: onTap,color: iconColor,
      bgColor: bgColor,);
  }

  Widget buildControls(VoiceCall currentCall,){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Visibility(
        visible: !currentCall.isIdle,
        child: buildButton(
            callController.isAudioMuted?AssetPath.ICON_MIC:AssetPath.ICON_MIC_CROSS,
            onTap: (){
              callController.muteAudio();
            }),
      ),
      SizedBox(width: spacing,),
      Visibility(
        visible: !currentCall.isIdle,
        child: buildButton(AssetPath.ICON_VIDEO,
            onTap: widget.onTypeChanged,),
      ),
      SizedBox(width: spacing,),
      Visibility(
        visible: !currentCall.isIdle,
        child: buildButton(
            !callController.isLoudSpeakerOn?AssetPath.ICON_SPEAKER_CROSS:
            AssetPath.ICON_SPEAKER,
            onTap: (){
              callController.toggleLoudSpeaker();
            }),
      ),
        SizedBox(width: spacing,),
      (!currentCall.isDialed && currentCall.isIdle)?
      Row(
        children: [
          buildButton(AssetPath.ICON_CALL,bgColor: AppColor.colorGreen1,
              iconColor: AppColor.colorWhite,onTap: (){
                callController.receiveCall();
              }),
          SizedBox(width: spacing,),
          buildButton(AssetPath.ICON_CUT_CALL,bgColor: AppColor.colorRed1,
              iconColor: AppColor.colorWhite,onTap: (){
                callController.endCall();
              }),
        ],
      ):
      buildButton(AssetPath.ICON_CALL,bgColor: AppColor.colorRed1,
          iconColor: AppColor.colorWhite,onTap: (){
            callController.endCall();
          }),
    ],);
  }

}
