class User_model {
  late String id, phoneNumber, avatar, username, infoAbout;

  String? access_token;
  bool? profile_completed;

  User_model({
    required this.id,
    required this.phoneNumber,
    required this.avatar,
    required this.username,
    required this.infoAbout,
  });

  User_model.empty({this.id="",this.phoneNumber="",this.access_token,
    this.profile_completed}){

  }

  factory User_model.fromJson(Map<String, dynamic> json) {
    return User_model(
      id: json["_id"] ?? '',
      phoneNumber: json["phoneNumber"] ?? '',
      avatar: json["avatar"] ?? '',
      username: json["username"] ?? '',
      infoAbout: json["infoAbout"] ?? "",
    );
  }

  factory User_model.fromJson2(Map<String, dynamic> json) {
    return User_model(
      id: json["user_id"] ?? '',
      phoneNumber: json["phoneNumber"] ?? '',
      avatar: json["avatar"] ?? '',
      username: json["username"] ?? '',
      infoAbout: json["infoAbout"] ?? "",
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
