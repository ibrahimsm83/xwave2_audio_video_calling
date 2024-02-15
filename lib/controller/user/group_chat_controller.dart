import 'dart:developer';
import 'dart:io';
import 'package:chat_app_with_myysql/service/repository/group_chat_repository.dart';
import 'package:chat_app_with_myysql/util/MyPraf.dart';
import 'package:chat_app_with_myysql/util/helper_functions.dart';
import 'package:chat_app_with_myysql/util/navigation.dart';
import 'package:get/get.dart';

import '../../model/group_chat_users_model.dart';

class GroupChatController extends GetxController {
  var   groupsChatList=[].obs;
  final Rx<bool> isLoading=false.obs;
  final GroupChatRepository groupChatRepository = GroupChatRepository();


 void loadChatGroupsApi() async {
    final String token = await getToken_praf();
    log(token.toString());
    isLoading.value=true;
    await groupChatRepository.getApiGroups(token).then((list) {
      if (list.isNotEmpty) {
        groupsChatList.value = list;
      }
      else{
        AppMessage.showMessage("No Groups Found");
      }
    });
    isLoading.value=false;
  }

 void createChatGroupsApi({required String groupName, required List<String> usersList,required  File imageFile}) async {
    final String token = await getToken_praf();
    AppLoader.showLoader();
   var response= await groupChatRepository.createGroupApi(groupName, usersList, imageFile.path, token);
   if(response is GroupChatUsersModel){
     groupsChatList.add(response);
     AppMessage.showMessage("Group Successfully Created");
     AppNavigator.pop();
   }else{
     AppMessage.showMessage("Something wrong");
   }
    AppLoader.dismissLoader();
  }

  void refreshContacts() {
    groupsChatList.value =[];
    loadChatGroupsApi();
  }
}
