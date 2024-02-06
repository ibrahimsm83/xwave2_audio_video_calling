import 'package:chat_app_with_myysql/app/resources/dimen.dart';
import 'package:chat_app_with_myysql/app/resources/myColors.dart';
import 'package:chat_app_with_myysql/controller/user/dashboard_controller.dart';
import 'package:chat_app_with_myysql/util/navigation.dart';
import 'package:chat_app_with_myysql/util/sizer.dart';
import 'package:chat_app_with_myysql/view/dashboard/settings/profile/edit_profile.dart';
import 'package:chat_app_with_myysql/widget/app_bar.dart';
import 'package:chat_app_with_myysql/widget/background.dart';
import 'package:chat_app_with_myysql/widget/common.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:chat_app_with_myysql/widget/profile_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  @override
  Widget build(BuildContext context) {
    final double radius = AppSizer.getRadius(AppDimen.CON_RADIUS);
    final double spacing=AppSizer.getHeight(15);
    return CustomBackground(
        child: Scaffold(
      appBar: DashboardAppbar(),
      backgroundColor: AppColor.colorTransparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: (){
            AppNavigator.navigateTo(EditProfile());
          },child: Column(children: [
            CircularPic(
              diameter: AppSizer.getHeight(80),
              imageType: ImageType.TYPE_NETWORK,
              image: dashboardController.user_model!.avatar,
            ),
            CustomText(
              text: dashboardController.user_model!.username,
              fontsize: 18,
              fontweight: FontWeight.w600,
              fontcolor: AppColor.colorWhite,
              textAlign: TextAlign.center,
            ),
          ],),),

          Expanded(
              child: Container(

                padding: EdgeInsets.symmetric(horizontal: AppSizer.getWidth(15),
                    vertical: AppSizer.getHeight(20)),
            decoration: BoxDecoration(
                color: AppColor.colorWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(radius),
                    topRight: Radius.circular(radius))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildFieldValue("Display Name", dashboardController.user_model!.username),
                SizedBox(height: AppSizer.getHeight(spacing),),
                buildFieldValue("Phone  Number", dashboardController.user_model!.phoneNumber),
                SizedBox(height: AppSizer.getHeight(spacing),),
              ],
            ),
          ))
        ],
      ),
    ));
  }

  Widget buildFieldValue(String field,String value){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      CustomText(text: field,fontcolor: AppColor.colorGrey,),
      CustomText(text: value,fontsize: 17,fontweight: FontWeight.w600,)
    ],);
  }

}