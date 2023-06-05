// ignore_for_file: file_names

import 'dart:developer';
import 'dart:io';

import 'package:chat_app/Screen/widgets/floatingActionButton.dart';
import 'package:chat_app/helpler/time_formate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/api/api.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/chat_userModel.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class ViewProfilePage extends StatefulWidget {
  FirestoreDataModel userModel;

  ViewProfilePage({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? images;
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    List<FirestoreDataModel> myList = [];
    return GestureDetector(
      // for hiding keyboard for press any place in the screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Joined On  ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            Text(
                FormateTimeUtil.getLastMessageTime(
                    context: context,
                    time: widget.userModel.createdAt,
                    showYear: true),
                style: const TextStyle(color: Colors.black38)),
          ],
        ),
        appBar: _appbar(),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: mp.height * .03,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                      child:

                          // server image from storage
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mp.height * .1),
                              child: Image.network(
                                height: mp.height * 0.2,
                                width: mp.width * 0.45,
                                widget.userModel.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, object, stack) {
                                  return const Icon(Icons.error);
                                },
                              )),
                    ),
                    SizedBox(
                      height: mp.height * .03,
                    ),
                    Text(
                      widget.userModel.email.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: mp.height * .03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("About  ",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text(widget.userModel.about,
                            style: const TextStyle(color: Colors.black38)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
      leading: InkWell(
        onTap: () {
          Get.back();
        },
        child: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      title: Text(
        widget.userModel.name,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
