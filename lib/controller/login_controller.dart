import 'dart:developer';
import 'dart:io';

import 'package:chat_app/allConstant/snakBar_progressIndicator.dart';
import 'package:chat_app/api/api.dart';
import 'package:chat_app/model/chat_userModel.dart';
import 'package:chat_app/view/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController{

   RxBool animated=false.obs;
   var isLoading=false.obs;
   var isSearching=false.obs;

        /// search list 
        List<FirestoreDataModel> searchList = [];
        // normal data list 
        List<FirestoreDataModel> myList = [];

 handleGoogleBtnClick(){
  
  isLoading(true);
_signInWithGoogle().then((user)async{
 if(user !=null){
   isLoading(false);
  // log("\n User: ${user.user}");
  // log("\n UserAdditionalInfo: ${user.additionalUserInfo}");
  
 if(await(Apis.userExit())){
   Get.to(Home());
 }else{
  await Apis.createUser().then((value) {
     Get.to(Home());
  });
 }
 }
}).onError((error, stackTrace) {
  isLoading(false);
});

 }
 Future<UserCredential?> _signInWithGoogle()async{
  try {
    await InternetAddress.lookup("google.com");
    // trigger the authentication flow
  final GoogleSignInAccount? googleuser=await GoogleSignIn().signIn();

  // obtain the auth detail from the request
  final GoogleSignInAuthentication? googleAuth=await googleuser?.authentication;

  // create a new credential
  final credential=GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken
  );
  // once signed in , return the userCredential
  return await Apis.auth.signInWithCredential(credential);
  } catch (e) {
    isLoading(false);
    Dialogs.showSnack("Something Went Wrong (Check Internet)");
    log("error occur ${e.toString()}");
    return null;
  }
 }
}