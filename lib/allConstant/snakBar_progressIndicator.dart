
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Dialogs{

 static showSnack(String title)async{
    Get.snackbar("Error", title,
    snackPosition: SnackPosition.BOTTOM,
    
    );
  }

  static  progressIndicator()async{
    Center(
      child: CircularProgressIndicator(),
    );
  }
}