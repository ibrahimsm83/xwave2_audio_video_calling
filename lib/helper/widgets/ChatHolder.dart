
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Models/ChatModel.dart';
import 'myText.dart';

class chatHolder extends StatelessWidget {
  final ChatModel model;
  final Color chatBoxColor;
  const chatHolder({super.key, required this.model, required this.chatBoxColor});

  @override
  Widget build(BuildContext context) {

    DateTime dateTime=DateTime.parse(model.time);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          color: chatBoxColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              myText(text: model.content,size: 16,fontWeight: FontWeight.w500,),
              myText(text: DateFormat('HH:mm').format(dateTime),size: 11,color: Colors.black38,)

            ],),
        ),
      ),
    );
  }
}