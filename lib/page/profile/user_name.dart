import 'package:firebase_articles/services/profile.dart';
import 'package:firebase_articles/util/bloc/username_bloc.dart';
import 'package:flutter/material.dart';

class ProfileUserName extends StatefulWidget {
  final PageController controller;
  ProfileUserName({this.controller});
  @override
  _ProfileUserNameState createState() => _ProfileUserNameState();
}

class _ProfileUserNameState extends State<ProfileUserName> {
  UsernameBloc bloc = UsernameBloc();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        StreamBuilder<String>(
            stream: null,
            builder: (context, snapshot) {
              return Text(
                "Choose \nUsername",
                style: Theme.of(context)
                    .textTheme
                    .display2
                    .copyWith(color: Colors.black),
              );
            }),
        StreamBuilder<String>(
            stream: bloc.username,
            builder: (context, snapshot) {
              return TextField(
                maxLength: 15,
                onChanged: bloc.nameChanged,
                decoration: InputDecoration(
                  prefixText: "@",
                  errorText: snapshot.error,
                  labelText: 'Username',
                  counterText: "",
                ),
              );
            }),
        Align(
          alignment: Alignment.centerRight,
          child: StreamBuilder<String>(
              stream: bloc.username,
              builder: (context, snapshot) {
                return RaisedButton(
                  color: Colors.blue,
                  onPressed: snapshot.hasData
                      ? snapshot.hasError
                          ? null
                          : () => setUserName(snapshot.data)
                      : null,
                  textColor: Colors.white,
                  child: Text("Next"),
                );
              }),
        )
      ],
    );
  }

  moveNextPage() {
    widget.controller.animateToPage(1,
        duration: Duration(microseconds: 500), curve: Curves.linearToEaseOut);
  }

  setUserName(String userName) async {
    ProfileInfo profileInfo = ProfileInfo();
    await profileInfo.init();
    await profileInfo.storeUserName(userName);
    moveNextPage();
  }
}
