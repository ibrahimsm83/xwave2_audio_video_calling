class StoryViewModel {
  String? sId;
  String? user;
  String? text;
  List<Media>? media;
  String? createdAt;
  int? iV;

  StoryViewModel(
      {this.sId, this.user, this.text, this.media, this.createdAt, this.iV});

  StoryViewModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    text = json['text'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['text'] = this.text;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
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

