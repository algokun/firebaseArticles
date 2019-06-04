import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_articles/services/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ProfileInfo {
  String uid;

  Future init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString("uid");
  }

  final ref = Firestore.instance.collection("users");
  UserUpdateInfo info = UserUpdateInfo();

  //Stores username in Firestore
  storeUserName(String username) async {
    await ref.document(uid).setData({"username": username});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("username", username);
  }

  //Stores userImage in FirebaseStorage and Firestore
  storeUserImage(File profileImage) async {
    String downloadUrl = await StorageToolKit().uploadTask(profileImage, true);
    info.photoUrl = downloadUrl;
    await ref.document(uid).updateData({"userpic": downloadUrl}).then((i) {
      FirebaseAuth.instance.currentUser().then((currentUser) {
        currentUser.updateProfile(info);
      });
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userpic", downloadUrl);
  }

  //Stores userProfile in Firestore
  storeProfile(String name, String bio) async {
    info.displayName = name;
    await ref
        .document(uid)
        .updateData({"name": name, "bio": bio}).then((onValue) {
      FirebaseAuth.instance.currentUser().then((currentUser) {
        currentUser.updateProfile(info);
      });
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name",name);
  }
}
