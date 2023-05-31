import 'dart:developer';
import 'dart:io';

import 'package:chat_app/allConstant/snakBar_progressIndicator.dart';
import 'package:chat_app/model/chat_userModel.dart';
import 'package:chat_app/model/userMessageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get user => auth.currentUser!;

  // for storing self information
  static late FirestoreDataModel me;

  static Future<bool> userExit() async {
    return (await firestore.collection("chat_app_user").doc(user.uid).get())
        .exists;
  }






  // for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore
        .collection("chat_app_user")
        .doc(user.uid)
        .get()
        .then((users) async {
      if (users.exists) {
        me = FirestoreDataModel.fromJson(users.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }






// for creating new user
  static Future<void> createUser() async {
    var time = DateTime.now().microsecondsSinceEpoch;
    final chatUser = FirestoreDataModel(
      name: user.displayName,
      about: "I am Qiser",
      createdAt: time.toString(),
      email: user.email,
      id: user.uid,
      image: user.photoURL,
      isOnline: false,
      lastActive: time.toString(),
      pushToken: "",
    );
    return firestore
        .collection("chat_app_user")
        .doc(user.uid)
        .set(chatUser.toJson());
  }






  // for getting all user from firestore database

  static Stream<QuerySnapshot<Map<String, dynamic>>> gettingAllUser() {
    return firestore
        .collection("chat_app_user")
        .where("id", isNotEqualTo: user.uid)
        .snapshots();
  }





// for updated user info
  static Future<void> updatedUserInfo() async {
    await firestore
        .collection("chat_app_user")
        .doc(user.uid)
        .update({"name": me.name, "about": me.about}).then((value) {
      Dialogs.showSnack("Data Updated Success");
    });
  }











// for updated profile picture
  static Future<void> updatedProfilePic(File file) async {
    // for add extension 
    final ext = file.path.split(".").last;
    log("pic extension is : ${ext}");
    // for image path in firebase storage
    final ref = storage.ref().child("ProfilePicture/${user.uid}.$ext");
    await ref
        .putFile(file, SettableMetadata(contentType: "image/$ext"))
        .then((p0) {
      log("data Transfer : ${p0.bytesTransferred / 1000} kb");
    });

    // updated downloaded image url
    me.image = await ref.getDownloadURL();
    await firestore.collection("chat_app_user").doc(user.uid).update({
      "image": me.image,
    }).then((value) {
      log("profile updated :");
    });
  }






  /// ***************  show messages *****************

  // for getting all user from firestore database

  Stream<QuerySnapshot<Map<String, dynamic>>> gettingAllUserMessages() {
    return firestore.collection("Messages").snapshots();
  }

  // useful for getting conversation id
  static String getConversationId(String id) =>
      user.uid.hashCode <= id.hashCode
          ? "${user.uid}-${id}"
          : "${id}-${user.uid}";

  // for getting all message of a specific conversation from firestore database

  static  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      FirestoreDataModel chatModel) {
    return firestore
        .collection("chats/${getConversationId(user.uid)}/messages")
        .snapshots();
  }

  static  Future<void> sendingMessage(
      FirestoreDataModel chatUser, String msg) async {
    // message sending time (also used as id)
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    // for sending message
    final Messages messages = Messages(
        msg: msg,
        toId: chatUser.id??"",
        read: "",
        type: Type.text,
        fromId: user.uid,
        send: time);

    final ref = firestore
        .collection("chats/${getConversationId(user.uid)}/message/");
    // await ref.doc(time).set(messages.toJson());
    await ref.doc(time).set(messages.toJson());
  }
    // for sending message



}