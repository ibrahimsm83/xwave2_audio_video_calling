import 'package:chat_app_with_myysql/controller/user/call_controller.dart';
import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/model/voice_call.dart';
import 'package:chat_app_with_myysql/resources/asset_path.dart';
import 'package:chat_app_with_myysql/resources/dimen.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/util/sizer.dart';
import 'package:chat_app_with_myysql/view/user/dashboard/call/calling/audio.dart';
import 'package:chat_app_with_myysql/widget/app_bar.dart';
import 'package:chat_app_with_myysql/widget/common.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoCallLayout extends AudioCallLayout {
  const VideoCallLayout(
      {Key? key,
      required CallController callController,
      void Function()? onTypeChanged})
      : super(
            key: key,
            callController: callController,
            onTypeChanged: onTypeChanged);

  @override
  _VideoCallLayoutState createState() => _VideoCallLayoutState();
}

class _VideoCallLayoutState extends AudioCallLayoutState {
  final double localHeight = 130;

  static const MAX_ON_GRID = 9;
  static const FIT_LINE = 3;

  @override
  Widget build(BuildContext context) {
    final VoiceCall currentCall = callController.currentCall!;
    final double paddHorz = AppDimen.DASHBOARD_PADDING_HORZ;
    return Scaffold(
      //width: Get.width,height: Get.height,
      backgroundColor: AppColor.colorTransparent,
      //appBar: DashboardAppbar(text: callController.currentCall!.guest.username),
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Stack(
          children: [
            Positioned.fill(
              child: !currentCall.isGroup
                     ? buildSingleVideo(currentCall)
                 // ? buildMultiVideo(currentCall)
                  : buildMultiVideo(currentCall),
            ),
            Positioned(
              left: paddHorz,
              right: paddHorz,
              bottom: AppDimen.CONTROLS_BOTTOM,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: localView(currentCall)),
                    SizedBox(
                      height: 25,
                    ),
                    buildControls(currentCall),
                  ],
                ),
              ),
            ),
            (!currentCall.isGroup && currentCall.isIdle)
                ? Align(
                    alignment: Alignment.center, child: buildInfo(currentCall))
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildInfo(VoiceCall currentCall) {
    return Container(
      color: AppColor.appBlack,
      padding: EdgeInsets.symmetric(
          horizontal: AppSizer.getWidth(10), vertical: AppSizer.getHeight(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildStatus(currentCall),
          buildGuest(currentCall.guest),
          //buildTimer(),
        ],
      ),
    );
  }

  @override
  Widget buildGuest(User_model user) {
    return CustomText(
      text: user.username,
      fontcolor: AppColor.colorWhite,
      fontsize: 26,
      fontweight: FontWeight.bold,
    );
  }

  GlobalKey? key;

  @override
  void dispose() {
    print("video disposed");
    super.dispose();
  }

  Widget buildMultiVideo(
    VoiceCall currentCall,
  ) {
    return LayoutBuilder(builder: (con, cons) {
      var size = cons.biggest;
      final List<int> list = callController.getParticipantsList();
      final int total = list.length;
      final int total2 = total > MAX_ON_GRID ? MAX_ON_GRID : total;
      return Wrap(
          children: List.generate(list.length, (index) {
        return buildMultiVideoSlice(
            currentCall, index, list, total2, size.width, size.height);
      }));
    });
  }

  Widget buildMultiVideoSlice(
    VoiceCall currentCall,
    int index,
    List<int> list,
    int total,
    double width,
    double height,
  ) {
    var id = list[index];
    int i = index + 1;
    int rem = i % FIT_LINE;
    if (!(rem > 0 && (total - i) <= 0)) {
      // width = width / FIT_LINE;
      height = height / FIT_LINE;
    }
    if (total > FIT_LINE) {
       //  height = height / FIT_LINE;
      width = width / FIT_LINE;
    }
    return remoteView(id, width: width, height: height);
  /*  return Container(color: index.isEven?Colors.red:Colors.green,
      width: width,height: height,);*/
  }

  Widget buildSingleVideo(VoiceCall currentCall) {
    final List<int> list = callController.getParticipantsList();
    return Container(
      child: ((currentCall.isConnected || currentCall.isConnecting) &&
              list.isNotEmpty)
          ? remoteView(
              list[0],
              user2: currentCall.guest,
            )
          : CustomImage(
              image: currentCall.guest.avatar,
              imageType: ImageType.TYPE_NETWORK,
              fit: BoxFit.cover,
            ),
    );
  }

  Widget remoteView(int id,
      {User_model? user2, double? width, double? height}) {
    var us = callController.getParticipant(id)!;
    var user =
        user2 ?? (callController.currentCall!.getParticipant(us.id) ?? us);
    return Container(
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned.fill(child: callController.renderRemoteView(id)),
          Center(
            child: CustomText(
              text: user.username,
              fontcolor: AppColor.colorWhite,
            ),
          )
        ],
      ),
    );
  }

  Widget localView(VoiceCall currentCall) {
    return Container(
      height: localHeight,
      width: localHeight * 0.8,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColor.colorGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: (currentCall.isConnected || currentCall.isConnecting)
          ? callController.renderLocalView()
          : CustomImage(
              image: currentCall.user.avatar,
              imageType: ImageType.TYPE_NETWORK,
              fit: BoxFit.cover,
            ),
    );
  }

  @override
  Widget buildControls(
    VoiceCall currentCall,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: currentCall.isConnecting || currentCall.isConnected,
          child: Row(
            children: [
              buildButton(
                  callController.isAudioMuted
                      ? AssetPath.ICON_MIC_CROSS
                      : AssetPath.ICON_MIC,
                  isSvg: false, onTap: () {
                callController.muteAudio();
              }),
              SizedBox(
                width: spacing,
              ),
              buildButton(
                AssetPath.ICON_VIDEO,
                onTap: widget.onTypeChanged,
              ),
              SizedBox(
                width: spacing,
              ),
              buildButton(
                AssetPath.ICON_SWITCH_CAMERA,
                isSvg: false,
                onTap: () {
                  callController.switchCamera();
                },
              ),
              SizedBox(
                width: spacing,
              ),
              buildButton(
                  callController.isLoudSpeakerOn
                      ? AssetPath.ICON_SPEAKER
                      : AssetPath.ICON_SPEAKER_CROSS,
                  isSvg: false, onTap: () {
                callController.toggleLoudSpeaker();
              }),
              SizedBox(
                width: spacing,
              ),
            ],
          ),
        ),
        buildActionButtons(currentCall),
      ],
    );
  }
}
