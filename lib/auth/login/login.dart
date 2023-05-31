import 'dart:developer';
import 'package:chat_app/allConstant/snakBar_progressIndicator.dart';
import 'package:chat_app/controller/login_controller.dart';
import 'package:chat_app/view/home/home.dart';
import 'package:chat_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.put(LoginController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // our is duration ka ye mtlb he k kitne time k bad is ne ana he .
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        controller.animated.value = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    mp = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            // is ka ye matlb he  k is ne kab tak pohchna he center me
            duration: Duration(seconds: 1),
            height: mp.height * 0.2,
            top: mp.height * 0.05,
            // left: mp.width*0.25,
            right:
                controller.animated.value ? mp.width * 0.25 : -mp.width * 0.5,
            width: mp.width * 0.5,

            child: Image.asset(("images/msg.png")),
          ),
          Positioned(
            height: mp.height * 0.06,
            // top: mp.height*0.03,
            bottom: mp.height * 0.1,
            left: mp.width * 0.05,
            right: mp.width * 0.05,
            child: Obx(() =>controller.isLoading.value?Center(child: CircularProgressIndicator()): ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(), backgroundColor: Colors.blueGrey),
                onPressed: () {
                  controller.handleGoogleBtnClick();
                },
                icon: Image.asset(
                  ("images/google.png"),
                  width: mp.width * 0.08,
                ),
                label: RichText(
                  text: const TextSpan(children: [
                    TextSpan(text: "SignIn"),
                    TextSpan(text: " with"),
                    TextSpan(
                        text: " Google",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 17)),
                  ]),
                ))),
          )
        ],
      ),
    );
  }
}
