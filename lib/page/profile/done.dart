import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home.dart';

class ProfileDone extends StatefulWidget {
  final BuildContext context;
  ProfileDone(this.context);
  @override
  _ProfileDoneState createState() => _ProfileDoneState();
}

class _ProfileDoneState extends State<ProfileDone> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), (){
       gotoHome(); 
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 50,
          child: Icon(
            Icons.done,
            size: 40,
          ),
        ),
        Text(
          "\n100% Completed",
          style: Theme.of(context).textTheme.headline,
        )
      ],
    );
  }

  gotoHome() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Navigator.of(widget.context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomePage.fromPrefs(sharedPreferences)));
  }
}
