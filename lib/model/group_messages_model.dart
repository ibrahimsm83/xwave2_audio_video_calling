class GroupMessagesModel {
  List<GroupMessages>? groupMessages;
  String? groupUpdatedAt;

  GroupMessagesModel({this.groupMessages, this.groupUpdatedAt});

  GroupMessagesModel.fromJson(Map<String, dynamic> json) {
    if (json['groupMessages'] != null) {
      groupMessages = <GroupMessages>[];
      json['groupMessages'].forEach((v) {
        groupMessages!.add(new GroupMessages.fromJson(v));
      });
    }
    groupUpdatedAt = json['groupUpdatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.groupMessages != null) {
      data['groupMessages'] =
          this.groupMessages!.map((v) => v.toJson()).toList();
    }
    data['groupUpdatedAt'] = this.groupUpdatedAt;
    return data;
  }
}

class GroupMessages {
  Media? media;
  String? sId;
  Sender? sender;
  String? chat;
  String? chatType;
  String? content;
  String? deliveryStatus;
  String? createdAt;
  String? updatedAt;
  int? iV;

  GroupMessages(
      {this.media,
        this.sId,
        this.sender,
        this.chat,
        this.chatType,
        this.content,
        this.deliveryStatus,
        this.createdAt,
        this.updatedAt,
        this.iV});

  GroupMessages.fromJson(Map<String, dynamic> json) {
    media = json['media'] != null ? new Media.fromJson(json['media']) : null;
    sId = json['_id'];
    sender =
    json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    chat = json['chat'];
    chatType = json['chatType'];
    content = json['content'];
    deliveryStatus = json['deliveryStatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.media != null) {
      data['media'] = this.media!.toJson();
    }
    data['_id'] = this.sId;
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    data['chat'] = this.chat;
    data['chatType'] = this.chatType;
    data['content'] = this.content;
    data['deliveryStatus'] = this.deliveryStatus;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Media {
  String? type;
  String? url;

  Media({this.type, this.url});

  Media.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['url'] = this.url;
    return data;
  }
}

class Sender {
  String? sId;
  String? phoneNumber;
  String? username;

  Sender({this.sId, this.phoneNumber, this.username});

  Sender.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    phoneNumber = json['phoneNumber'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['phoneNumber'] = this.phoneNumber;
    data['username'] = this.username;
    return data;
  }
}
