import 'package:firebase_articles/page/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'page/home.dart';
import 'util/connection/connectivity_service.dart';
import 'util/connection/nw_sense.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    '/home': (BuildContext context) => HomePage()
  };
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider(
      builder: (context) => ConnectivityService().connectionStatusController,
      child: MaterialApp(
        title: "Articles",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: "MainFont",
        ),
        home: NetworkSensitive(
          child: SplashScreen(),
        ),
        debugShowCheckedModeBanner: false,
        routes: routes,
      ),
    );
  }
}
