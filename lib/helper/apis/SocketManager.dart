import 'dart:io';

import 'package:socket_io_client/socket_io_client.dart'as IO;

import '../MyPraf.dart';
import 'apis.dart';
IO.Socket? socket;
initSocket()async{

  String id=await getID_praf();

  socket = IO.io(apiUrl, <String, dynamic>{
    'autoConnect': false,
    'transports': ['websocket'],
  });
   socket!.connect();
   socket!.onConnect((_) {
    print('Sockert Connection established');
  });

  socket!.emit('register', id);
}
registerEvent(String event, void Function(dynamic) callback) {
  // Register events here
  if (socket == null) {
    throw Exception("Socket not initialized. Call initSocket() first.");
  }
  socket!.on(event, callback);
}
unregisterEvent(String event) {
  // Unregister events here
  if (socket == null) {
    throw Exception("Socket not initialized. Call initSocket() first.");
  }
  socket!.off(event);
}

