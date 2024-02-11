import 'package:chat_app_with_myysql/model/User_model.dart';

class VoiceCall{

  static int CALL_ID=1;

  static const STATUS_IDLE="CALL_IDLE",STATUS_CONNECTING="CALL_CONNECTING",
      STATUS_CONNECTED="CALL_CONNECTED",STATUS_ENDED="CALL_ENDED";

  static const TYPE_AUDIO="audio",TYPE_VIDEO="video";
  static const CATEGORY_SINGLE="one_to_one",CATEGORY_GROUP="group";
  static const SIDE_DIALER=0,SIDE_RECEIVER=1;


  String? id;
  final int? side;
  final User_model? dialer,receiver;
  //final String? type;
  String? type,category;
  String? token,channel;
  String? status;


  VoiceCall({this.id,this.dialer,this.receiver,this.type,this.side,this.token,this.channel,
    this.category, this.status,});


  factory VoiceCall.fromMap(Map map,{User_model? dialer,User_model? receiver,int? side}){
    var channel=map["channel"];
    return VoiceCall(id:map["call_id"].toString(), channel: channel["channel"], token: channel["token"],
      dialer: dialer,side: side,type: map["type"],status: map["call_status"],category: map["call_type"],
      receiver: receiver,);
  }

  bool get isDialed => side==SIDE_DIALER;

  bool get isIdle => status==VoiceCall.STATUS_IDLE;
  bool get isConnecting => status==VoiceCall.STATUS_CONNECTING;
  bool get isConnected => status==VoiceCall.STATUS_CONNECTED;
  bool get isEnded => status==VoiceCall.STATUS_ENDED;

  bool get isGroup => category==VoiceCall.CATEGORY_GROUP;

  User_model get user=>isDialed?dialer!:receiver!;

  User_model get guest=>isDialed?receiver!:dialer!;

}