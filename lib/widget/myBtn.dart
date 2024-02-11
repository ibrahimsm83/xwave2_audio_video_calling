
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/widget/common.dart';
import 'package:chat_app_with_myysql/widget/icons.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class myBtn extends StatelessWidget {
  GestureDetector gestureDetector;
  String text;
  double width,height;
  Color color;
  

   myBtn({super.key,required this.text,this.width=200,this.height=40,required this.color,required this.gestureDetector});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: gestureDetector.onTap, child: myText(text: text,fontWeight: FontWeight.bold,size: 15),style: ElevatedButton.styleFrom(
      backgroundColor: color,fixedSize: Size(width, height)
    ),);
  }
}


class CircularButton extends StatelessWidget {
  final double diameter;
  final String? icon;
  final Color color, bgColor;
  final void Function()? onTap;
  final BorderSide border;
  final double elevation;
  final double ratio;
  final bool isSvg;
  const CircularButton({
    Key? key,
    required this.diameter,
    required this.icon,this.isSvg=true,
    this.bgColor = AppColor.colorWhite,
    this.elevation = 0,
    this.ratio = 0.4,
    this.border = const BorderSide(width: 0, color: AppColor.colorTransparent),
    this.onTap,
    this.color = AppColor.colorBlack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
        radius: diameter / 2,
        elevation: elevation,
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
              border: Border.fromBorderSide(border)),
          child: Material(
            color: AppColor.colorTransparent,
            child: InkWell(onTap: onTap, child: Center(child: buildChild())),
          ),
        ));
  }

  Widget buildChild() {
    return icon!=null?CustomMonoIcon(
      size: diameter * ratio,
      icon: icon!,
      color: color,
      isSvg: isSvg,
    ):Container();
  }
}