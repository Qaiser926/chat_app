// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:chat_app/api/api.dart';
import 'package:chat_app/helpler/time_formate.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/model/userMessageModel.dart';

class ChatUserMessageBody extends StatelessWidget {
  Message messages;
   ChatUserMessageBody({
    Key? key,
    required this.messages,
  }) : super(key: key);
 

  @override
  Widget build(BuildContext context) {
    return Apis.user.uid==messages.fromId? _greenMessage(context):_blueMessage(context);
      }
  // sender or another message
  Widget _blueMessage(BuildContext context){
      if(messages.read.isEmpty){
      Apis.UpdateMessageReadStatus(messages);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
               color: Colors.blue.shade300.withOpacity(0.2),
               border: Border.all(color: Colors.blue.shade300),
               borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20)
               )
            ),
              child: Text(messages.msg.toString(),style:const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15)),
          ),
        ),
        Container(
           margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          child: Column(
            children: [
              Text(
              FormateTimeUtil.getFormateTime(context, messages.send)
              ),
              if(messages.read.isNotEmpty)
              const Icon(Icons.check,color: Colors.blue,)
            ],
          )),
      ],
    );

  }

  // our or user message
  Widget _greenMessage(BuildContext context){
  
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       
        Container(
           margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          child: Column(
            children: [

              Text(
                FormateTimeUtil.getFormateTime(context, messages.send)
             ),
           
              // const Icon(Icons.check,color: Colors.blue,)
            ],
          )),
         Flexible(
           child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
               color: Colors.green.shade300.withOpacity(0.2),
               border: Border.all(color: Colors.green.shade300),
               borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20)
               )
            ),
              child: Text(messages.msg.toString(),style:const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15)),
                 ),
         ),
      ],
    );

  }
}