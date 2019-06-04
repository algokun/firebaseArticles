import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_articles/page/article/view_article.dart';
import 'package:flutter/material.dart';

class ArticleItem extends StatelessWidget {
  final String articleTitle, articleMainImage, article, uid;
  final List<DocumentSnapshot> userDataSnap;
  const ArticleItem(
      {this.articleTitle,
      this.articleMainImage,
      this.article,
      this.uid,
      this.userDataSnap});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: Firestore.instance.collection("users").document(uid).get(),
        builder: (context, snapshot) {
          String userpic =
              "https://i0.wp.com/www.winhelponline.com/blog/wp-content/uploads/2017/12/user.png";
          String name = "";
          String userName = "";

          if (snapshot.hasData) {
            userName = snapshot.data['username'];
            name = snapshot.data['name'];
            userpic = snapshot.data['userpic'];
          }

          return Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey.shade200,
                    width: 2.0,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(userpic),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: name,
                          style: Theme.of(context).textTheme.subhead),
                      TextSpan(
                        text: "\n@" + userName,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(color: Colors.blueGrey),
                      ),
                    ])),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ViewArticle(
                                article: article,
                                name: name,
                                username: userName,
                                userPic: userpic,
                                uid: uid,
                              )));
                    },
                    child: FadeInImage.assetNetwork(
                      image: articleMainImage,
                      fit: BoxFit.fitWidth,
                      placeholder: "assets/placeholder.jpg",
                    )
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  articleTitle,
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          );
        });
  }
}
