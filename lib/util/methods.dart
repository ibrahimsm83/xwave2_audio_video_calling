import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

next_page(var page){
  Get.to(page,transition: Transition.fadeIn,duration: Duration(seconds: 1));
}
close_current_go_next_page(var page){
  Get.off(page,transition: Transition.fadeIn,duration: Duration(seconds: 1));
}
close_all_go_next_page(var page){
  Get.offAll(page,transition: Transition.fadeIn,duration: Duration(seconds: 1));
}

scrolList(ScrollController scrollController)async{
  Future.delayed(Duration(seconds: 1)).then((value) {

    if(scrollController.hasClients) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 1), curve: Curves.easeInOut);
    }
  });
}
