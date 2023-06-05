// ignore_for_file: file_names, unused_field

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Screen/view_profilePage.dart';
import 'package:chat_app/Screen/widgets/message_card.dart';
import 'package:chat_app/api/api.dart';
import 'package:chat_app/helpler/time_formate.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/userMessageModel.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/model/chat_userModel.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
  // ignore: prefer_final_fields
  bool _showEmoji = false, _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
          child: WillPopScope(
        onWillPop: () {
          if (_showEmoji) {
            _showEmoji = !_showEmoji;
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: PreferredSize(
              child: _appBar(),
              preferredSize: Size(mp.height, mp.height * 0.08)),
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

                        _List = data
                            .map((e) => Message.fromJson(e.data()))
                            .toList();

                        // ignore: prefer_is_empty
                        _List.length == 0
                            ? log("NO Data Found")
                            : log(jsonEncode(data[0].data()));
                        if (_List.isNotEmpty) {
                          return ListView.builder(
                              reverse: true,
                              itemCount: _List.length,
                              padding: EdgeInsets.only(top: mp.height * .01),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ChatUserMessageBody(
                                    messages: _List[index]);
                              });
                        } else {
                          return const Center(
                            child: Text('Say Hii! 👋',
                                style: TextStyle(fontSize: 20)),
                          );
                        }
                    }
                  },
                ),
              ),

              // for showing uploading image
              if (_isLoading)
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: mp.height * 0.02),
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )),
              _BottomMessageSearchBar(),
              // show emoji
              if (_showEmoji)
                SizedBox(
                  height: mp.height * 0.35,
                  child: EmojiPicker(
                    textEditingController:
                        _textController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]

                    config: Config(
                      columns: 7,
                      emojiSizeMax: 32 *
                          (Platform.isIOS
                              ? 1.30
                              : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                    ),
                  ),
                )
            ],
          ),
        ),
      )),
    );
  }

  // ignore: non_constant_identifier_names
  Container _BottomMessageSearchBar() {
    // ignore: avoid_unnecessary_containers
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
                      onPressed: () {
                        setState(() {
                          // when tap textField and tap emoji then show separate emoji container solve problem
                          FocusScope.of(context).unfocus();
                          _showEmoji = !_showEmoji;
                        });
                      },
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.blue,
                      )),
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    onTap: () {
                      setState(() {
                        if (_showEmoji) _showEmoji = !_showEmoji;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Enter SomeThing...",
                      border: InputBorder.none,
                    ),
                  )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an multiImage image.
                        final List<XFile> image =
                            await picker.pickMultiImage(imageQuality: 100);
                        for (var i in image) {
                          setState(() {
                            _isLoading = true;
                          });
                          await Apis.sendChatImage(widget.user, File(i.path));
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      icon: const Icon(Icons.photo, color: Colors.blue)),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 100);
                        if (image != null) {
                          setState(() {
                            _isLoading = true;
                          });
                          await Apis.sendChatImage(
                              widget.user, File(image.path));
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      icon: const Icon(Icons.camera_alt, color: Colors.blue)),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                // for checking list is empty or not
                if (_List.isEmpty) {
                  Apis.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                }
                // simple message send
                else {
                  Apis.sendMessage(
                      widget.user, _textController.text, Type.text);
                }
                _textController.text = '';
              }
            },
            padding: const EdgeInsets.all(4),
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 25,
            ),
            color: Colors.green,
            shape: const CircleBorder(),
            minWidth: 0,
          )
        ],
      ),
    );
  }

  Widget _appBar() {
    return StreamBuilder(
      stream: Apis.getUserInfo(widget.user),
      builder: (context, snapshot) {
        final data = snapshot.data?.docs;
        final list =
            data?.map((e) => FirestoreDataModel.fromJson(e.data())).toList() ??
                [];
        return AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          flexibleSpace: InkWell(
            onTap: () {
              Get.to(ViewProfilePage(
                userModel: widget.user,
              ));
            },
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back)),
                        ClipRRect(
                    borderRadius: BorderRadius.circular(mp.height * .03),
                    child: CachedNetworkImage(
                     width: mp.width * 0.09,
                    height: mp.height * 0.04,
                      imageUrl:
                          list.isNotEmpty ? list[0].image : widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                // appBar title
                const SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(list.isNotEmpty
                        ? list[0].name
                        : widget.user.name.toString()),
                    Text(list.isNotEmpty
                        ? list[0].isOnline
                            ? "IsOnline"
                            :
                            // formate last seen time
                            FormateTimeUtil.getLastActiveTime(
                                context: context,
                                lastActive: list[0].lastActive)
                        : FormateTimeUtil.getLastActiveTime(
                            context: context,
                            lastActive: widget.user.lastActive)),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
