import 'package:chat_app_with_myysql/resources/dimen.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/util/sizer.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:flutter/material.dart';

abstract class CustomAppbar extends StatelessWidget implements PreferredSizeWidget{

  final double height;
  final Widget? action;
  final Widget? leading;
  final Widget? title;
  final Color color;
  const CustomAppbar({Key? key,required this.height,
    this.leading,
    this.action,this.title,this.color=AppColor.colorWhite});


  @override
  Widget build(BuildContext context) {
    return Container(color: color,
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimen.APPBAR_HORZ_PADDING),
      child: Row(//crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          leading??Container(width: action!=null?AppDimen.APPBAR_ICON_BUTTON_SIZE:0,),
          Expanded(child: title?? Container()),
          action??Container(width: leading!=null?AppDimen.APPBAR_ICON_BUTTON_SIZE:0,),
        ],),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);

}

class DashboardAppbar extends CustomAppbar{

  final String text;
  final Color textColor;
  DashboardAppbar({Key? key,double? height,
    Widget? leading,Widget? action,this.textColor=AppColor.colorWhite,
    Color color=AppColor.colorTransparent,
    this.text=""}):super(key: key,
      height: height??AppSizer.getHeight(AppDimen.DASHBOARD_APPBAR_HEIGHT),
      leading: leading,action: action,
      color: color);

  @override
  Widget? get title {
    return CustomText(text:text,fontcolor: textColor,textAlign: TextAlign.center,
      fontsize: 16,fontweight: FontWeight.bold,);
  }


}