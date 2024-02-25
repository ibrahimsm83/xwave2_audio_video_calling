class ChatModel {
  Media? media;
  String? sId;
  Sender? sender;
  Chat? chat;
  Sender? receiver;
  String? chatType;
  Null? link;
  Null? contactNumber;
  String? content;
  String? deliveryStatus;
  QuotedMessage? quotedMessage;
  String? createdAt;
  int? iV;

  ChatModel(
      {this.media,
        this.sId,
        this.sender,
        this.chat,
        this.receiver,
        this.chatType,
        this.link,
        this.contactNumber,
        this.content,
        this.deliveryStatus,
        this.quotedMessage,
        this.createdAt,
        this.iV});

  ChatModel.fromJson(Map<String, dynamic> json) {
    media = json['media'] != null ? new Media.fromJson(json['media']) : null;
    sId = json['_id'];
    sender =
    json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    chat = json['chat'] != null ? new Chat.fromJson(json['chat']) : null;
    receiver =
    json['receiver'] != null ? new Sender.fromJson(json['receiver']) : null;
    chatType = json['chatType'];
    link = json['link'];
    contactNumber = json['contactNumber'];
    content = json['content'];
    deliveryStatus = json['deliveryStatus'];
    quotedMessage = json['quotedMessage'] != null
        ? new QuotedMessage.fromJson(json['quotedMessage'])
        : null;
    createdAt = json['createdAt'];
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
    if (this.chat != null) {
      data['chat'] = this.chat!.toJson();
    }
    if (this.receiver != null) {
      data['receiver'] = this.receiver!.toJson();
    }
    data['chatType'] = this.chatType;
    data['link'] = this.link;
    data['contactNumber'] = this.contactNumber;
    data['content'] = this.content;
    data['deliveryStatus'] = this.deliveryStatus;
    if (this.quotedMessage != null) {
      data['quotedMessage'] = this.quotedMessage!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Media {
  String? type;
  String? url;

  Media({this.type,this.url});

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

class Chat {
  String? sId;
  String? createdAt;
  int? iV;

  Chat({this.sId, this.createdAt, this.iV});

  Chat.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class QuotedMessage {
  Media? media;
  String? sId;
  String? sender;
  String? chat;
  String? receiver;
  String? chatType;
  Null? link;
  Null? contactNumber;
  String? content;
  bool? deletedForSender;
  String? deliveryStatus;
  bool? deletedForEveryone;
  String? createdAt;
  String? updatedAt;
  int? iV;

  QuotedMessage(
      {this.media,
        this.sId,
        this.sender,
        this.chat,
        this.receiver,
        this.chatType,
        this.link,
        this.contactNumber,
        this.content,
        this.deletedForSender,
        this.deliveryStatus,
        this.deletedForEveryone,
        this.createdAt,
        this.updatedAt,
        this.iV});

  QuotedMessage.fromJson(Map<String, dynamic> json) {
    media = json['media'] != null ? new Media.fromJson(json['media']) : null;
    sId = json['_id'];
    sender = json['sender'];
    chat = json['chat'];
    receiver = json['receiver'];
    chatType = json['chatType'];
    link = json['link'];
    contactNumber = json['contactNumber'];
    content = json['content'];
    deletedForSender = json['deletedForSender'];
    deliveryStatus = json['deliveryStatus'];
    deletedForEveryone = json['deletedForEveryone'];
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
    data['sender'] = this.sender;
    data['chat'] = this.chat;
    data['receiver'] = this.receiver;
    data['chatType'] = this.chatType;
    data['link'] = this.link;
    data['contactNumber'] = this.contactNumber;
    data['content'] = this.content;
    data['deletedForSender'] = this.deletedForSender;
    data['deliveryStatus'] = this.deliveryStatus;
    data['deletedForEveryone'] = this.deletedForEveryone;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
