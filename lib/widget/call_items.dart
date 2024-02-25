import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/model/voice_call.dart';
import 'package:chat_app_with_myysql/resources/asset_path.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/util/datetime.dart';
import 'package:chat_app_with_myysql/util/sizer.dart';
import 'package:chat_app_with_myysql/widget/common.dart';
import 'package:chat_app_with_myysql/widget/icons.dart';
import 'package:chat_app_with_myysql/widget/myBtn.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:chat_app_with_myysql/widget/profile_items.dart';
import 'package:flutter/material.dart';

import '../resources/dimen.dart';

class UserGroupContainer extends StatelessWidget {
  final bool selected;
  final User_model user;
  final void Function()? onTap;
  const UserGroupContainer({
    Key? key,
    required this.user,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        child: Column(
          children: [
            buildCircle(),
            SizedBox(
              height: AppSizer.getHeight(10),
            ),
            CustomText(
              text: user.username,
              fontsize: 14,
              fontcolor: AppColor.colorWhite,
            )
          ],
        ),
      ),
    );
  }

  Widget buildCircle() {
    final double diameter = AppSizer.getHeight(60);
    return Container(
      width: diameter,
      height: diameter,
      child: Stack(
        children: [
          CircularPic(
            diameter: diameter,
            imageType: ImageType.TYPE_NETWORK,
            image: user.avatar,
            border: selected
                ? const BorderSide(width: 2, color: AppColor.colorBlue2)
                : BorderSide.none,
          ),
          Visibility(
              visible: selected,
              child: Align(
                alignment: Alignment.bottomRight,
                child: CircularButton(
                  diameter: diameter * 0.4,
                  bgColor: AppColor.colorBlue2,
                  color: AppColor.colorWhite,
                  icon: AssetPath.ICON_TICK,
                ),
              ))
        ],
      ),
    );
  }
}

class UserVoiceContainer extends StatelessWidget {
  final User_model user;
  const UserVoiceContainer({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double diameter = AppSizer.getHeight(35);
    final double radius = AppSizer.getRadius(10);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppSizer.getWidth(10), vertical: AppSizer.getHeight(8)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: AppColor.colorBlack2),
      child: Column(
        children: [
          CircularPic(
            diameter: diameter,
            imageType: ImageType.TYPE_NETWORK,
            image: user.avatar,
          ),
          SizedBox(
            height: AppSizer.getHeight(7),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomMonoIcon(
                icon: AssetPath.ICON_MIC,
                size: AppSizer.getHeight(12),
                color: AppColor.colorWhite,
              ),
              CustomText(
                text: user.username,
                fontcolor: AppColor.colorWhite,
                fontsize: 14,
              )
            ],
          )
        ],
      ),
    );
  }
}

class CallHistoryContainer extends StatelessWidget {
  static const MAX_ON_GRID = 4;
  static const FIT_LINE = 2;

  final VoiceCall call;
  final void Function()? onCallTap,onVideoTap;
  const CallHistoryContainer({
    super.key,
    required this.call,this.onCallTap,this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    final double iconsize=AppSizer.getHeight(22);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppSizer.getWidth(AppDimen.DASHBOARD_PADDING_HORZ)),
      child: Row(
        children: [
          buildPicCircle(call.getParticipants()),
          SizedBox(width: AppSizer.getWidth(10),),
          Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: AppSizer.getHeight(25)),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1,
                    color: AppColor.colorGrey3))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                CustomText(
                  text: !call.isGroup ? call.receiver!.username : "",
                  fontsize: 18,fontweight: FontWeight.w600,
                ),
                SizedBox(height: AppSizer.getHeight(4),),
                Row(
                  children: [
                    CustomMonoIcon(icon: AssetPath.ICON_CALL_INCOMING,
                        size: AppSizer.getHeight(16),isSvg: true,color: null,),
                    SizedBox(width: AppSizer.getWidth(5),),
                    CustomText(
                      text: DateTimeManager.getFormattedDateTime(call.dateTime!,
                          format: DateTimeManager.dateTimeFormat2,
                          format2: DateTimeManager.dateTimeFormat),
                      fontsize: 14,fontcolor: AppColor.colorGrey,
                    ),
                  ],
                ),
                            ],
                          ),
              )),
          CustomIconButton(icon: CustomMonoIcon(icon: AssetPath.ICON_CALL2,isSvg: true,
            size: iconsize,color: AppColor.colorGrey4,),onTap: onCallTap,),

          CustomIconButton(icon: CustomMonoIcon(icon: AssetPath.ICON_VIDEO,isSvg: true,
            size: iconsize,color: AppColor.colorGrey4,),onTap: onVideoTap,),
        ],
      ),
    );
  }

  Widget buildPicCircle(List<User_model> participants) {
    final diameter = AppSizer.getHeight(56);
    int total = participants.length;
    int total2 = total > MAX_ON_GRID ? MAX_ON_GRID : total;
    return Container(
      width: diameter,
      height: diameter,
      child: ClipOval(
        child: Wrap(
          children: List.generate(participants.length, (index) {
            return buildPicSlice(index, participants, total2, diameter, diameter);
          }),
        ),
      ),
    );
  }

  Widget buildPicSlice(
    int index,
    List<User_model> list,
    int total,
    double width,
    double height,
  ) {
    var item = list[index];
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
    return Container(width: width,height: height,
      child: CustomImage(
        image: item.avatar,imageType: ImageType.TYPE_NETWORK,
        fit: BoxFit.cover,
      ),
    );
  }
}
