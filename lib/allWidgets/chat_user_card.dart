// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/main.dart';
import 'package:chat_app/model/chat_userModel.dart';
import 'package:chat_app/view/chatScreen/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class ChatUserCard extends StatelessWidget {

  FirestoreDataModel usermodel;
   ChatUserCard({
    Key? key,
    required this.usermodel
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        onTap: (){
          Get.to(ChatScreen(firestoreDataModel: usermodel));
        },
        leading:usermodel.image!.isEmpty?CircleAvatar():ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.network(usermodel.image.toString(),
          errorBuilder: (BuildContext, Object, StackTrace){
            return CircleAvatar();
          },
          ),),
        title: Text(usermodel.name.toString()),
        subtitle: Text(usermodel.about.toString()),
        trailing: Container(
          width: mp.width*0.03,
          height: mp.height*0.03,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.greenAccent.shade400
          ),
        ),
      ),
    );
  }
}
