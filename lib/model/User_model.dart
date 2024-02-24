class User_model {
  late String id, phoneNumber, avatar, username, infoAbout;

  String? access_token;
  bool? profile_completed;

 // int? _num_id;

 // set num_id(int id) => _num_id=id;

 // int get num_id => _num_id??0;

  //int get num_id=>int.tryParse(id,radix: 16)??0;

  User_model({
    required this.id,
    required this.phoneNumber,
    required this.avatar,
    required this.username,
    required this.infoAbout,
  });

  User_model.empty({this.id="",this.phoneNumber="",this.access_token,
    this.profile_completed,this.infoAbout="",this.username="",this.avatar="",}){

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

  factory User_model.fromCallJson(Map<String, dynamic> json) {
    return User_model(
      id: json["_id"] ?? '',
      phoneNumber: json["phoneNumber"] ?? '',
      avatar: json["avatar"] ?? '',
      username: json["username"] ?? '',
      infoAbout: "",
    );
  }

  factory User_model.fromJson2(Map<String, dynamic> json,{String? access_token,}) {
    return User_model.empty(
      id: json["user_id"] ?? '',
      phoneNumber: json["phoneNumber"] ?? '',
      avatar: json["avatar"] ?? '',
      username: json["username"] ?? '',
      infoAbout: json["infoAbout"] ?? "",
      profile_completed: json["newUser"]!=null?!json["newUser"]:null,
      access_token:access_token,
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
