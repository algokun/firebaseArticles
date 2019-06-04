import 'dart:convert';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


mixin FCM {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future onMessage(Map<String, dynamic> message) async {
    final data = await message['data'];

    final settingsAndroid = AndroidInitializationSettings('icon');

    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(data.toString()));

    flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);

    _showBigPictureNotification(
        data['image'], data['author'], data['author_image'], data['title']);
  }

  Future onSelectNotification(String data) async {
    Map payload = await json.decode(data);

    print(payload);

    // await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => ViewArticle(
    //               article: payload['article'],
    //               name: payload['author'],
    //               uid: payload['uid'],
    //               userPic: payload['author_image'],
    //               username: payload['author_username'],
    //             )));
  }

  Future<void> _showBigPictureNotification(
      String bigUrl, String title, String smallUrl, String summary) async {
    var largeIconPath = await _downloadAndSaveImage(smallUrl, 'largeIcon');
    var bigPicturePath = await _downloadAndSaveImage(bigUrl, 'bigPicture');
    var bigPictureStyleInformation = BigPictureStyleInformation(
        bigPicturePath, BitmapSource.FilePath,
        largeIcon: largeIconPath,
        largeIconBitmapSource: BitmapSource.FilePath,
        contentTitle: title,
        htmlFormatContentTitle: true,
        summaryText: summary,
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        style: AndroidNotificationStyle.BigPicture,
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics =
        NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics);
  }
  
  Future<String> _downloadAndSaveImage(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future onLaunch(Map<String, dynamic> message) async {
    print("onLaunch: $message");
  }

  Future onResume(Map<String, dynamic> message) async {
    print("onResume: $message");
  }
}
