import 'dart:convert';

import 'package:chat_app_with_myysql/model/voice_call.dart';
import 'package:chat_app_with_myysql/service/network.dart';
import 'package:chat_app_with_myysql/util/config.dart';

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
}
