
// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';
import 'package:chat_app/Screen/widgets/message_card.dart';
import 'package:chat_app/api/api.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/userMessageModel.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/model/chat_userModel.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  FirestoreDataModel user;
  ChatScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // storing data
  // ignore: non_constant_identifier_names
  List<Message> _List = [];

  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: Apis.getAllMessages(widget.user),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  //if data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const SizedBox();
                  //if some or all data is loaded then show it
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data!.docs;
               
            
                  _List=data.map((e) => Message.fromJson(e.data())).toList();
                  
                   // ignore: prefer_is_empty
                   _List.length==0?log("NO Data Found"): log(jsonEncode(data[0].data()));
                    if (_List.isNotEmpty) {
                      return ListView.builder(
                          // reverse: true,
                          itemCount: _List.length,
                          padding: EdgeInsets.only(top: mp.height * .01),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ChatUserMessageBody(
                                messages: _List[index]);
                          });
                    } else {
                      return const Center(
                        child:
                            Text('Say Hii! 👋', style: TextStyle(fontSize: 20)),
                      );
                    }
                }
              },
            ),
          ),
          _BottomMessageSearchBar(),
        ],
      ),
    ));
  }

  // ignore: non_constant_identifier_names
  Container _BottomMessageSearchBar() {
    // ignore: avoid_unnecessary_containers
    return  Container(
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon:const Icon(
                        Icons.emoji_emotions,
                        color: Colors.blue,
                      )),
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    decoration:const InputDecoration(
                      hintText: "Enter SomeThing...",
                      border: InputBorder.none,
                    ),
                  )),
                  IconButton(
                      onPressed: () {},
                      icon:const Icon(Icons.photo, color: Colors.blue)),
                  IconButton(
                      onPressed: () {},
                      icon:const Icon(Icons.camera_alt, color: Colors.blue)),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                Apis.sendMessage(
                 widget.user, _textController.text, Type.text
                );
                _textController.text = '';
              }
            },
            padding:const EdgeInsets.all(4),
            child:  Icon(
              Icons.send,
              color: Colors.white,
              size: 25,
            ),
            color: Colors.green,
            shape:const CircleBorder(),
            minWidth: 0,
          )
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: InkWell(
        onTap: () {},
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Get.back();
                },
                icon:const Icon(Icons.arrow_back)),
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                widget.user.image.toString(),
                // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
                errorBuilder: (BuildContext, Object, StackTrace) {
                  return const CircleAvatar();
                },
                fit: BoxFit.cover,
                width: mp.width * 0.09,
                height: mp.height * 0.04,
              ),
            ),

            // appBar title
          const  SizedBox(
              width: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.user.name.toString()),
                const Text("Last seen not Available"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
