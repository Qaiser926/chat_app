class FirestoreDataModel {
  String? image;
  String? about;
  String? name;
  String? createdAt;
  bool? isOnline;
  String? lastActive;
  String? id;
  String? pushToken;
  String? email;

  FirestoreDataModel(
      {this.image,
      this.about,
      this.name,
      this.createdAt,
      this.isOnline,
      this.lastActive,
      this.id,
      this.pushToken,
      this.email});

  FirestoreDataModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    about = json['about'];
    name = json['name'];
    createdAt = json['created_at'];
    isOnline = json['is_online'];
    lastActive = json['last_active'];
    id = json['id'];
    pushToken = json['push_token'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['about'] = this.about;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['is_online'] = this.isOnline;
    data['last_active'] = this.lastActive;
    data['id'] = this.id;
    data['push_token'] = this.pushToken;
    data['email'] = this.email;
    return data;
  }
}
