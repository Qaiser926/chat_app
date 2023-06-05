// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:developer';

import 'package:chat_app/Screen/widgets/chat_user_card.dart';
import 'package:chat_app/allConstant/snakBar_progressIndicator.dart';
import 'package:chat_app/api/api.dart';
import 'package:chat_app/controller/login_controller.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/chat_userModel.dart';
import 'package:chat_app/Screen/profilePage.dart';
import 'package:chat_app/model/userMessageModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Apis.getSelfInfo();

    // for setting user status to active
    // is niche ko is liye comment kia is apis file 
    //page user info me past kia q k message wala code run me
    // time leta ta to is liye waha define kia take pehle o run ho jaye our bad me ye 
    // Apis.updatedStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      log("message: $message");
      // for updated user current status according to lifeCycle
      // resumed -- active or online
      // paused -- inActive or offline

      if (Apis.auth.currentUser != null) {
        if (message.toString().contains("resumed")) {
          Apis.updatedStatus(true);
        }
        if (message.toString().contains("paused")) {
          Apis.updatedStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    // popupMenuItem item
    List<String> cities = ['Profile'];

    final controller = Get.put(LoginController());

    // ignore: unused_local_variable
    Message message;

    return GestureDetector(
        // when enable textfield and we want to click on screen then close unfucos textfield
        onTap: () => FocusScope.of(context).unfocus(),
        child: Obx(() => WillPopScope(
            onWillPop: () {
              if (controller.isSearching.value) {
                controller.isSearching.value = !controller.isSearching.value;
                return Future.value(false);
              } else {
                return Future.value(true);
              }
            },
            child: Scaffold(
              floatingActionButton: FloatingActionButton(onPressed: (){
                showAlertDialog(context);
              },child: const Icon(Icons.add),),
              appBar: _appbar(controller, cities),
              body: StreamBuilder(
                // get id of only known user
                stream: Apis.getMyUserId(),
                builder: (context, snapshot) {
               switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );

                    // jab data load ho ya done ho to ye run ho ga
                    case ConnectionState.active:
                    case ConnectionState.done:
                      
                return     StreamBuilder(
                stream: Apis.gettingAllUser(snapshot.data?.docs.map((e) => e.id).toList()??[]),
                // getting only those user who's id provided
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );

                    // jab data load ho ya done ho to ye run ho ga
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;

                      // for (var list in data) {

                      //   log( 'Data: ${jsonEncode(list.data())}');
                      //    myList.add(list.data()["name"]);

                      // }
                      controller.myList = data
                              ?.map(
                                  (e) => FirestoreDataModel.fromJson(e.data()))
                              .toList() ??
                          [];
                      if (controller.myList.isNotEmpty) {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: controller.isSearching.value
                              ? controller.searchList.length
                              : controller.myList.length,
                          padding: EdgeInsets.only(top: mp.height * 0.02),
                          itemBuilder: (context, index) {
                            return ChatUserCard(
                              usermodel: controller.isSearching.value
                                  ? controller.searchList[index]
                                  : controller.myList[index],
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text("NO CONNECTION"));
                      }
                  }
                },
              );
              
               }
                },
              )
            ))));
  }

  AppBar _appbar(LoginController controller, List<String> cities) {
    return AppBar(
      leading: const Icon(
        Icons.home,
        color: Colors.black,
      ),
      backgroundColor: Colors.white,
      title: controller.isSearching.value
          ? TextField(
              autofocus: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "name & email",
              ),
              onChanged: (value) {
                controller.searchList.clear();
                for (var i in controller.myList) {
                  if (i.name.toLowerCase().contains(value.toLowerCase()) ||
                      i.email.toLowerCase().contains(value.toLowerCase())) {
                    controller.searchList.add(i);
                  }
                  setState(() {
                    controller.searchList;
                  });
                }
              },
            )
          : const Text(
              "We Chat",
              style: TextStyle(color: Colors.black),
            ),
      actions: [
        IconButton(
          onPressed: () {
            controller.isSearching.value = !controller.isSearching.value;
          },
          icon: Icon(
            controller.isSearching.value ? Icons.clear : Icons.search,
            color: Colors.black,
          ),
        ),
        PopupMenuButton(
          icon: const Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
          itemBuilder: (context) {
            return cities.map((city) {
              return PopupMenuItem(
                value: city,
                child: Text(city),
              );
            }).toList();
          },
          onSelected: (String selectedCity) {
            if (selectedCity == "Profile") {
              Get.to(ProfilePage(userModel: Apis.me));
            }
            // Handle the selected city here
            // ignore: avoid_print
            print('Selected city: $selectedCity');
          },
          // onSelected: (fn) => handleClick(),
        ),
      ],
    );
  }

  showAlertDialog(BuildContext context){
    var email='';
   return showDialog(context: context, builder: (context){
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text("Add New User"),
      content: TextFormField(
        onChanged: (value)=>email=value,
        initialValue: email,
        decoration: InputDecoration(
          hintText: 'Enter Email',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15)
          )
        ),
      ),
      actions: [
        TextButton(onPressed: (){
          // Apis.updatedChatMessage(messages,updatedMessage);
          if(email.isNotEmpty) Apis.addNewUser(email).then((value) {
            if(!value){
              Dialogs.showSnack("No User Exit");
            }
          });
          Navigator.pop(context);
        }, child: const Text("Add")),
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: const Text("Cancel")),
      ],
    );
   });
  }


}
