
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dialogs{

 static showSnack(String title)async{
    Get.snackbar("Error", title,
    snackPosition: SnackPosition.BOTTOM,
    
    );
  }

  static  progressIndicator()async{
   const Center(
      child: CircularProgressIndicator(),
    );
  }
}