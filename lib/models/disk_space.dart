
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DiskSpace{
  //Alert or Notification will be generated when the diskSpace is lower than mentioned critical percentage
  static int criticalPercentage = 10;

  //Initialised with random val to prevent Null Exception
  int total=1;
  int free=0;

  bool alertUser = true;

  update(int total,int free){
    this.total = total;
    this.free = free;
  }

  int getPercentage(){
    if(total==1 && free==0)
      return criticalPercentage;
    return (((total - free) * 100) ~/ total) ?? 0;
  }

  bool isLow() => 100-getPercentage() < criticalPercentage;

  generateLowDiskSpaceAlert() async{
    //Using flutter local Notifications to generate Alert
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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
    var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Low Disk Space',
      'You are low on disk space. Free some space',
      platformChannelSpecifics,
      payload: null,
    );

    alertUser = false;
  }
}
