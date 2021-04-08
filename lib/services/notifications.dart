import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/utilities/constants.dart';

/// Notifications class using flutter local notifications to generate Alert

class Notifications {
  /// Initialization setting for both the platforms

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var platformChannelSpecifics;

  Notifications() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) {
      return;
    });
  }

  /// Public Method to generate Notification
  generate(String header, String body, NotificationChannelID id) async {
    //Setting Notification Channel ID, Name and Description
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        id.index.toString(),
        notificationInfo[id.index][0],
        notificationInfo[id.index][0],
        importance: Importance.max,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    //Notification ID
    Random random = new Random();
    int notificationId = random.nextInt(100);

    //Show notification to user
    await flutterLocalNotificationsPlugin.show(
      notificationId, // Index of enum element
      header,
      body,
      platformChannelSpecifics,
      payload: null,
    );
  }
}
