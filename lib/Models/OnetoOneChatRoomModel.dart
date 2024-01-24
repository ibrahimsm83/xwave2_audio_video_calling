import 'package:chat_app_with_myysql/Models/User_model.dart';

class OnetoOneChatRoomModel{

  late String chatID,time,msg;
  late User_model user_model;

  OnetoOneChatRoomModel({required this.chatID, required this.time, required this.msg, required this.user_model});

  factory OnetoOneChatRoomModel.fromJson(Map<String, dynamic> json) {
    return OnetoOneChatRoomModel(
      chatID: json["chatID"]??'',
      time: json["time"]??'',
      msg: json["msg"]??'',
      user_model: User_model.fromJson(json["user_model"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "chatID": this.chatID,
      "time": this.time,
      "msg": this.msg,
      "user_model": this.user_model.toJson(),
    };
  }

//
}