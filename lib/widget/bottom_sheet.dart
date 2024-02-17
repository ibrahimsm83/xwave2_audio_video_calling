import 'package:chat_app_with_myysql/resources/dimen.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/util/sizer.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:flutter/material.dart';

abstract class CustomBottomSheet extends StatelessWidget {
  final String title;
  final void Function()? onDoneTap;
  final bool divider;
  final bool safe;
  const CustomBottomSheet({
    Key? key,
    this.onDoneTap,this.divider=true,this.safe=true,
    required this.title,
  }) : super(key: key);


  void onClose(){

  }

  @override
  Widget build(BuildContext context) {
    final double radius = AppSizer.getRadius(AppDimen.BOTTOM_SHEET_RADIUS);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius)),
          color: AppColor.colorWhite,),
        child: SafeArea(
          bottom: safe,
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: divider?const BorderSide(width: 1,
                          color: AppColor.colorWhite)
                          :BorderSide.none)
                  ),
                  child: Row(
                    children: [
                 /*     Padding(
                        padding: EdgeInsets.only(left: AppSizer.getHorizontalSize(7)),
                        child: ButtonClose(
                          onTap: (){
                            AppNavigator.pop();
                            onClose();
                          },),
                      ),*/
                      Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: AppSizer.getWidth(12)),
                            child: CustomText(
                              text: title,
                              //textAlign: TextAlign.center,
                              fontweight: FontWeight.w600,
                              fontsize: 15,
                            ),
                          )),
              /*        buildButton(
                        "lbl_done".tr,
                        color: onDoneTap != null
                            ? AppColor.primary1
                            : AppColor.transparent,
                        onTap: onDoneTap,
                      )*/
                    ],
                  ),
                ),
                buildChild(context),
/*          Container(color: Colors.red,
                      height: height,
                      child: SingleChildScrollView(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: children,),),),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildChild(BuildContext context);

/*  Widget buildButton(String text,
      {Color color = AppColor.primary1, Function()? onTap}) {
    return CustomButton(
      fontsize: 13,
      bgColor: AppColor.transparent,
      text: text,
      padding: EdgeInsets.symmetric(
          horizontal: AppSizer.getHorizontalSize(17), vertical: AppSizer.getVerticalSize(17)),
      textColor: color,
      fontWeight: FontWeight.w500,
      onTap: onTap,
    );
  }*/
}