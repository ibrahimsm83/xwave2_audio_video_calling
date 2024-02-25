import 'dart:convert';

import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/model/page_model.dart';
import 'package:chat_app_with_myysql/model/voice_call.dart';
import 'package:chat_app_with_myysql/service/network.dart';
import 'package:chat_app_with_myysql/util/config.dart';
import 'package:chat_app_with_myysql/util/helper_functions.dart';

class CallRepository {

  Future<VoiceCall?> makeCall(String token, String receiver, String type) async {
    VoiceCall? user;
    final String url = AppConfig.DIRECTORY + (type==VoiceCall.TYPE_AUDIO?"user/startAudioCall":
    "user/startVidoCall");
    print("makeCall url: $url");
    final map = {"receiverId": receiver,};
    print("makeCall map: $map");
    await Network().post(
      url,
      map,
      // headers: {'Content-type': 'application/json'},
      headers: {"Authorization":"Bearer $token"},
      onSuccess: (val) {
        print("makeCall response: $val");
        var map = jsonDecode(val);
       // bool status = map["status"] == Network.STATUS_SUCCESS;
        var data=map["data"];
        user=VoiceCall.fromMap(data);
        //AppMessage.showMessage(map["message"].toString());
      },
    );
    return user;
  }

  Future<bool> callAction(String token, String call_id,String action,) async {
    bool user=false;
    const String url = AppConfig.DIRECTORY + "user/handleCallActions";
    print("callAction url: $url");
    final map = {"callId": call_id,"action":action,};
    print("callAction map: $map");
    await Network().post(
      url,
      map,
      // headers: {'Content-type': 'application/json'},
      headers: {"Authorization":"Bearer $token"},
      onSuccess: (val) {
        print("callAction response: $val");
        var map = jsonDecode(val);
        user = map["status"] == Network.STATUS_SUCCESS;
      },
    );
    return user;
  }

  Future<bool> inviteCallParticipants(String token, String call_id,List<String> ids,) async {
    bool user=false;
    const String url = AppConfig.DIRECTORY + "user/addParticipantToCall";
    print("inviteCallParticipants url: $url");
    final map = jsonEncode({"callId": call_id,"participantsToAdd":ids,});
    print("inviteCallParticipants map: $map");
    await Network().post(
      url,
      map,
      headers: {"Authorization":"Bearer $token",'Content-type': 'application/json'},
      onSuccess: (val) {
        print("inviteCallParticipants response: $val");
        var map = jsonDecode(val);
        user = map["status"] == Network.STATUS_SUCCESS;
        AppMessage.showMessage(map["message"].toString());
      },
    );
    return user;
  }

  Future<PageModel<VoiceCall>?> getCallHistory(
      String token,String user_id,) async {
    PageModel<VoiceCall>? users;
    const String url = AppConfig.DIRECTORY + "user/getCall";
    print("getCallHistory url: $url");
    await Network().get(url, headers: {
      "Authorization": "Bearer ${token}",
    }, onSuccess: (val) {
      print("getCallHistory response: ${val}");
      var map = jsonDecode(val);
   //   if (map["status"] == Network.STATUS_SUCCESS) {
        var data = map["callLogs"];
        List list = data;
        users = PageModel(
          data: list.map<VoiceCall>((cat) {
            User_model? dialer,receiver;
            int side=VoiceCall.SIDE_RECEIVER;

            List participants=cat["participants"];
            final Map<String,User_model> map={};
            for(var part in participants){
              var user=User_model.fromCallJson2(part);
              if(part["role"]=="initiator"){
                dialer=user;
                if(dialer.id==user_id){
                  side=VoiceCall.SIDE_DIALER;
                }
              }
              else{
                if(cat["callType"]==VoiceCall.CATEGORY_SINGLE){
                  receiver=user;
                }
                map[user.id]=user;
              }
            }
/*            var map=Map<String,User_model>.fromIterable(cat["participants"],key: (val){
              return val["userId"];
            },value: (val){
              var user=User_model.fromCallJson2(val);
              if(val["role"]=="initiator"){
                dialer=user;
                if(dialer!.id==user_id){
                  side=VoiceCall.SIDE_DIALER;
                }
              }
              else if(cat["callType"]==VoiceCall.CATEGORY_SINGLE
                  && val["role"]=="receiver"){
                receiver=user;
              }
              return user;
            });*/
            return VoiceCall.fromMap2(cat,participants: map,
                dialer: dialer,receiver: receiver,side: side);
          }).toList(),
        );
  //    }
    });
    return users;
  }

}
