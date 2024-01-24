import 'package:chat_app_with_myysql/helper/myColors.dart';
import 'package:chat_app_with_myysql/helper/widgets/myText.dart';
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
