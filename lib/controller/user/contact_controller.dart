import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/model/page_model.dart';
import 'package:chat_app_with_myysql/service/contact_service.dart';
import 'package:chat_app_with_myysql/service/repository/contact_repository.dart';
import 'package:chat_app_with_myysql/util/MyPraf.dart';
import 'package:chat_app_with_myysql/util/helper_functions.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:chat_app_with_myysql/model/User_model.dart';

class ContactController extends GetxController {
  final Rx<PageModel<User_model>> users = PageModel<User_model>().obs;
final Rx<bool> isLoading=false.obs;
  final ContactRepository contactRepository = ContactRepository();

  void initialLoadApiContacts() async {
    if (users.value.data == null) {
      loadApiContacts();
    }
  }

  Future<void> loadApiContacts() async {
    isLoading.value=true;
    final List<Map<String, String>> map = [];
    List<User_model> users =
        await MyContactsService().getPhoneContacts(onTask: (user) {
      map.add({
        "phoneNumber": user.phoneNumber,
      });
    });

    AppMessage.showMessage("Contacts length: ${users.length}");
    final String token = await getToken_praf();
    await contactRepository.getApiContacts(token, map).then((list) {
      if (list != null) {
        this.users.value = list;
      }
    });
    isLoading.value=false;
  }

  void refreshContacts() {
    users.value = PageModel();
    loadApiContacts();
  }
}
