
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
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

          model.mediaType=="none"? myText(text: model.content,size: 16,fontWeight: FontWeight.w500,):GestureDetector(
            onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (childContext) => Scaffold(
            body: PhotoView(
              imageProvider: NetworkImage(model.url),
            ),
          ),
        ),
      ),
        child: Padding(
          padding: const EdgeInsets.only( right: 8.0),
          child: Image.network(model.url,fit: BoxFit.fitWidth,
          height: 300,
            width: 250,
          ),
        )),

        //Image.network(widget.media!)),
              myText(text: DateFormat('HH:mm').format(dateTime),size: 11,color: Colors.black38,)

            ],),
        ),
      ),
    );
  }
}