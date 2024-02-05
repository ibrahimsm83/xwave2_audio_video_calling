import 'package:chat_app_with_myysql/app/resources/myColors.dart';
import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  final Widget child;
  final bool safe;
  final Color bgColor;
  const CustomBackground({Key? key,required this.child,this.safe=true,
    this.bgColor=AppColor.bgColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(color: bgColor,
      // color: AppColor.COLOR_GREY1,
      child: SafeArea(child: child,bottom: safe,),);
  }
}