class GetAllStatusModel {
  String? username;
  String? phoneNumber;
  String? avatar;
  List<Statuses>? statuses;

  GetAllStatusModel(
      {this.username, this.phoneNumber, this.avatar, this.statuses});

  GetAllStatusModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    phoneNumber = json['phoneNumber'];
    avatar = json['avatar'];
    if (json['statuses'] != null) {
      statuses = <Statuses>[];
      json['statuses'].forEach((v) {
        statuses!.add(new Statuses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['phoneNumber'] = this.phoneNumber;
    data['avatar'] = this.avatar;
    if (this.statuses != null) {
      data['statuses'] = this.statuses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Statuses {
  String? text;
  List<Media>? media;
  String? createdAt;

  Statuses({this.text, this.media, this.createdAt});

  Statuses.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class Media {
  String? type;
  String? url;
  String? sId;

  Media({this.type, this.url, this.sId});

  Media.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['url'] = this.url;
    data['_id'] = this.sId;
    return data;
  }
}
