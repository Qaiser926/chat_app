// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/allWidgets/chatUserMessageBody.dart';
import 'package:chat_app/api/api.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/userMessageModel.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/model/chat_userModel.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  FirestoreDataModel firestoreDataModel;

  ChatScreen({
    Key? key,
    required this.firestoreDataModel,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // storing data
  List<Messages> _List = [];

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
              stream: Apis.getAllMessages(widget.firestoreDataModel),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  //if data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const SizedBox();
                  //if some or all data is loaded then show it
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                  
                    _List = data?.map((e) => Messages.fromJson(e.data()))
                            .toList() ??
                        [];
                   _List.length==0?log("NO Data Found"): log(jsonEncode(data![0].data()));
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

  Container _BottomMessageSearchBar() {
    return Container(
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
                      icon: Icon(
                        Icons.emoji_emotions,
                        color: Colors.blue,
                      )),
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Enter SomeThing...",
                      border: InputBorder.none,
                    ),
                  )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.photo, color: Colors.blue)),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.camera_alt, color: Colors.blue)),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                Apis.sendingMessage(
                  widget.firestoreDataModel,
                  _textController.text,
                );
                _textController.text = '';
              }
            },
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 25,
            ),
            color: Colors.green,
            shape: CircleBorder(),
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
                icon: Icon(Icons.arrow_back)),
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                widget.firestoreDataModel.image.toString(),
                errorBuilder: (BuildContext, Object, StackTrace) {
                  return CircleAvatar();
                },
                fit: BoxFit.cover,
                width: mp.width * 0.09,
                height: mp.height * 0.04,
              ),
            ),

            // appBar title
            SizedBox(
              width: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.firestoreDataModel.name.toString()),
                const Text("Last seen not Avaible"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
