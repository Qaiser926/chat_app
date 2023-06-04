import 'dart:developer';
import 'dart:io';

import 'package:chat_app/allConstant/snakBar_progressIndicator.dart';
import 'package:chat_app/model/chat_userModel.dart';
import 'package:chat_app/model/userMessageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Apis {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get user => auth.currentUser!;

  // for storing self information
  // static late FirestoreDataModel me;

  // for storing self information
  static FirestoreDataModel me = FirestoreDataModel(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using We Chat!",
      image: user.photoURL.toString(),
      createdAt: '',
      isOnline: false,
      lastActive: '',
      pushToken: '');    
      
  // for checking if user exists or not?
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
    var time = DateTime.now().microsecondsSinceEpoch.toString();
    final chatUser = FirestoreDataModel(
      name: user.displayName??"",
      about: "I am Qaiser",
      createdAt: time,
      email: user.email??"",
      id: user.uid,
      image: user.photoURL??"",
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
    // ignore: unnecessary_brace_in_string_interps
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

 static  Stream<QuerySnapshot<Map<String, dynamic>>> gettingAllUserMessages() {
    return firestore.collection("Messages").snapshots();
  }

  // useful for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';


  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      FirestoreDataModel user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        // .orderBy('sent', descending: true)
        .snapshots();
  }

  // for sending message
  static Future<void> sendMessage(
      FirestoreDataModel chatUser, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();


    //message to send
    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        send:time

    );
    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }
   
    // for read status of message
    static Future<void> UpdateMessageReadStatus(Message message)async{
      firestore.collection("chats/${getConversationID(message.fromId)}/messages/")
      .doc(message.send)
      .update({"read":DateTime.now().millisecondsSinceEpoch.toString()});
    }

  // for getLastSeenMessage 
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastSeenMessage(
      FirestoreDataModel user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('send', descending: true)
        .limit(1)
        .snapshots();
  }

}