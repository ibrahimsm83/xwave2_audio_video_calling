import 'package:chat_app_with_myysql/app/resources/dimen.dart';
import 'package:chat_app_with_myysql/app/resources/myColors.dart';
import 'package:chat_app_with_myysql/controller/user/dashboard_controller.dart';
import 'package:chat_app_with_myysql/util/MyPraf.dart';
import 'package:chat_app_with_myysql/util/navigation.dart';
import 'package:chat_app_with_myysql/util/sizer.dart';
import 'package:chat_app_with_myysql/view/Login/Login.dart';
import 'package:chat_app_with_myysql/view/dashboard/settings/profile/my_profile.dart';
import 'package:chat_app_with_myysql/widget/app_bar.dart';
import 'package:chat_app_with_myysql/widget/background.dart';
import 'package:chat_app_with_myysql/widget/common.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:chat_app_with_myysql/widget/profile_items.dart';
import 'package:chat_app_with_myysql/widget/settings_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {

  static const route="/SettingsScreen";
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    final double radius = AppSizer.getRadius(AppDimen.CON_RADIUS);
    return CustomBackground(
        child: Scaffold(
      backgroundColor: AppColor.colorTransparent,
      appBar: DashboardAppbar(text: "Settings"),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            color: AppColor.colorWhite,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                topRight: Radius.circular(radius))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  AppNavigator.navigateTo(MyProfileScreen());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: AppSizer.getHeight(15),
                      horizontal: AppSizer.getWidth(15)),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 1, color: AppColor.colorBlack))),
                  child: Row(
                    children: [
                      CircularPic(
                        diameter: 50,
                        imageType: ImageType.TYPE_NETWORK,
                        image: dashboardController.user_model!.avatar,
                      ),
                      SizedBox(
                        width: AppSizer.getWidth(15),
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "My Profile",
                            fontweight: FontWeight.bold,
                            fontsize: 17,
                          ),
                          CustomText(
                            text: "Never give up",
                            fontweight: FontWeight.bold,
                            fontsize: 13,
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
              SettingContainer(
                text1: "Logout",
                onTap: () {
                  clearPreferences();
                  AppNavigator.navigateToReplaceAll(() => Login());
                //  Get.delete<DashboardController>();
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
