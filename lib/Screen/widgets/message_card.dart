// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/allConstant/snakBar_progressIndicator.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/api/api.dart';
import 'package:chat_app/helpler/time_formate.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/userMessageModel.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';

class ChatUserMessageBody extends StatelessWidget {
  Message messages;
  ChatUserMessageBody({
    Key? key,
    required this.messages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMe = Apis.user.uid == messages.fromId;
    return InkWell(
      onLongPress: () {
        _bottomSheet(context,isMe);
      },
      child: isMe ? _greenMessage(context) : _blueMessage(context),
    );
  }

 // sender or another user message
  Widget _blueMessage(BuildContext context) {
    //update last read message if sender and receiver are different
    if (messages.read.isEmpty) {
      Apis.UpdateMessageReadStatus(messages);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(messages.type == Type.image
                ? mp.width * .03
                : mp.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mp.width * .04, vertical: mp.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: Colors.lightBlue),
                //making borders curved
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: messages.type == Type.text
                ?
                //show text
                Text(
                    messages.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                :
                //show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: messages.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),

        //message time
        Padding(
          padding: EdgeInsets.only(right: mp.width * .04),
          child: Text(
            FormateTimeUtil.getFormateTime(
                 context, messages.send),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  // our or user message
  Widget _greenMessage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message time
        Column(
          children: [
            Row(
              children: [
                //for adding some space
                SizedBox(width: mp.width * .04),

                //double tick blue icon for message read
                if (messages.read.isNotEmpty)
                  const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),

                //for adding some space
                const SizedBox(width: 2),

                //sent time
                Text(
               FormateTimeUtil.getFormateTime(context, messages.send),
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
              if (messages.read.isNotEmpty)
             const Text(
               "seen",
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
          ],
        ),

        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(messages.type == Type.image
                ? mp.width * .03
                : mp.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mp.width * .04, vertical: mp.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 255, 176),
                border: Border.all(color: Colors.lightGreen),
                //making borders curved
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: messages.type == Type.text
                ?
                //show text
                Text(
                    messages.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                :
                //show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: messages.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // // sender or another message
  // Widget _blueMessage(BuildContext context) {
  //   if (messages.read.isEmpty) {
  //     Apis.UpdateMessageReadStatus(messages);
  //   }
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Flexible(
  //         child: Container(
  //           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //           padding: EdgeInsets.all(messages.type == Type.image
  //               ? mp.height * 0.01
  //               : mp.height * 0.02),
  //           decoration: BoxDecoration(
  //               color: Colors.blue.shade300.withOpacity(0.2),
  //               border: Border.all(color: Colors.blue.shade300),
  //               borderRadius: const BorderRadius.only(
  //                   topLeft: Radius.circular(20),
  //                   topRight: Radius.circular(20),
  //                   bottomRight: Radius.circular(20))),
  //           child: messages.type == Type.text
  //               ? Text(messages.msg.toString(),
  //                   style: const TextStyle(
  //                       color: Colors.black,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 15))
  //               :
  //               // server image from storage
  //                 ClipRRect(
  //                   borderRadius: BorderRadius.circular(15),
  //                   child: CachedNetworkImage(
  //                     imageUrl: messages.msg,
  //                     placeholder: (context, url) => const Padding(
  //                       padding: EdgeInsets.all(8.0),
  //                       child: CircularProgressIndicator(strokeWidth: 2),
  //                     ),
  //                     errorWidget: (context, url, error) =>
  //                         const Icon(Icons.image, size: 70),
  //                   ),
  //                 ),
             
  //         ),
  //       ),
  //       Container(
  //           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //           child: Column(
  //             children: [
  //               Text(FormateTimeUtil.getFormateTime(context, messages.send)),
  //               if (messages.read.isNotEmpty)
  //                 const Icon(
  //                   Icons.check,
  //                   color: Colors.blue,
  //                 )
  //             ],
  //           )),
  //     ],
  //   );
  // }

  // // our or user message
  // Widget _greenMessage(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Container(
  //           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //           child: Column(
  //             children: [
  //               Text(FormateTimeUtil.getFormateTime(context, messages.send)),
  //               // const Icon(Icons.check,color: Colors.blue,)
  //             ],
  //           )),
  //       Flexible(
  //         child: Container(
  //           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //           padding: EdgeInsets.all(messages.type == Type.image
  //               ? mp.height * 0.01
  //               : mp.height * 0.02),
  //           decoration: BoxDecoration(
  //               color: Colors.green.shade300.withOpacity(0.2),
  //               border: Border.all(color: Colors.green.shade300),
  //               borderRadius: const BorderRadius.only(
  //                   topLeft: Radius.circular(20),
  //                   topRight: Radius.circular(20),
  //                   bottomLeft: Radius.circular(20))),
  //           child: messages.type == Type.text
  //               ? Text(messages.msg.toString(),
  //                   style: const TextStyle(
  //                       color: Colors.black,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 15))
  //               :
  //               // server image from storage
  //               ClipRRect(
  //                   borderRadius: BorderRadius.circular(10),
  //                   child: CachedNetworkImage(
  //                     imageUrl: messages.msg,
  //                     placeholder: (context, url) => const Padding(
  //                       padding: EdgeInsets.all(8.0),
  //                       child: Center(child: CircularProgressIndicator()),
  //                     ),
  //                     errorWidget: (context, url, error) {
  //                       return Icon(
  //                         Icons.image,
  //                         size: 70,
  //                       );
  //                     },
  //                   )),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  _bottomSheet(BuildContext context, isMe) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(mp.height * 0.02),
                topRight: Radius.circular(mp.height * 0.02))),
        context: context,
        builder: (context) {
          return ListView(
            shrinkWrap: true,
            children: [

              Container(
                margin: EdgeInsets.symmetric(horizontal: mp.width*0.4,vertical: mp.height*0.02),
                height: 4,
                // width: mp.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Divider(
                  color: Colors.black38,
                  thickness: 3,
                ),
              ),
            messages.type==Type.text?
              OptionItem(
                name: "Copy Text",
                ontap: () async{
                  await Clipboard.setData(ClipboardData(text: messages.msg)).then((value) {
                  
                    Navigator.pop(context);
                  });
                },
                icon: Icons.copy,
                iconColor: Colors.blue,
              ):
                OptionItem(
                name: "Save Image",
                ontap: () {
                  Navigator.pop(context);
                  GallerySaver.saveImage(messages.msg
                  ,albumName: "Qaiser Chat app"
                  ).then((success) {
    
      if(success !=null && success){
        Dialogs.showSnack("Image Downloaded");
      }
    });
                },
                icon: Icons.save,
                iconColor: Colors.blue,
              ), 
              Container(
                 margin: EdgeInsets.symmetric(horizontal: mp.width*0.06,vertical: mp.height*0.01),
                child: const Divider(
                  color: Colors.black26,
                  thickness: 1.5,
                ),
              ),
              if( messages.type==Type.text && isMe)
              OptionItem(
                name: "Edit Message",
                ontap: () {
                  Navigator.pop(context);
                  showAlertDialog(context);
                },
                icon: Icons.edit,
                iconColor: Colors.blue,
              ), 
              if(isMe)
              OptionItem(
                name: "Delete Message",
                ontap: () {
                  Apis.deleteMessage(messages).then((value) {
                    Navigator.pop(context);
                    Dialogs.showSnack("Delete Message");
                  });
                },
                icon: Icons.delete,
                iconColor: Colors.red,
              ), 
              if(isMe)
                Container(
                    margin: EdgeInsets.symmetric(horizontal: mp.width*0.06,vertical: mp.height*0.01),
             
                child: const Divider(
                  color: Colors.black26,
                  thickness: 1.5,
                ),
              ),
              OptionItem(
                name: "Sent At: ${FormateTimeUtil.getMessageTime(context: context, time: messages.send)}",
                ontap: () {},
                icon: Icons.remove_red_eye,
                iconColor: Colors.blue,
              ), OptionItem(
                name: messages.read.isEmpty?
                "Read At: Not seen Yet": "Read At: ${FormateTimeUtil.getMessageTime(context: context, time: messages.read)}",
                ontap: () {},
                icon: Icons.remove_red_eye,
                iconColor: Colors.red,
              ),
            ],
          );
        });
  }
   showAlertDialog(BuildContext context){
    var updatedMessage=messages.msg;
   return showDialog(context: context, builder: (context){
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text("Updated Message"),
      content: TextFormField(
        onChanged: (value)=>updatedMessage=value,
        initialValue: updatedMessage,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15)
          )
        ),
      ),
      actions: [
        TextButton(onPressed: (){
          Apis.updatedChatMessage(messages,updatedMessage);
          Navigator.pop(context);
        }, child: const Text("Updated")),
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: const Text("Cancel")),
      ],
    );
   });
  }


}

class OptionItem extends StatelessWidget {
  String name;
  Function() ontap;
  IconData icon;
  Color? iconColor;
  OptionItem(
      {Key? key,
      required this.name,
      required this.ontap,
      required this.icon,
      this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: mp.width*0.03,vertical: mp.height*0.02),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            const SizedBox(width: 10,),
          Flexible(child: Text(name,style:const TextStyle(color: Colors.grey,fontSize: 17))),
          ],
        ),
      ),
    );
  }
}
