import 'package:firebase_articles/util/connection/no_connection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'enum.dart';

class NetworkSensitive  extends StatelessWidget {
  final Widget child;
  NetworkSensitive({this.child});
  @override
  Widget build(BuildContext context) {
    // Get our connection status from the provider
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    if (connectionStatus == ConnectivityStatus.WiFi) {
      return child;
    }

    if (connectionStatus == ConnectivityStatus.Cellular) {
      return child;
    }

    return NoInternetConnection();
  }
}