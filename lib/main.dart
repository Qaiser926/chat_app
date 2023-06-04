import 'package:chat_app/Screen/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

late Size mp;
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
runApp(const ChatApp());
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
