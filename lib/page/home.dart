import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_articles/page/article/add_article.dart';
import 'package:firebase_articles/page/profile/view_profile.dart';
import 'package:firebase_articles/services/notify.dart';
import 'package:firebase_articles/util/connection/nw_sense.dart';
import 'package:firebase_articles/util/search/firestore_search.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'article/article_stream_builder.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  final String userName, name, userID, userPic;

  const HomePage({this.userName, this.name, this.userID, this.userPic});

  factory HomePage.fromPrefs(SharedPreferences preferences) {
    return HomePage(
        userName: preferences.getString("username"),
        name: preferences.getString("name"),
        userID: preferences.getString("uid"),
        userPic: preferences.getString("userpic"));
  }

  factory HomePage.fromSnapShot(DocumentSnapshot snapshot) {
    return HomePage(
        userName: snapshot.data["username"],
        name: snapshot.data["name"],
        userID: snapshot.data["uid"],
        userPic: snapshot.data["userpic"]);
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with FCM {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  void initState() {
    super.initState();

    firebaseMessaging.configure(
        onMessage: (map) => onMessage(map),
        onLaunch: (map) => onLaunch(map),
        onResume: (map) => onResume(map));

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: NetworkSensitive(
            child: Scaffold(
              key: scaffoldKey,
          appBar: buildAppBar(context),
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddArticle(
                        name: widget.name,
                        userId: widget.userID,
                        userName: widget.userName,
                        userPic: widget.userPic,
                      )));
            },
          ),
          body: ArticleBuilder(),
        )));
  }

  addArticle(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddArticle(
              userName: widget.userName,
              userId: widget.userID,
              userPic: widget.userPic,
              name: widget.name,
            )));
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2.0,
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ViewProfile(
              name: widget.name,
              userID: widget.userID,
              userName: widget.userName,
            )
          ));
        },
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(widget.userPic),
          ),
        ),
      ),
      title: Text(
        "Home",
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        IconButton(
          color: Colors.blue,
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(context: context, delegate: FirestoreSearch());
          },
        )
      ],
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: new Text('Exit App?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          );
        });
  }

  getToken() {
    firebaseMessaging.getToken().then((token) {
      Firestore.instance
          .collection("fcm-tokens")
          .document(widget.userID)
          .setData({'token': token});
    });
  }
}
