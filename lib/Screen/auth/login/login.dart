
import 'package:chat_app/controller/login_controller.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    // our is duration ka ye mtlb he k kitne time k bad is ne ana he .
    Future.delayed(const Duration(milliseconds: 500), () {
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
        title:const Text("Login"),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            // is ka ye matlb he  k is ne kab tak pohchna he center me
            duration:const Duration(seconds: 1),
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
            child: Obx(() =>controller.isLoading.value?const Center(child: CircularProgressIndicator()): ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shape:const StadiumBorder(), backgroundColor: Colors.blueGrey),
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
