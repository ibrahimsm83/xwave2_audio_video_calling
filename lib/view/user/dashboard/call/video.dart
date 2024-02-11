import 'package:chat_app_with_myysql/controller/user/call_controller.dart';
import 'package:chat_app_with_myysql/model/voice_call.dart';
import 'package:chat_app_with_myysql/resources/asset_path.dart';
import 'package:chat_app_with_myysql/resources/dimen.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/view/user/dashboard/call/audio.dart';
import 'package:chat_app_with_myysql/widget/common.dart';
import 'package:flutter/material.dart';

class VideoCallLayout extends AudioCallLayout {
  const VideoCallLayout({Key? key,required CallController callController,
  void Function()? onTypeChanged}) : super(key: key,callController: callController,
      onTypeChanged: onTypeChanged);

  @override
  _VideoCallLayoutState createState() => _VideoCallLayoutState();
}

class _VideoCallLayoutState extends AudioCallLayoutState {

  final double localHeight=130;

  @override
  Widget build(BuildContext context) {
    final VoiceCall currentCall=callController.currentCall!;
    final double paddHorz=AppDimen.DASHBOARD_PADDING_HORZ;
    return Container(//width: 1.sw,height: 1.sh,

      child: Stack(children: [
      Positioned.fill(child: remoteView(currentCall),),
      Positioned(
        left: paddHorz,right: paddHorz,bottom: AppDimen.CONTROLS_BOTTOM,
        child: Container(child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
          Align(
              alignment: Alignment.topRight,
              child: localView(currentCall)),
          SizedBox(height: 25,),
          buildControls(currentCall),
        ],),),
      ),
        Align(
            alignment: Alignment.center,
            child: buildInfo(currentCall)),
    ],),);
  }

  Widget remoteView(VoiceCall currentCall){
    return Container(child: (currentCall.isConnected || currentCall.isConnecting)?
    callController.renderRemoteView(currentCall.guest.num_id):CustomImage(
      image: currentCall.guest.avatar,fit: BoxFit.cover,
    ),);
  }

  Widget localView(VoiceCall currentCall){

    return Container(
      height: localHeight,
      width: localHeight*0.8,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: AppColor.colorGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: (currentCall.isConnected || currentCall.isConnecting)?
      callController.renderLocalView():CustomImage(
        image: currentCall.user.avatar,
      ),
    );
  }

  @override
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
              !callController.isLoudSpeakerOn?AssetPath.ICON_SPEAKER_CROSS:AssetPath.ICON_SPEAKER,
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
        buildButton(AssetPath.ICON_CUT_CALL,bgColor: AppColor.colorRed1,
            iconColor: AppColor.colorWhite,onTap: (){
              callController.endCall();
            }),
      ],);
  }


}

