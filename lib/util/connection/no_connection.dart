import 'package:firebase_articles/util/images.dart';
import 'package:flutter/material.dart';

class NoInternetConnection extends StatelessWidget with ImageData {
  @override
  Widget build(BuildContext context) {
    return Material(
      color : Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(noInternet),
          Text(
              "Oops!\n",
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .copyWith(color: Colors.blue)),
          Wrap(
            children: <Widget>[
              Text("It seems you dont have an active internet connection",),
              Text("Please check your internet settings",),

            ],
          )
        ],
      ),
    );
  }
}
