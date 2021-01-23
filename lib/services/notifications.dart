import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) {
      return;
    });

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  }

  /// Public Method to generate Notification
  generate(String header, String body) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      header,
      body,
      platformChannelSpecifics,
      payload: null,
    );
  }
}
