
// ignore_for_file: file_names

import 'package:chat_app/api/api.dart';
import 'package:chat_app/Screen/auth/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  const FloatingActionButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FloatingActionButton.extended(
        backgroundColor: Colors.redAccent.shade400,
        label: Row(
          children: const [
            Icon(Icons.logout),
            SizedBox(
              width: 10,
            ),
            Text("Logout"),
          ],
        ),
        onPressed: () async {
          Apis.auth.signOut().then((value) async {
            final GoogleSignIn googleSignIn = GoogleSignIn();

            await googleSignIn.signOut().then((value) {
              Get.back();
              Get.offAll(LoginScreen());
            });
          });
        },
      ),
    );
  
  }
}