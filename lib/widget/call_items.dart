import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/resources/asset_path.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
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
  const UserVoiceContainer({Key? key,required this.user,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double diameter = AppSizer.getHeight(35);
    final double radius=AppSizer.getRadius(10);
    return Container(
      padding: EdgeInsets.symmetric(horizontal:AppSizer.getWidth(10),
          vertical: AppSizer.getHeight(8)),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius),
          color: AppColor.colorBlack2),
      child: Column(children: [
      CircularPic(
        diameter: diameter,
        imageType: ImageType.TYPE_NETWORK,
        image: user.avatar,
      ),
      SizedBox(height: AppSizer.getHeight(7),),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomMonoIcon(icon: AssetPath.ICON_MIC, size: AppSizer.getHeight(12),
            color: AppColor.colorWhite,),
        CustomText(text: user.username,fontcolor: AppColor.colorWhite,fontsize: 14,)
      ],)
    ],),);
  }
}
