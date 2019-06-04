import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_articles/page/article/article_item.dart';
import 'package:firebase_articles/util/models/article.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ViewProfile extends StatefulWidget {
  final String userName, name, userID;

  const ViewProfile({
    this.userName,
    this.name,
    this.userID,
  });

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text("@" + widget.userName),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            StreamBuilder<DocumentSnapshot>(
                stream: Stream.fromFuture(Firestore.instance
                    .collection("users")
                    .document(widget.userID)
                    .get()),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[400],
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 50.0,
                              ),
                            ],
                          ),
                        ));
                  }
                  return Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                              NetworkImage(snapshot.data['userpic']),
                        ),
                        SizedBox(
                          width: 50.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              snapshot.data['name'],
                              style: Theme.of(context).textTheme.headline,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              '@' + snapshot.data['username'] + '\n',
                              style: Theme.of(context).textTheme.subhead,
                            ),
                            Text(
                              snapshot.data['bio'],
                              style: Theme.of(context)
                                  .textTheme
                                  .subhead
                                  .copyWith(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
            SizedBox(
              height: 10.0,
            ),
            Divider(),
            Expanded(
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection("articles")
                        .where('uid', isEqualTo: widget.userID)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                            child: CircularProgressIndicator(),
                            alignment: Alignment.center);
                      }
                      return ListView(
                          shrinkWrap: true,
                          children: snapshot.data.documents
                              .map((data) => _buildListItem(context, data))
                              .toList());
                    }),
              ),
            ),
          ],
        ),
      ),
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
