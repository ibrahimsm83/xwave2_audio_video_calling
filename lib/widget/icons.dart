import 'package:chat_app_with_myysql/resources/asset_path.dart';
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
    return isSvg?SvgPicture.asset(icon,width: size,height: size,color: color,
      fit: BoxFit.contain,)
        :ImageIcon(AssetImage(icon),size: size,color: color);
  }

  @override
  double get getIconSize => size!;
}

class IconMoreVert extends CustomMonoIcon{
  const IconMoreVert({Key? key,double? size,Color? color,}):super(key: key,
      icon: AssetPath.ICON_MORE_VERT,size: size,color: color,isSvg: true);
}

class IconBack extends CustomMonoIcon{
  const IconBack({Key? key,double? size,Color? color,}):super(key: key,
      icon: AssetPath.ICON_BACK,size: size,color: color,isSvg: true);
}