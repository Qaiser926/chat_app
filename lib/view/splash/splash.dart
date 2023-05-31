import 'dart:developer';
import 'package:chat_app/api/api.dart';
import 'package:chat_app/auth/login/login.dart';
import 'package:chat_app/view/home/home.dart';
import 'package:chat_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
   SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 2000),(){
   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
   SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(systemNavigationBarColor: Colors.white,statusBarColor: Colors.white),
   );
   if(Apis.auth.currentUser!=null){
       log("\n User: ${FirebaseAuth.instance.currentUser}");
      Get.offAll(Home());
    }else{
      Get.offAll(LoginScreen());
    }
    });
  }
  @override
  Widget build(BuildContext context) {
    mp=MediaQuery.of(context).size;
    return Scaffold(
    
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Image.asset(("images/msg.png"),width: mp.width*0.5,height: mp.height*0.5,),
        Center(child: CircularProgressIndicator())
          ],
        ),
      ),
    );
  }
}