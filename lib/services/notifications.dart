import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications{
  /// Using flutter local Notifications to generate Alert

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var platformChannelSpecifics;

  Notifications(){
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(initializationSettingsAndroid,initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: (String payload){
          return;
        });

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  }

  generate(String header,String body) async{
    await flutterLocalNotificationsPlugin.show(
      0,
      header,
      body,
      platformChannelSpecifics,
      payload: null,
    );
  }
}