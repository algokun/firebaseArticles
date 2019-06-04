import 'package:firebase_articles/page/article/view_article.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchItem extends StatelessWidget {
  final String query;

  const SearchItem({this.query});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("articles")
            .where('articleTitle', isGreaterThanOrEqualTo: query)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.data.documents.length == 0){
            return Center(
              child: Text("No Results Found"),
            );
          }
          else{
            return ListView(
              children: snapshot.data.documents
                  .map((data) => searchItem(data, context))
                  .toList());
          }
        });
  }

  Widget searchItem(DocumentSnapshot snapshot, BuildContext context) {
    return ListTile(
        leading: Icon(Icons.book),
        title: Text(snapshot.data['articleTitle']),
        onTap: () async {
          Firestore.instance
              .collection("users")
              .document(snapshot.data['uid'])
              .get()
              .then((userSnap) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ViewArticle(
                    article: snapshot.data['article'],
                    name: userSnap.data['name'],
                    uid: snapshot.data['uid'],
                    username: userSnap.data['username'],
                    userPic: userSnap.data['userpic'],
                  ),
            ));
          });
        });
  }
}