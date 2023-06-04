// ignore_for_file: file_names

class FirestoreDataModel {
late  String image;
late  String about;
late  String name;
late  String createdAt;
late  bool isOnline;
late  String lastActive;
late  String id;
late  String pushToken;
late  String email;

  FirestoreDataModel(
      {
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.lastActive,
    required this.id,
    required this.pushToken,
    required this.email});

  FirestoreDataModel.fromJson(Map<String, dynamic> json) {
    image = json['image']??"";
    about = json['about']??"";
    name = json['name']??"";
    createdAt = json['created_at']??"";
    isOnline = json['is_online']??"";
    lastActive = json['last_active']??"";
    id = json['id']??"";
    pushToken = json['push_token']??"";
    email = json['email']??"";
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals, unnecessary_new
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['last_active'] = lastActive;
    data['id'] = id;
    data['push_token'] = pushToken;
    data['email'] = email;
    return data;
  }
}
