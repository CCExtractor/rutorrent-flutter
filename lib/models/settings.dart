import 'package:flutter/foundation.dart';

class Settings extends ChangeNotifier {
  static const String kAllNotification = 'allNotification';
  static const String kDiskSpaceNotifications = 'diskSpaceNotification';
  static const String kAddTorrentNotifications = 'addTorrentNotification';
  static const String kDownloadCompleteNotification =
      'downloadCompleteNotification';
  static const String kShowDarkMode = 'showDarkMode';

  bool _allNotificationEnabled = true;
  bool _diskSpaceNotification = true;
  bool _addTorrentNotification = true;
  bool _downloadCompleteNotification = true;
  bool _showDarkMode = false;

  bool get allNotificationEnabled => _allNotificationEnabled;
  bool get diskSpaceNotification =>
      _diskSpaceNotification && _allNotificationEnabled;
  bool get addTorrentNotification =>
      _addTorrentNotification && _allNotificationEnabled;
  bool get downloadCompleteNotification =>
      _downloadCompleteNotification & _allNotificationEnabled;
  bool get showDarkMode => _showDarkMode;

  void setSettings(Settings newSettings) {
    _allNotificationEnabled = newSettings.allNotificationEnabled;
    _diskSpaceNotification = newSettings.diskSpaceNotification;
    _addTorrentNotification = newSettings.addTorrentNotification;
    _downloadCompleteNotification = newSettings.downloadCompleteNotification;
    _showDarkMode = newSettings.showDarkMode;
  }

  void toggleAllNotificationsEnabled() {
    _allNotificationEnabled = !allNotificationEnabled;
    notifyListeners();
  }

  void toggleDiskSpaceNotification() {
    _diskSpaceNotification = !diskSpaceNotification;
    notifyListeners();
  }

  void toggleAddTorrentNotification() {
    _addTorrentNotification = !addTorrentNotification;
    notifyListeners();
  }

  void toggleDownloadCompleteNotification() {
    _downloadCompleteNotification = !downloadCompleteNotification;
    notifyListeners();
  }

  void setAllNotification(bool newVal) {
    _allNotificationEnabled = newVal;
    notifyListeners();
  }

  void setDiskSpaceNotification(bool newVal) {
    _diskSpaceNotification = newVal;
    notifyListeners();
  }

  void setAddTorrentNotification(bool newVal) {
    _addTorrentNotification = newVal;
    notifyListeners();
  }

  void setDownloadCompleteNotification(bool newVal) {
    _downloadCompleteNotification = newVal;
    notifyListeners();
  }

  void setShowDarkMode(bool isDarkMode) {
    _showDarkMode = isDarkMode;
    notifyListeners();
  }
}
