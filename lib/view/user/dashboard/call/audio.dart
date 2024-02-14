import 'package:chat_app_with_myysql/controller/user/call_controller.dart';
import 'package:chat_app_with_myysql/model/voice_call.dart';
import 'package:chat_app_with_myysql/resources/asset_path.dart';
import 'package:chat_app_with_myysql/resources/dimen.dart';
import 'package:chat_app_with_myysql/resources/lang/strings.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/util/datetime.dart';
import 'package:chat_app_with_myysql/widget/common.dart';
import 'package:chat_app_with_myysql/widget/myBtn.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:chat_app_with_myysql/widget/profile_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioCallLayout extends StatefulWidget {
  final CallController callController;
  final void Function()? onTypeChanged;
  const AudioCallLayout({
    Key? key,
    required this.callController,
    this.onTypeChanged,
  }) : super(key: key);

  @override
  State<AudioCallLayout> createState() => AudioCallLayoutState();
}

class AudioCallLayoutState extends State<AudioCallLayout> {
  final double diameter = 50;

  final double spacing = 10;

  CallController get callController => widget.callController;

  @override
  Widget build(BuildContext context) {
    final VoiceCall currentCall = callController.currentCall!;
    final double spacing = 10;
    return Container(
      //width: 1.sw,height: 1.sh,
      width: Get.width, height: Get.height,
     // color: AppColor.appBlack,
      child: Stack(
        children: [
          Align(
            alignment: const FractionalOffset(0.5,0.1),
            child: buildInfo(currentCall),
          ),
          Positioned(
              bottom: AppDimen.CONTROLS_BOTTOM,
              left: 0,
              right: 0,
              child: buildControls(
                currentCall,
              )),
        ],
      ),
    );
  }

  Widget buildInfo(VoiceCall currentCall) {
    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularPic(
          diameter: 126,
          imageType: ImageType.TYPE_NETWORK,
          image: callController.currentCall!.guest.avatar,
        ),
        SizedBox(
          height: 10,
        ),
        CustomText(
          text: callController.currentCall!.guest.username,
          fontcolor: AppColor.colorWhite,
          fontsize: 26,
          fontweight: FontWeight.bold,
        ),
        SizedBox(
          height: 10,
        ),
        buildStatus(currentCall),
        buildTimer(),
      ],
    ));
  }

  Widget buildStatus(VoiceCall currentCall) {
    return CustomText(
      text: currentCall.isDialed
          ? (currentCall.isIdle
              ? "${AppStrings.TEXT_DIALING}"
              : currentCall.isConnecting
                  ? "${AppStrings.TEXT_CONNECTING}..."
                  : currentCall.isConnected
                      ? "${AppStrings.TEXT_CONNECTED}"
                      : "")
          : (currentCall.isIdle
              ? "${AppStrings.TEXT_INCOMING_CALL}"
              : currentCall.isConnecting
                  ? "${AppStrings.TEXT_CONNECTING}..."
                  : currentCall.isConnected
                      ? "${AppStrings.TEXT_CONNECTED}"
                      : ""),
      fontweight: FontWeight.bold,
      fontcolor: AppColor.colorBlue,
    );
  }

  Widget buildTimer() {
    return Obx(() {
      return Visibility(
        visible: callController.elapsed_time > 0,
        child: CustomText(
          text: DateTimeManager.getElapsedTime(callController.elapsed_time),
          fontweight: FontWeight.bold,
          fontcolor: AppColor.colorRed1,
        ),
      );
    });
  }

  Widget buildButton(String icon,
      {Color bgColor = AppColor.colorWhite,
      Color iconColor = AppColor.colorBlack,
      void Function()? onTap,
      bool isSvg = true}) {
    return CircularButton(
      diameter: diameter,
      icon: icon,
      onTap: onTap,
      color: iconColor,
      isSvg: isSvg,
      bgColor: bgColor,
    );
  }

  Widget buildControls(
    VoiceCall currentCall,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: !currentCall.isIdle,
          child: buildButton(
              callController.isAudioMuted
                  ? AssetPath.ICON_MIC_CROSS
                  : AssetPath.ICON_MIC,
              isSvg: false, onTap: () {
            callController.muteAudio();
          }),
        ),
        SizedBox(
          width: spacing,
        ),
        Visibility(
          visible: !currentCall.isIdle,
          child: buildButton(
            AssetPath.ICON_VIDEO,
            onTap: widget.onTypeChanged,
          ),
        ),
        SizedBox(
          width: spacing,
        ),
        Visibility(
          visible: !currentCall.isIdle,
          child: buildButton(
              callController.isLoudSpeakerOn
                  ? AssetPath.ICON_SPEAKER
                  : AssetPath.ICON_SPEAKER_CROSS,
              isSvg: false, onTap: () {
            callController.toggleLoudSpeaker();
          }),
        ),
        SizedBox(
          width: spacing,
        ),
        (!currentCall.isDialed && currentCall.isIdle)
            ? Row(
                children: [
                  buildButton(AssetPath.ICON_CALL,
                      bgColor: AppColor.colorGreen1,
                      iconColor: AppColor.colorWhite, onTap: () {
                    callController.receiveCall();
                  }),
                  SizedBox(
                    width: spacing,
                  ),
                  buildButton(AssetPath.ICON_CUT_CALL,
                      bgColor: AppColor.colorRed1,
                      iconColor: AppColor.colorWhite, onTap: () {
                    callController.endCall();
                  }),
                ],
              )
            : buildButton(AssetPath.ICON_CALL,
                bgColor: AppColor.colorRed1,
                iconColor: AppColor.colorWhite, onTap: () {
                callController.endCall();
              }),
      ],
    );
  }
}
