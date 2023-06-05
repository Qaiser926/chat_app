// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/Screen/chatScreen.dart';
import 'package:chat_app/Screen/widgets/dialog/profileDialog.dart';
import 'package:chat_app/api/api.dart';
import 'package:chat_app/helpler/time_formate.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/chat_userModel.dart';
import 'package:chat_app/model/userMessageModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ChatUserCard extends StatelessWidget {
  FirestoreDataModel usermodel;
  Message? message;
  ChatUserCard({
    Key? key,
    required this.usermodel,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Apis.getLastSeenMessage(usermodel),
      builder: (context, snapshot) {
        final data = snapshot.data?.docs;
        final list =
            data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
        if (list.isNotEmpty) {
          message = list[0];
        }
        return Card(
          elevation: 1,
          child: ListTile(
              onTap: () {
                Get.to(ChatScreen(user: usermodel));
              },
              leading: usermodel.image.isEmpty
                  ? const CircleAvatar()
                  : InkWell(
                    onTap: (){
                      showDialog(context: context, builder: (context)=>ProfileDialog(usermodel: usermodel,));                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                          usermodel.image.toString(),
                          // ignore: non_constant_identifier_names, avoid_types_as_parameter_names
                          errorBuilder: (BuildContext, Object, StackTrace) {
                            return const CircleAvatar();
                          },
                        ),
                      ),
                  ),
              title: Text(usermodel.name.toString()),
              subtitle: Text(
                message?.type==Type.image?"image":
                message != null ? message!.msg : usermodel.about.toString(),
                maxLines: 1,
              ),
              // time message time 
              trailing: message == null
              // show nothing when no message send 
              
                  ? null
                  : message!.read.isEmpty &&
                          message!.fromId != Apis.auth.currentUser!.uid
                          // show for unread message 
                      ? Container(
                          width: mp.width * 0.03,
                          height: mp.height * 0.03,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.greenAccent.shade400),
                        )
                      : Text(
                        FormateTimeUtil.getMessageTime(context: context, time:message!.send)
                      )),
        );
      },
    );
  }
}
