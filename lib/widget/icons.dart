import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract class ResizableIcon extends Widget{
  double get getIconSize;
}

class CustomMonoIcon extends StatelessWidget implements ResizableIcon{

  final double? size;
  final Color? color;
  final String icon;
  final bool isSvg;
  const CustomMonoIcon({super.key, required this.icon,required this.size,
    this.color=AppColor.colorBlack,
    this.isSvg=false,});

  @override
  Widget build(BuildContext context) {
    return isSvg?SvgPicture.asset(icon,width: size,height: size,color: color,)
        :ImageIcon(AssetImage(icon),size: size,color: color);
  }

  @override
  double get getIconSize => size!;
}