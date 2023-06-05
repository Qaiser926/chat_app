// ignore_for_file: file_names, must_be_immutable

import 'package:chat_app/Screen/view_profilePage.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/chat_userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ProfileDialog extends StatelessWidget {
  ProfileDialog({super.key, required this.usermodel});
  FirestoreDataModel usermodel;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: SizedBox(
      height: mp.height*0.35,
      width: mp.width*0.6,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15,left: 10),
              child: SizedBox(
                width: mp.width*0.5,
                child: Text(usermodel.name,style:const TextStyle(color: Colors.black,fontWeight: FontWeight.bold))),
            ),
            Align
            (
              alignment: Alignment.topRight,
              child: IconButton(onPressed: (){
                Get.off(ViewProfilePage(userModel: usermodel));
              
              }, icon: const Icon(Icons.info_outline,color: Colors.blue,size: 30,))),
           
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(mp.height * .12),
                  child: Image.network(
                    height: mp.height * 0.24,
                    width: mp.width * 0.55,
                    usermodel.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, object, stack) {
                      return const Icon(Icons.error);
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
