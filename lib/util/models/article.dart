import 'package:cloud_firestore/cloud_firestore.dart';

class ModelArticle {
  final String article, articleMainImage, articleTitle, uid;
  final Timestamp timeStamp;
  final DocumentReference reference;

  ModelArticle.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['article'] != null),
        assert(map['articleMainImage'] != null),
        assert(map['articleTitle'] != null),
        assert(map['uid'] != null),
        assert(map['timeStamp'] != null),
        article = (map['article']),
        articleMainImage = map['articleMainImage'],
        articleTitle = map['articleTitle'],
        uid = map['uid'],
        timeStamp = map['timeStamp'];

  ModelArticle.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$article>";
}
