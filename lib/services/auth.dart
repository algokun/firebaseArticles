// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_articles/page/home.dart';
import 'package:firebase_articles/page/profile/profile_home.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  final BuildContext context;
  Auth.fromContext({this.context});

  Future createUser(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) async {
        await storeUserId(user.uid);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ProfilePage()));
      });
    } on PlatformException catch (e) {
      showError(e.message);
    }
  }

  Future signInUser(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) async {
        await storeUserId(user.uid);
        await gotoHomeAfterLogin(user.uid);
      });
    } on PlatformException catch (e) {
      showError(e.message);
    }
  }

  showError(String error) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Ouch!!"),
              content: Text(error),
              actions: <Widget>[
                FlatButton(
                  child: Text("Retry"),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  }

  storeUserId(String uid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("uid", uid);
  }

  gotoHomeAfterLogin(String uid ,){
    Firestore.instance.collection("users").document(uid).get().then((snapshot) async{
      await Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage.fromSnapShot(snapshot)));
    });
  }
}
