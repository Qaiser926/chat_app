// ignore_for_file: unnecessary_brace_in_string_interps, unused_element

import 'dart:developer';

import 'package:chat_app/Screen/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:get/get.dart';

late Size mp;
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
 // enter full screen
 SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
 // for setting orientation for portrait only
 SystemChrome.setPreferredOrientations(
  [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
 ).then((value) {
  firebaseInitialize();
  runApp(const ChatApp());
 });

}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme:const AppBarTheme(
          centerTitle: true,
          elevation: 0
        )
      ),
      home:const SplashScreen(),
    );
  }

}
  firebaseInitialize()async{
    await Firebase.initializeApp();
    var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For showing Message Notification',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
   
);
log("Flutter channel notification : ${result}");
  }
