
import 'package:chat_app_with_myysql/resources/dimen.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/util/sizer.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
/*class CustomButton extends StatelessWidget {
  String? text;
  FontWeight? fontWeight;
  final Color? color;
  Function()? onTap;
  TextStyle? style;

  CustomButton(
      {Key? key,
        this.onTap,
        this.text,
        this.style,
        this.fontWeight = FontWeight.normal,
        this.color = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                text!,
                style: style,
                // TextStyle(color: AppColors.whiteColor, fontWeight: fontWeight),
              ),
            )),
      ),
    );
  }
}*/


class CustomButton extends StatelessWidget{

  final String text;
  final Color? textColor,bgColor;
  final void Function()? onTap;
  final double fontsize;
  double? radius;
  final EdgeInsets? padding;
  final BorderSide border;
  final bool italic;
  final FontWeight fontWeight;
  final bool enabled;

  CustomButton({this.text="",this.textColor=AppColor.colorWhite,
    this.bgColor=AppColor.colorBlack,this.onTap,this.radius,this.italic=false,
    this.fontsize=AppDimen.FONT_BUTTON,this.border=BorderSide.none,
    this.fontWeight=FontWeight.bold,this.enabled=true,
    this.padding,
  }){
    radius??=AppSizer.getRadius(AppDimen.LOGIN_BUTTON_RADIUS);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius!),border: Border.fromBorderSide(border),
        color: enabled?bgColor:AppColor.colorGrey,
      ),
      child: Material(color: AppColor.colorTransparent,
        child: InkWell(onTap: enabled?onTap:null,child: Padding(
          padding: padding??EdgeInsets.symmetric(
              vertical: AppSizer.getHeight(AppDimen.LOGIN_BUTTON_VERT_PADDING)),
          child: child,
        ),),
      ),);
  }


  @override
  Widget get child{
    return CustomText(text: text,fontcolor: textColor,fontsize: fontsize,textAlign: TextAlign.center,
      fontweight: fontWeight,);
  }

}