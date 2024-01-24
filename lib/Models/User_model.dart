class User_model{
  late String id,phoneNumber,avatar,username;

  User_model({required this.id, required this.phoneNumber, required this.avatar, required this.username});

  factory User_model.fromJson(Map<String, dynamic> json) {
    return User_model(
      id: json["_id"]??'',
      phoneNumber: json["phoneNumber"]??'',
      avatar: json["avatar"]??'',
      username: json["username"]??'',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": this.id,
      "phoneNumber": this.phoneNumber,
      "avatar": this.avatar,
      "username": this.username,
    };
  }

//
}