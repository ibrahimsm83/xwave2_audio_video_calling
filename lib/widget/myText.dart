import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/util/sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class myText extends StatelessWidget {
  String text;
  Color color;
  double size;
  FontWeight fontWeight;
  myText({super.key,required this.text,this.color=Colors.black,
    this.size=13,this.fontWeight=FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Text(text,style: TextStyle(color: color,fontSize: size,fontWeight: fontWeight),);
  }
}


// use this for future
class CustomText extends StatelessWidget {
  final String text;
  final Color? fontcolor;
  final TextAlign textAlign;
  final FontWeight fontweight;
  final bool underlined, linethrough;
  final String? fontFamily;
  final double fontsize;
  final double? line_spacing;
  final int? max_lines;
  final double textScaleFactor;
  final bool isSp, italic;
  //final double minfontsize,scalefactor,fontsize;

  const CustomText({
    Key? key,
    this.text = "",
    this.fontcolor = AppColor.colorBlack,
    this.fontsize = 15,
    this.textAlign = TextAlign.start,
    this.fontweight = FontWeight.normal,
    this.underlined = false,
    this.italic = false,
    this.line_spacing = 1.2,
    this.isSp = true,
    this.max_lines, //double line_spacing=1.2,
    this.fontFamily,
    this.linethrough = false,
    this.textScaleFactor = 1.0,
    // this.minfontsize=10,//this.scalefactor,
  }):super(key: key,);

  @override
  Widget build(BuildContext context) {
    //  double text_scale_factor=(media.size.width*media.size.height)/328190;
    //print("new text scale factor: ${text_scale_factor}");
    return Text(
      text, //textScaleFactor: textScaleFactor,
      maxLines: max_lines,
      overflow:
      max_lines != null ? TextOverflow.ellipsis : TextOverflow.visible,
      textAlign: textAlign,
      style: TextStyle(
        color: fontcolor, fontWeight: fontweight, height: line_spacing,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        fontSize: isSp ? AppSizer.getFontSize(fontsize) : fontsize,
        // fontSize: (fontsize*0.89).sp,
        fontFamily: fontFamily,
        decorationThickness: 2.0,
        decoration: underlined
            ? TextDecoration.underline
            : (linethrough ? TextDecoration.lineThrough : TextDecoration.none),
      ),
    );
  }
}
