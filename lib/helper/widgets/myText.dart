import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class myText extends StatelessWidget {
  String text;
  Color color;
  double size;
  FontWeight fontWeight;
  myText({super.key,required this.text,this.color=Colors.black,this.size=13,this.fontWeight=FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Text(text,style: TextStyle(color: color,fontSize: size,fontWeight: fontWeight),);
  }
}
