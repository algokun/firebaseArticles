import 'dart:io';

import 'package:firebase_articles/page/article/article_editor.dart';
import 'package:firebase_articles/services/storage.dart';
import 'package:firebase_articles/util/compressor.dart';
import 'package:flutter/material.dart';

class AddArticle extends StatefulWidget {
  final String userName, userPic, userId , name;

  const AddArticle({this.userName, this.userPic, this.userId , this.name});

  @override
  _AddArticleState createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {

  File uploadFile;

  TextEditingController _controller = TextEditingController();

  bool isProgressVisible = false;

  bool isButtonEnabled = true;

  String downloadUrl;

  @override
  Widget build(BuildContext context) {
    
    precacheImage(NetworkImage(widget.userPic), context);
    
    final baseTheme = Theme.of(context);
    final baseTextTheme = baseTheme.textTheme;

    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  padding: EdgeInsets.all(15.0),
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Visibility(
                  visible: uploadFile == null ? false : _controller.text.isEmpty ? false : true,
                  child: FlatButton(
                    padding: EdgeInsets.all(15.0),
                    textTheme: ButtonTextTheme.accent,
                    child: Text("Next"),
                    onPressed: isButtonEnabled ? () {
                      moveNextPage(this.context);
                    } : (){
                    },
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: isProgressVisible,
            child: LinearProgressIndicator(),
          ),
          Container(
            padding: EdgeInsets.only(left: 18.0, top: 10.0),
            child: Text(
              "Write Article",
              style: baseTextTheme.headline
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.userPic),
                    radius: 30,
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "\n"+widget.name,
                          style: baseTextTheme.title.copyWith(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: "\n@${widget.userName}\n",
                          style: baseTextTheme.subhead,
                        ),
                      ]
                    )
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _controller,
              maxLength: 50,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "Article Title",
                hintStyle: baseTextTheme.title.copyWith(color: Colors.blueGrey),
                border: InputBorder.none,
                helperText: "* Mandatory"
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                margin: EdgeInsets.only(top: 10.0),
                child: FlatButton.icon(
                  icon: Icon(Icons.camera_alt),
                  label: Text("Article Main Image"),
                  onPressed: () {
                    getImage();
                  },
                  textTheme: ButtonTextTheme.accent,
                )),
          ),
          Visibility(
            visible: !(uploadFile == null),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 18.0),
                width: 100,
                height: 100,
                child: uploadFile == null
                    ? Image.asset("assets/placeholder.jpg")
                    : Image.file(uploadFile),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future getImage() async {
    setState(() {
      isProgressVisible = true;
    });

    CompressImage compressImage = CompressImage();
    File compressedFile = await compressImage.takePicture(context);
    
    String url = await StorageToolKit().uploadTask(compressedFile, false);

    setState(() {
      uploadFile = compressedFile;
      isProgressVisible = false;
      downloadUrl = url;
    });
  }

  moveNextPage(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ArticleEditor(
        uid: widget.userId,
        articleMainImage: downloadUrl,
        articleTitle: _controller.text,
      )
    ));
  }
}
