import 'dart:io';
import 'package:firebase_articles/services/profile.dart';
import 'package:firebase_articles/util/compressor.dart';

import 'package:flutter/material.dart';

class ProfileImagePicker extends StatefulWidget {
  final PageController controller;
  ProfileImagePicker({this.controller});
  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File profileImage;
  bool enabled = true;
  bool isProgressVisible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text.rich(TextSpan(children: [
          TextSpan(
            text: "Add a profile picture",
            style: Theme.of(context)
                .textTheme
                .display2
                .copyWith(color: Colors.black),
          ),
          TextSpan(
              text: "\n\nShow them how awesome you are.\n\n",
              style: Theme.of(context).textTheme.subhead)
        ])),
        Container(
            child: Stack(children: <Widget>[
          GestureDetector(
            onTap: () => getImage(),
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width / 4,
              backgroundImage: profileImage == null
                  ? AssetImage("assets/user_add_image.png")
                  : FileImage(profileImage),
              backgroundColor: Colors.blue,
            ),
          ),
          Visibility(
            visible: isProgressVisible,
            child: SizedBox(
              height: MediaQuery.of(context).size.width / 2,
              width: MediaQuery.of(context).size.width / 2,
              child: CircularProgressIndicator(),
            ),
          ),
        ])),
        Align(
          alignment: Alignment.centerRight,
          child: RaisedButton(
            color: Colors.blue,
            onPressed:
                profileImage != null ? enabled ? () => setImage() : null : null,
            textColor: Colors.white,
            child: Text("Next"),
          ),
        )
      ],
    );
  }

  moveNextPage() {
    widget.controller.animateToPage(2,
        duration: Duration(microseconds: 500), curve: Curves.linearToEaseOut);
  }

  Future getImage() async {
    
    setState(() {
      isProgressVisible = true;
    });

    var image = await CompressImage().takePicture(context);
    
    setState(() {
      profileImage = image;
      isProgressVisible = false; 
    });
  }

  Future setImage() async {
    setState(() {
      enabled = false;
      isProgressVisible = true;
    });
    ProfileInfo profileInfo = ProfileInfo();
    await profileInfo.init();
    await profileInfo.storeUserImage(profileImage);
    moveNextPage();
  }
}
