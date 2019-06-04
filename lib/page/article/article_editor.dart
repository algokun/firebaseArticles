import 'dart:convert';
import 'package:firebase_articles/page/home.dart';
import 'package:firebase_articles/services/post_articles.dart';
import 'package:firebase_articles/util/image_delegate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zefyr/zefyr.dart';

class ArticleEditor extends StatefulWidget {
  final String uid, articleMainImage,articleTitle;

  const ArticleEditor({this.uid, this.articleMainImage, this.articleTitle});


  @override
  _ArticleEditorState createState() => _ArticleEditorState();
}

class _ArticleEditorState extends State<ArticleEditor> {
  ZefyrController _controller;
  FocusNode _focusNode;
  final document = new NotusDocument();
  final textNote = "Note : Image Upload will take time. Be Patient";
  
  bool isProgressVisible = false;
  bool isEditorOpen = true;
  String article;
  @override
  void initState() {
    super.initState();
    document.insert(0, textNote);
    _controller = new ZefyrController(document);
    _focusNode = new FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit" , style: TextStyle(color: Colors.blue,),),
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          bottom: bottomBuilder(context),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.blue,
              child: Text("DONE"),
              onPressed: () async{
                saveArticle();
              },
            )
          ],
        ),
        body: ZefyrScaffold(
          child: ZefyrEditor(
            padding: EdgeInsets.all(20.0),
            controller: _controller,
            focusNode: _focusNode,
            imageDelegate: ArticleImage(),
            enabled: isEditorOpen,      
          ),
        ),
      ),
    );
  }

  saveDocument(){
    var jsonData = _controller.document;
    String jsonDoc = json.encode(jsonData);
    
    setState(() {
      article = jsonDoc;
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    document.close();
    super.dispose();
  }

  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Unsaved data will be lost.'),
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

  Widget bottomBuilder(BuildContext context){
    return PreferredSize(
      preferredSize: Size(double.infinity , 5.0),
      child: Visibility(
        visible: isProgressVisible,
        child: LinearProgressIndicator(),
      ),
    );
  }

  saveArticle() async{
    setState(() {
     this.isEditorOpen = false; 
    });
    
    saveDocument();
    changeProgress();
    
    PostArtcile postArtcile = PostArtcile(
      article: article,
      articleMainImage: widget.articleMainImage,
      articleTitle: widget.articleTitle,
      uid: widget.uid
    );
    
    await postArtcile.uploadArticleData();
    
    changeProgress();
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => HomePage.fromPrefs(preferences)
    ));
  }

  changeProgress(){
    setState(() {
      this.isProgressVisible = !this.isProgressVisible;
    });
  }
}