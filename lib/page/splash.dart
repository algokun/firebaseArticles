import 'package:firebase_articles/page/home.dart';
import 'package:firebase_articles/page/login.dart';
import 'package:firebase_articles/page/profile/profile_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    FirebaseAuth.instance.currentUser().then((user){
      if(user == null){
        Timer(Duration(seconds: 4) , gotoLogin);
      }
      else {
       if(user.displayName == null || user.displayName.isEmpty){
         Timer(Duration(seconds: 4) , gotoProfile);
       }
       else{
         Timer(Duration(seconds: 4) , gotoHome);
       }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: FlatButton.icon(
          onPressed: null,
          icon: Icon(
            Icons.school,
            size: 50,
            color: Colors.blue,
          ),
          label: Text(
            "\tArticles App",
            style: Theme.of(context)
                .textTheme
                .display1
                .copyWith(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ),
    );
  }

  gotoHome() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage.fromPrefs(sharedPreferences)));
  }

  gotoLogin(){
    Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
  }

  gotoProfile(){
    Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfilePage()));
  }
}
