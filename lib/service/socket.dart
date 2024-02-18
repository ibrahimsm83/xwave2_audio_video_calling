import 'package:chat_app_with_myysql/model/interface.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  //static SocketService? _instance;

  IO.Socket? _socket;
  SocketMessageHandler? _handler;

  final String url;

  // SocketService._();
  IO.Socket get socket => _socket!;

  SocketService(
    this.url,
  );

  /*factory SocketService() {
    return _instance??=SocketService._();
  }*/

/*  void setMessageHandler(MessageHandler handler){
    _handler=handler;
  }*/

  bool get isConnected => _socket!.connected;

  void connect(SocketMessageHandler handler, {List<String> events = const []}) {
    print("socket url: $url");
    _socket = IO.io(
        url,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());

    _handler = handler;
    //final String event=SocketEvent.GET_MESSAGE;

    _socket!.onConnect(_handler!.onConnect);
    _socket!.onDisconnect(_handler!.onDisconnect);
    _socket!.onConnectError(_handler!.onConnectionError);
    _socket!.onError(_handler!.onError);

    addEvents(events);

    _socket!.connect();
  }

  void emitData(String event, dynamic data) {
    _socket!.emit(event, data);
  }

  void addEvents(List<String> events) {
    events.forEach((event) {
      addEvent(event);
    });
  }

  void removeEvents(List<String> events) {
    events.forEach((event) {
      removeEvent(event);
    });
  }

  void addEvent(String event){
    _socket!.on(event, (data) {
      _handler!.onEvent(event, data);
    });
  }

  void removeEvent(String event){
    _socket!.off(event);
  }

  void disconnect() {
    _socket!.dispose();
    // _socket!.disconnect();
    // _socket!.close();
  }
}

class SocketEvent {
  static const REGISTER = 'register';
  static const AUDIO_CALL = "incoming_audio_call",
      VIDEO_CALL = "incoming_video_call",PARTICIPANTS_ADDED="participants_added",
      HANDLE_CALL_EVENT="handleCall";
      //CALL_ACCEPTED="call_accepted",
    //  CALL_REJECTED="call_rejected",CALL_ENDED="call_ended"

  static const CHAT_LIST_UPDATE="chatListUpdate";

  ///GroupChat
  //Listner for room join is
  static const GROUP_CHAT_ROOM_JOIN="joinRoom";
  static const NEW_GROUP_MESSAGE="newGroupMessage";

}
