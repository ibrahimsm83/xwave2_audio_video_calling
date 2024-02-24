class GroupChatUsersModel {
  String id = "-1";
  String chatName = "";
  String groupAvatar = "";
  bool isGroupChat = false;
  String createdAt = "";
  String updatedAt = "";
  int userCount = -1;

  GroupChatUsersModel.empty();

  GroupChatUsersModel.fromJson(Map<String, dynamic> json) {
    id = json["_id"] ?? "";
    chatName = json["chatName"] ?? "";
    groupAvatar = json["GroupAvatar"] ?? "";
    isGroupChat = json["isGroupChat"] ?? false;
    createdAt = json["createdAt"] ?? "";
    updatedAt = json["updatedAt"] ?? "";
    userCount = json["userCount"] ?? -1;
  }

  @override
  String toString() {
    return 'GroupChatUsersModel{id: $id, chatName: $chatName, groupAvatar: $groupAvatar, isGroupChat: $isGroupChat, createdAt: $createdAt, updatedAt: $updatedAt, userCount: $userCount}';
  }
}
