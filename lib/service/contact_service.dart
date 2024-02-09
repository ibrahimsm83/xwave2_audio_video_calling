import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/util/helper_functions.dart';
import 'package:contacts_service/contacts_service.dart';

class MyContactsService {
  static MyContactsService? _instance;

  MyContactsService._();

  factory MyContactsService() {
    return _instance ??= MyContactsService._();
  }

  Future<List<User_model>> getPhoneContacts({
    void Function(User_model user)? onTask,
  }) async {
    var list = await ContactsService.getContacts();
    final List<User_model> users = [];
    for (int i = 0; i < list.length; i++) {
      try {
        var contact = list[i];
        String phone = contact.phones![0].value!;
        phone = phone.replaceAll(' ', '');
        var user = User_model.empty(phoneNumber: phone);
        users.add(user);
        onTask?.call(user);
      } catch (ex) {
       // AppMessage.showMessage(ex.toString());
      }
    }
    return users;
  }
}
