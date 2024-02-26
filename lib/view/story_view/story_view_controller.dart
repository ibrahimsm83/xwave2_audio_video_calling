
import 'dart:io';
import 'package:chat_app_with_myysql/service/repository/story_repository.dart';
import 'package:chat_app_with_myysql/util/MyPraf.dart';
import 'package:chat_app_with_myysql/util/helper_functions.dart';
import 'package:chat_app_with_myysql/view/story_view/get_all_status_model.dart';
import 'package:chat_app_with_myysql/view/story_view/model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class StoryController extends GetxController {

   RxList<StoryViewModel>  ownStatusList=<StoryViewModel>[].obs;
   RxList<GetAllStatusModel>  allUsersStatusList=<GetAllStatusModel>[].obs;

   List<String> userIdsList=[];
  final Rx<bool> isLoading=false.obs;
  final Rx<bool> isUserStatusLoading=false.obs;
  final Rx<bool> isOwnStatus=false.obs;
  final StoryViewRepository storyViewRepository = StoryViewRepository();


  void getStoryApi() async {
    final String token = await getToken_praf();
    isLoading.value=true;
    await storyViewRepository.getApiOwnStory(token).then((list) {
      if (list.isNotEmpty) {
        print("------my list-----");
        isOwnStatus.value=true;
        print(list);
        ownStatusList.value = list;
      }
      else{
        isOwnStatus.value=false;
       // AppMessage.showMessage("No Status Found");
      }
    });
    isLoading.value=false;
  }
///Get All Users status
  void getUserStoryApi() async {
    final String token = await getToken_praf();
    print("------ibrahim--------1");
    print(userIdsList);
    print("---------ibrahim------2");
    isUserStatusLoading.value=true;
    await storyViewRepository.getUsersStoryAPI(token,userIdsList).then((list) {
      if (list.isNotEmpty) {
        print("-----successfully Response----my list-----");
        print(list);
        allUsersStatusList.value = list;
      }
      else{
       // isOwnStatus.value=false;
        //AppMessage.showMessage("No Status Found");
      }
    });
    isUserStatusLoading.value=false;
  }

  void addStoryApi({ String? text, required List<XFile> images}) async {
    final String token = await getToken_praf();
    print("-----uploadFiles-------------");
    print(images);
    AppLoader.showLoader();
    for(int i=0;i<images.length;i++){
      var response= await storyViewRepository.createStoryApi(text, images[i].path, token,'image');
      print("-------------ibr---------");
      print(response);
      print(images[i]);

    }
    AppMessage.showMessage("Status Successfully Added");
       getStoryApi();
    AppLoader.dismissLoader();


    // if(response is GroupChatUsersModel){
    //   groupsChatList.add(response);
    //   AppMessage.showMessage("Group Successfully Created");
    //  // AppNavigator.pop();
    // }else{
    //   AppMessage.showMessage("Something wrong");
    // }

  }

  // void refreshContacts() {
  //   groupsChatList.value =[];
  //   // loadChatGroupsApi();
  // }
}
