import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
Logger log = getLogger("NotificationsService");

class NotificationService {

  static const new_torrent_downloaded_notify = "NewTorrentDownload";
  static const download_completed_notify = "DownloadCompleted";
  static const low_disk_space_notify = "LowDiskSpace";
  static const new_torrent_downloaded_notify_id = 1;
  static const download_completed_notify_id = 2;
  static const low_disk_space_notify_id = 3;

  // Initialize Notification Services
  init() async {
    await AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        'resource://drawable/ic_launcher',
        [
            NotificationChannel(
                enableVibration: true,
                channelKey: new_torrent_downloaded_notify,
                channelName: 'New Torrent Download Notifications',
                channelDescription: 'Notification channel for New Torrent Downloads',
                defaultColor: Colors.green,
                ledColor: Colors.white
            ),
            NotificationChannel(
                enableVibration: true,
                channelKey: download_completed_notify,
                channelName: 'Download Completed Notifications',
                channelDescription: 'Notification channel for Notifying Completed Downloads',
                defaultColor: Colors.yellow,
                ledColor: Colors.white
            ),
            NotificationChannel(
                enableVibration: true,
                channelKey: low_disk_space_notify,
                channelName: 'Low Disk Space Notifications',
                channelDescription: 'Notification channel for Alerting low disk space',
                defaultColor: Colors.yellow,
                ledColor: Colors.white
            ),
        ]
    );
    AwesomeNotifications().actionStream.listen(
        (receivedNotification){
          log.e(receivedNotification.toString());
          handleLocalNotification(receivedNotification);
        }
    );
  }

  handleLocalNotification(ReceivedAction receivedNotification) {
    final payload = receivedNotification.payload;

    switch(receivedNotification.id){

      case new_torrent_downloaded_notify_id:
        //Add logic to execute when this notification is pressed by user
        break;

      case download_completed_notify_id:
        //Add logic to execute when this notification is pressed by user
        break;

      case low_disk_space_notify_id:
        //Add logic to execute when this notification is pressed by user
        break;

      default:
        break;

    }
  }

  /// **Function used to dispatch notifications**
  /// 
  /// @Param [Key] : Notification Channel Name 
  /// 
  /// @Param [customData] : Map with key [title] and key [body] 
  /// for the notification title and body.
  /// 
  /// **Example Call** :
  ///  
  /// `notificationMap = {`
  /// 
  /// `"title":"This is my title notification",`
  /// 
  /// `"body" : "This is the body of the notification`"
  /// 
  /// `}`
  /// 
  ///`dispatchLocalNotification( `
  ///
  ///`    key : _notificationService.< Notification_Channel_Name >, `
  ///
  ///`    customData : notificationsMap` 
  ///
  ///`)` 
  dispatchLocalNotification({required String key,required Map customData}) async {
    // If two notifications happen to have same IDs 
    // One will be replaced by the other, so to avoid
    // this scenario we generate a Random ID for a notification
    // that might be sent out several times
    int id = new Random().nextInt(500);

    switch(key){

      case new_torrent_downloaded_notify:
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: new_torrent_downloaded_notify_id,
              channelKey: new_torrent_downloaded_notify,
              title: customData["title"],
              body: customData["body"],
          )
        );
        break;
        
      case download_completed_notify:
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: download_completed_notify_id,
              channelKey: download_completed_notify,
              title: customData["title"],
              body: customData["body"],
          )
        );
        break;

      case low_disk_space_notify:
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: low_disk_space_notify_id,
              channelKey: low_disk_space_notify,
              title: customData["title"],
              body: customData["body"],
          )
        );
        break;

      default:
        break;
    }
  }
}