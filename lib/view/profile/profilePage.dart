// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';
import 'dart:io';

import 'package:chat_app/view/profile/widgets/floatingActionButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/api/api.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/chat_userModel.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  FirestoreDataModel userModel;

  ProfilePage({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    List<FirestoreDataModel> myList = [];
    return GestureDetector(
      // for hiding keyboard for press any place in the screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButton: FloatingActionButtonWidget(),
        appBar: _appbar(),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                    child: Apis.auth.currentUser?.photoURL == null
                        ? const CircleAvatar()
                        : Stack(
                            children: [
                             _image!=null?  
                             // local image from storage
                              ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(mp.height * .1),
                                  child: Image.file(
                                    height: mp.height * 0.2,
                                    width: mp.width * 0.45,
                                  File(_image!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, object, stack) {
                                      return const Icon(Icons.error);
                                    },
                                  ))
                             : 
                             // server image from storage
                              ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(mp.height * .1),
                                  child: Image.network(
                                    height: mp.height * 0.2,
                                    width: mp.width * 0.45,
                                    Apis.auth.currentUser?.photoURL
                                            .toString() ??
                                        "",
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, object, stack) {
                                      return const Icon(Icons.error);
                                    },
                                  )),
                              Positioned(
                                bottom: 20,
                                right: 0,
                                child: MaterialButton(
                                  elevation: 1,
                                  color: Colors.white,
                                  height: mp.height * 0.05,
                                  minWidth: mp.width * 0.05,
                                  shape: CircleBorder(),
                                  onPressed: () {
                                    _bottomSheet();
                                  },
                                  child: Icon(Icons.edit),
                                ),
                              )
                            ],
                          ),
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
                  TextFormField(
                    onSaved: (value) => Apis.me.name = value ?? "",
                    validator: (vale) => vale != null && vale.isNotEmpty
                        ? null
                        : "Required Field",
                    initialValue: widget.userModel.name.toString(),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "eg: xyz..",
                      label: Text("Name"),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: mp.height * .03,
                  ),
                  TextFormField(
                    onSaved: (value) => Apis.me.about = value ?? "",
                    validator: (vale) => vale != null && vale.isNotEmpty
                        ? null
                        : "Required Field",
                    initialValue: widget.userModel.about,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.info_outline_rounded),
                      hintText: "eg: happy feel",
                      label: Text("About"),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: mp.height * .03,
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.update),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Apis.updatedUserInfo();
                      }
                    },
                    label: Text("Updated"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _bottomSheet() {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(mp.height * 0.02),
                topRight: Radius.circular(mp.height * 0.02))),
        context: context,
        builder: (context) {
          return Container(
            height: mp.height * 0.25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: ()async {
                         final ImagePicker picker = ImagePicker();
                     // Pick an image.
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
                      if(image!=null){
                        log("image path ${image.path}");
                            setState(() {
                            _image=image.path;
                            Get.back();
                          });
                           Apis.updatedProfilePic(File(_image!));
                      }
                    },
                    icon: Icon(
                      Icons.camera_alt,
                      size: mp.height * 0.14,
                      color: Colors.amber.shade300,
                    )),
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                     // Pick an image.
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
                      if(image!=null){
                        log("image path ${image.path}");
                            setState(() {
                            _image=image.path;
                            Get.back();
                          });
                          Apis.updatedProfilePic(File(_image!));
                      }
                    },
                    icon: Icon(
                      Icons.photo,
                      size: mp.height * 0.14,
                      color: Colors.pink.shade300,
                    ))
              ],
            ),
          );
        });
  }

  AppBar _appbar() {
    return AppBar(
      leading: InkWell(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      title: Text(Apis.auth.currentUser!.displayName.toString()),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert, color: Colors.black),
        ),
      ],
    );
  }
}
