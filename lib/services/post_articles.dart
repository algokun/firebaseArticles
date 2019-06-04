import 'package:cloud_firestore/cloud_firestore.dart';

class PostArtcile {

  final String uid, articleMainImage, article, articleTitle;
  
  final articleRef = Firestore.instance.collection("articles");

  PostArtcile({this.uid, this.articleMainImage, this.article, this.articleTitle});

  uploadArticleData() async {
    await articleRef.add({
      'uid': uid,
      'timeStamp': Timestamp.fromDate(DateTime.now()),
      'articleTitle': articleTitle,
      'articleMainImage': articleMainImage,
      'article': article
    });
  }
}
