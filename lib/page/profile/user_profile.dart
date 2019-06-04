import 'package:firebase_articles/services/profile.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  final PageController controller;
  UserProfile({this.controller});
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "More \nabout you\n",
          style: Theme.of(context)
              .textTheme
              .display2
              .copyWith(color: Colors.black),
        ),
        TextField(
          controller: nameController,
          maxLength: 15,
          decoration: InputDecoration(
            labelText: 'Your Name',
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          maxLength: 150,
          decoration: InputDecoration(
            labelText: 'Bio',
          ),
        ),
        Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: RaisedButton(
            color: Colors.blue,
            onPressed: nameController.text.isEmpty ? null : () => setProfile(),
            textColor: Colors.white,
            child: Text("Next"),
          ),
        )
      ],
    );
  }

  moveNextPage() {
    widget.controller.animateToPage(3,
        duration: Duration(microseconds: 500), curve: Curves.linearToEaseOut);
  }

  setProfile() async {
    ProfileInfo profileInfo = ProfileInfo();
    await profileInfo.init();
    await profileInfo.storeProfile(nameController.text, controller.text);
    moveNextPage();
  }
}
