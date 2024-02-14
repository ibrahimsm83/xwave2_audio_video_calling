abstract class FCMCallBack{
  void onNotificationTap(Map data);
  void onForeground(Map map);
//void onBackgroundTap(Map data);
}

abstract class NotificationCallBack{
  void onLocalNotificationTap(String payload);
}

abstract class CallEventHandler{
  void onUserJoined(int id);
  void onUserLeave(int id);
  void onSelfJoin();
}

mixin SocketMessageHandler{
  void onConnect(data){
    print("socket connected: $data");
  }
  void onDisconnect(data){
    print("socket disconnected: $data");
  }

  void onConnectionError(data){
    print("socket connection error: $data");
  }

  void onError(data){
    print("socket error: $data");
  }

  void onEvent(String name,data){
    print("socket event triggered: ${name} with ${data}");
  }

}