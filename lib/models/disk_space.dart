import 'package:rutorrentflutter/services/notifications.dart';

class DiskSpace {
  //Alert or Notification will be generated when the diskSpace is lower than mentioned critical percentage
  static int criticalPercentage = 10;

  //Initialised with random val to prevent Null Exception
  int total = 1;
  int free = 0;

  // This field ensures user is notified only once and also alert can be switched off from the Settings
  bool alertUser = true;

  update(int total, int free) {
    this.total = total;
    this.free = free;
  }

  int getPercentage() {
    if (total == 1 && free == 0) return criticalPercentage;
    return (((total - free) * 100) ~/ total) ?? 0;
  }

  bool isLow() => 100 - getPercentage() < criticalPercentage;

  generateLowDiskSpaceAlert(Notifications notifications) async {
    notifications.generate(
        'Low Disk Space', 'You are low on disk space. Free some space');
    alertUser = false;
  }
}
