import 'package:chat_app_with_myysql/app/resources/myColors.dart';
import 'package:chat_app_with_myysql/widget/common.dart';
import 'package:flutter/material.dart';

class CircularPic extends StatelessWidget {
  final double diameter;
  final String? image;
  final BorderSide border;
  final ImageType imageType;
  const CircularPic({Key? key,required this.diameter, this.image,
    this.imageType=ImageType.TYPE_NETWORK,
    this.border = const BorderSide(width: 0,
        color: AppColor.colorTransparent)}):super(key: key,);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle, border: Border.fromBorderSide(border),),
      child: ClipOval(
          child: CustomImage(
            image: image,imageType: imageType,fit: BoxFit.cover,
          )),
    );
  }
}