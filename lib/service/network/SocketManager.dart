import 'dart:io';

import 'package:chat_app_with_myysql/controller/user/controller.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart'as IO;

import '../../util/MyPraf.dart';
import 'apis.dart';
//IO.Socket? socket;
/*initSocket()async{

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
}*/
registerEvent(String event, void Function(dynamic) callback) {
  // Register events here
 /* if (socket == null) {
    throw Exception("Socket not initialized. Call initSocket() first.");
  }*/
  final DashboardController dashboardController=Get.find<DashboardController>();

  var socket=dashboardController.socketService.socket;
  socket.on(event, callback);
}
unregisterEvent(String event) {
  // Unregister events here
  /*if (socket == null) {
    throw Exception("Socket not initialized. Call initSocket() first.");
  }*/
  final DashboardController dashboardController=Get.find<DashboardController>();
  var socket=dashboardController.socketService.socket;
 // dashboardController.socketService.removeEvents([event]);
  socket.off(event);
}

