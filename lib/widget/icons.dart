import 'package:flutter/material.dart';

abstract class ResizableIcon extends Widget{
  double get getIconSize;
}

class CustomMonoIcon extends ImageIcon implements ResizableIcon{
  CustomMonoIcon({required String icon,double? size,Color? color,}):super(
      AssetImage(icon),size: size,color: color);

  @override
  double get getIconSize => size!;
}