///Immutable information required for all services are stored here
class ServicesInfo{

  //Notification_Service.dart 
  static const new_torrent_added_notification_title = "New Torrent Added ⬆️ !";
  static const new_torrent_added_notification_body = "A new torrent has been added";
  static const download_completed_notification_title = "Download Completed ✔️ !";
  static const download_completed_notification_body = "The Torrent has been downloaded";
  static const low_disk_space_notification_title = "Low Disk Space ⚠️ !";
  static const low_disk_space_notification_body = "Your account has low disk space";

  
}

extension CustomizableDateTime on DateTime {
  static DateTime? _customTime;
  static DateTime get current {
    return _customTime ?? DateTime.now();
  }

  static set customTime(DateTime customTime) {
    _customTime = customTime;
  }
}