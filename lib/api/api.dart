// ignore_for_file: unnecessary_brace_in_string_interps, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app/allConstant/snakBar_progressIndicator.dart';
import 'package:chat_app/model/chat_userModel.dart';
import 'package:chat_app/model/userMessageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

class Apis {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get user => auth.currentUser!;

  // firebase message to push firebase message
  static FirebaseMessaging fMessage = FirebaseMessaging.instance;

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

  // for add new user for our conversation
  static Future<bool> addNewUser(String email) async {
    final data = await firestore
        .collection("chat_app_user")
        .where("email", isEqualTo: email)
        .get();
    log("data: ${data.docs}");

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      firestore
          .collection("chat_app_user")
          .doc(user.uid)
          .collection("my_user")
          .doc(data.docs.first.id)
          .set({});
      log("user exit : ${data.docs.first.data()}");
      return true;
    } else {
      return false;
    }
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
        await getFirebaseMessaging();
        // for setting user active or not
        Apis.updatedStatus(true);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

// for creating new user
  static Future<void> createUser() async {
    var time = DateTime.now().microsecondsSinceEpoch.toString();
    final chatUser = FirestoreDataModel(
      name: user.displayName ?? "",
      about: "I am Qaiser",
      createdAt: time,
      email: user.email ?? "",
      id: user.uid,
      image: user.photoURL ?? "",
      isOnline: false,
      lastActive: time.toString(),
      pushToken: "",
    );
    return firestore
        .collection("chat_app_user")
        .doc(user.uid)
        .set(chatUser.toJson());
  }

// for cloud firebase message (push notification)

  static Future<void> getFirebaseMessaging() async {
    await fMessage.requestPermission();
    await fMessage.getToken().then((token) {
      if (token != null) {
        me.pushToken = token;
        log("My token : ${token}");
      }
    });
    // for foreground push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }
    });
  }

  // for getting all user from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> gettingAllUser(List<String> userId ) {
    return firestore
        .collection("chat_app_user")
        .where('id',whereIn: userId)
        // .where("id", isNotEqualTo: user.uid)
        .snapshots();
  }

// for add an user to my user when first message is send 
  
  static Future<void> sendFirstMessage(FirestoreDataModel chatUser, String msg, Type type)async{
    await firestore.collection("chat_app_user").doc(chatUser.id).collection("my_user").doc(user.uid).set({}).then((value) => sendMessage(chatUser, msg, type));
  }

  // for getting id's for known user from firebase firestore 
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUserId() {
    return firestore
        .collection("chat_app_user")
        .doc(user.uid)
        .collection("my_user")
        // .where("id", isNotEqualTo: user.uid)
        .snapshots();
  }

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      FirestoreDataModel userModel) {
    return firestore
        .collection("chat_app_user")
        .where("id", isEqualTo: userModel.id)
        .snapshots();
  }

  /// **************** updated status *******************

  // online or last user status
  static Future<void> updatedStatus(bool isOnline) async {
    return firestore.collection("chat_app_user").doc(user.uid).update({
      "is_online": isOnline,
      "last_active": DateTime.now().millisecondsSinceEpoch.toString(),
      // token add ho jaye  ga firebase me user k sat
      "push_token": me.pushToken
    });
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

  static Stream<QuerySnapshot<Map<String, dynamic>>> gettingAllUserMessages() {
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
        // when we want to show last message first
        .orderBy('send', descending: true)
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
        send: time);
    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) {
      sendPushNotification(chatUser, type == Type.text ? msg : "image");
    });
  }

  // for read status of message
  static Future<void> UpdateMessageReadStatus(Message message) async {
    firestore
        .collection("chats/${getConversationID(message.fromId)}/messages/")
        .doc(message.send)
        .update({"read": DateTime.now().millisecondsSinceEpoch.toString()});
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

  // send image with chat

  static Future<void> sendChatImage(
      FirestoreDataModel chatUser, File file) async {
    // for add extension
    final ext = file.path.split(".").last;

    final ref = storage.ref().child(
        "ChatImage/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext");
    await ref
        .putFile(file, SettableMetadata(contentType: "image/$ext"))
        .then((p0) {
      log("data Transfer : ${p0.bytesTransferred / 1000} kb");
    });

    // updated downloaded image url
    final imageUrl = await ref.getDownloadURL();
    sendMessage(chatUser, imageUrl, Type.image);
  }

  // push notification
  static Future<void> sendPushNotification(
      FirestoreDataModel chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": chatUser.name,
          "body": msg,
          "android_channel_id": "chats",
        },
        "data": {
          "some_data": "User_id ${chatUser.id}",
        },
      };
      // ignore: unused_local_variable
      var res = await post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader:
                "AAAAppd647E:APA91bHZoRgA_ox_r-2tE6a5xinDbQGPf929ZkCxnbJEhk2wQFGnmrw67AcGUZve0cd5Zuy8f8ObpvPJsQGfUeHZKHlxq_rRZPtXAP3V4JgxDXw7g5s0Zu2AAWwo4JANoYJUcLmxxDvQ"
          },
          body: jsonEncode(body));
      log("response status : ${res.statusCode}");
      log("response body: ${res.body}");
    } catch (e) {
      log("sendPushNotification ${e.toString()}");
    }
  }

// delete message from chat screen
  static Future<void> deleteMessage(Message message) async {
    firestore
        .collection("chats/${getConversationID(message.toId)}/messages/")
        .doc(message.send)
        .delete();

    if (message.type == Type.image) storage.refFromURL(message.msg).delete();
  }

  // updated message from chat screen
  static Future<void> updatedChatMessage(
      Message message, String sendMsg) async {
    firestore
        .collection("chats/${getConversationID(message.toId)}/messages/")
        .doc(message.send)
        .update({"msg": sendMsg});
  }
}
