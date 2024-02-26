
import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/model/page_model.dart';
import 'package:chat_app_with_myysql/service/contact_service.dart';
import 'package:chat_app_with_myysql/service/repository/contact_repository.dart';
import 'package:chat_app_with_myysql/util/MyPraf.dart';
import 'package:chat_app_with_myysql/util/helper_functions.dart';
import 'package:chat_app_with_myysql/view/story_view/story_view_controller.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  final Rx<PageModel<User_model>> users = PageModel<User_model>().obs;
  final Rx<bool> isLoading = false.obs;
  final ContactRepository contactRepository = ContactRepository();
  // userIdsList
  StoryController storyController=Get.put(StoryController());
  void initialLoadApiContacts() async {
    if (users.value.data == null) {
      loadApiContacts();
    }
  }

  Future<void> loadApiContacts() async {
    if (this.users.value.data != null) {
      this.users.value = PageModel();
    }
    isLoading.value = true;
    final List<Map<String, String>> map = [];
    List<User_model> users =
        await MyContactsService().getPhoneContacts(onTask: (user) {
      map.add({
        "phoneNumber": user.phoneNumber,
      });
    });

    // AppMessage.showMessage("Contacts length: ${users.length}");
    final String token = await getToken_praf();
    await contactRepository.getApiContacts(token, map).then((list) {
      if (list != null) {
        print("-------ibrahim-------");
        print("--------myList of string------$list");
        storyController.userIdsList.clear();
        for(int i=0;i<list.data!.length;i++){
          // print(list.data![i].id);
          ///GetUserIds for get Status story
          storyController.userIdsList.add(list.data![i].id);
        }

        this.users.value = list;
      }
    });
    isLoading.value = false;
  }

  void refreshContacts() {
    users.value = PageModel();
    loadApiContacts();
  }
}
