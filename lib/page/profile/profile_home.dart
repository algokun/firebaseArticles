import 'package:firebase_articles/page/profile/done.dart';
import 'package:firebase_articles/util/connection/nw_sense.dart';

import 'user_profile.dart';

import 'user_name.dart';
import 'package:flutter/material.dart';

import 'profile_image.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  double value = 0.25;
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return NetworkSensitive(
        child: Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        margin: const EdgeInsets.all(25.0),
        child: PageView.builder(
          controller: controller,
          itemBuilder: (context, index) => displayPage(index),
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (index) => onPageChanged(index),
        ),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size(double.infinity, 20.0),
        child: SizedBox(
          height: 10,
          child: LinearProgressIndicator(
            value: value,
          ),
        ),
      ),
    ));
  }

  void onPageChanged(int index) {
    switch (index) {
      case 0:
        setState(() {
          value = 0.25;
        });
        break;
      case 1:
        setState(() {
          value = .50;
        });
        break;
      case 2:
        setState(() {
          value = .75;
        });
        break;
      case 3:
        setState(() {
          value = 1.0;
        });
        break;
      default:
    }
  }

  Widget displayPage(int index) {
    switch (index) {
      case 1:
        return ProfileImagePicker(
          controller: controller,
        );
        break;
      case 2:
        return UserProfile(
          controller: controller,
        );
        break;
      case 3:
        return ProfileDone(this.context);
        break;
      default:
        return ProfileUserName(
          controller: controller,
        );
    }
  }
}
