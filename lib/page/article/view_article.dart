import 'dart:convert';

import 'package:firebase_articles/page/profile/view_profile.dart';
import 'package:firebase_articles/util/image_delegate.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

class ViewArticle extends StatefulWidget {
  final String article, username, name, userPic, uid;

  const ViewArticle(
      {this.article, this.username, this.name, this.userPic, this.uid});

  @override
  _ViewArticleState createState() => _ViewArticleState();
}

class _ViewArticleState extends State<ViewArticle> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Material(
            color: Colors.white,
            elevation: 3.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.userPic),
              ),
              title: Text(widget.name),
              subtitle: Text(widget.username),
              trailing: FlatButton(
                textColor: Colors.blue,
                child: Text("View Profile"),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ViewProfile(
                            name: widget.name,
                            userID: widget.uid,
                            userName: widget.username,
                          )));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ZefyrView(
              document:
                  NotusDocument.fromJson(json.decode(widget.article) as List),
              imageDelegate: new ArticleImage(),
            ),
          )
        ],
      ),
    );
  }
}
