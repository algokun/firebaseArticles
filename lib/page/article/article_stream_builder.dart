import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_articles/util/models/article.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'article_item.dart';

class ArticleBuilder extends StatefulWidget {
  @override
  _ArticleBuilderState createState() => _ArticleBuilderState();
}

class _ArticleBuilderState extends State<ArticleBuilder> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('articles')
          .orderBy("timeStamp", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if(snapshot.data.documents.length == 0){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/noitems.png"),
                Text("Start Writing", style: Theme.of(context).textTheme.headline,)
              ],
            );
          }

          else{
            return _buildList(context, snapshot.data.documents);
          }
      },
    );
  }

  Widget _buildList(
      BuildContext context, List<DocumentSnapshot> articleSnapshot) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 20.0),
      itemCount: articleSnapshot.length,
      itemBuilder: (context, i) {
        return _buildListItem(context, articleSnapshot[i]);
      },
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = ModelArticle.fromSnapshot(data);
    return ArticleItem(
      articleTitle: record.articleTitle,
      articleMainImage: record.articleMainImage,
      article: record.article,
      uid: record.uid,
    );
  }
}
