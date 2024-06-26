
import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/util/datetime.dart';

class ChatModel{
  late String content,mediaType,url,lati,longi,time;
  late User_model sender,receiver;

  ChatModel(
      {required this.content,
      required this.mediaType,
      required this.url,
      required this.lati,
      required this.longi,
      required this.time,
      required this.sender,
      required this.receiver});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      content: json["content"]??'',
      mediaType: json["mediaType"]??'',
      url: json["url"]??'',
      lati: json["lati"]??'',
      longi: json["longi"]??'',
      //time: json["time"]??'',
      time: DateTimeManager.getFormattedDateTime(json['time'],isutc: true,
          format: DateTimeManager.dateTimeFormat,
          format2: DateTimeManager.dateTimeFormat24_2),
      sender: User_model.fromJson(json["sender"]),
      receiver: json["receiver"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "content": this.content,
      "mediaType": this.mediaType,
      "url": this.url,
      "lati": this.lati,
      "longi": this.longi,
      "time": this.time,
      "sender": this.sender.toJson(),
      "receiver": this.receiver.toJson(),
    };
  }

//
}