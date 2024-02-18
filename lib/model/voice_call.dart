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
  User_model? _user;
  //final String? type;
  String? type,category;
  String? token,channel;
  String? status;

  Map<String,User_model> participants={};

  VoiceCall({this.id,this.dialer,this.receiver,this.type,this.side,this.token,this.channel,
    this.category, this.status,User_model? user,this.participants=const {}}){
    _user=user;
  }

  List<User_model> getParticipants(){
    return participants.values.toList();
  }

  User_model? getParticipant(String id){
    return participants[id];
  }

  factory VoiceCall.fromMap(Map map,{int? side,User_model? dialer,User_model? receiver,
    String? category,String? status,String? type,User_model? user,
    Map<String,User_model> participants=const {}}){
   // var channel=map["channel"];
    return VoiceCall(id:map["callId"], token: map["agoraToken"],
      channel: map["channelName"],side: side,dialer: dialer,receiver: receiver,
        status: status,type: type,
        participants: participants,
        category: category,user: user);
  }

  Map<String,dynamic> toJson(){
    return {
      "callId":id,"agoraToken":token,"channelName":channel,
    };
  }

  bool get isDialed => side==SIDE_DIALER;

  bool get isIdle => status==VoiceCall.STATUS_IDLE;
  bool get isConnecting => status==VoiceCall.STATUS_CONNECTING;
  bool get isConnected => status==VoiceCall.STATUS_CONNECTED;
  bool get isEnded => status==VoiceCall.STATUS_ENDED;

  bool get isGroup => category==VoiceCall.CATEGORY_GROUP;

  bool get isVideo => type==VoiceCall.TYPE_VIDEO;

  User_model get user=>_user??(isDialed?dialer!:receiver!);

  User_model get guest=>isDialed?receiver!:dialer!;

}

class CallSetting{

}