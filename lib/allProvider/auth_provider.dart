
// import 'package:chat_app/allConstant/firestore_constant.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../allConstant/firestore_constant.dart';
// enum Status{
//   uninitializad,
//   authenticated,
//   authenticating,
//   authenticatError,
//   authenticatingCancel,
// }
// class AuthProvider extends ChangeNotifier{
//   final GoogleSignIn  googleSignIn;
//   final FirebaseAuth firebaseAuth;
//   final FirebaseFirestore firebaseFirestore;
//   final SharedPreferences prefs;

//  Status get status=>Status.uninitializad;
//   Status get status=>_status;

//   AuthProvider({
//     required this.firebaseAuth,
//     required this.googleSignIn,
//     required this.prefs,
//     required this.firebaseFirestore,
//   });

//   String? getUserFirebaseId(){
//     return prefs.getString(FirestoreConstant.id);

//   }
//   Future<bool> isLoggedIn()async{
//     bool isLoggedIn = await googleSignIn.isSignedIn();
//     if(isLoggedIn && prefs.getString(FirestoreConstant.id)?.isNotEmpty==true){
//       return true;

//     }else{
//       return false;
//     }
//   }
//   Future<bool> handleSignIn()async{
//     _status=Status.authenticating;

//     notifyListeners();
//     GoogleSignInAccount? googleUser=await googleSignIn.signIn();
//     if(googleSignIn !=null){
//       GoogleSignInAuthentication? googleAuth=await googleUser?.authentication;
//       final AuthCredential credential=GoogleAuthProvider.credential(
//         accessToken: googleAuth!.accessToken,
//         idToken: googleAuth.idToken,
//       );
//       User? firebaseUser=(await FirebaseAuth.signInWithCredential(credential)).user;
//       if(firebaseUser !=null){
//         final QuerySnapshot result=await firebaseFirestore.collection(FirestoreConstant.pathUserCollection)
//         .where(FirestoreConstant.id, isEqualTo: firebaseUser.uid)
//         .get();
//         final List<DocumentSnapshot> document=result.docs;
//         if(document.length==0){
//           firebaseFirestore.collection(FirestoreConstant.pathUserCollection).doc(firebaseUser.uid).set({
//             FirestoreConstant.nickName:firebaseUser.displayName,
//             FirestoreConstant.photoUrl:firebaseUser.photoURL,
//             FirestoreConstant.id:firebaseUser.uid,
//             "createdAt":DateTime.now().millisecondsSinceEpoch.toString(),
//             FirestoreConstant.chattingWith:null,
//           });
//           User? currentUser=firebaseUser;
//           await prefs.setString(FirestoreConstant.id, currentUser.uid);
//           await prefs.setString(FirestoreConstant.nickName, currentUser.displayName??"");
//           await prefs.setString(FirestoreConstant.photoUrl, currentUser.photoURL??"");
//           await prefs.setString(FirestoreConstant.photoNumber, currentUser.phoneNumber??"");
//         }else{
//           DocumentSnapshot documentSnapshot=document[0];
//           Userchat userChat=UserChat.fromDocument(documentSnapshot);
//           await prefs.setString(FirestoreConstant.id, userChat.id);
//           await prefs.setString(FirestoreConstant.nickName, userChat.nickname);
//           await prefs.setString(FirestoreConstant.photoUrl, userChat.photoUrl);
//           await prefs.setString(FirestoreConstant.aboutMe, userChat.aboutMe);
//           await prefs.setString(FirestoreConstant.photoNumber, userChat.phoneNumber);
        
//         _status=Status.authenticated;
//         notifyListeners();
//         return false;

//         }
//       }else{
//           _status=Status.authenticated;
//         notifyListeners();
//         return false;
//       }
//     }
//   }

// }