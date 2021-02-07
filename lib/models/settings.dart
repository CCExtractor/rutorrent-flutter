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

  get allNotificationEnabled => _allNotificationEnabled;
  get diskSpaceNotification =>
      _diskSpaceNotification && _allNotificationEnabled;
  get addTorrentNotification =>
      _addTorrentNotification && _allNotificationEnabled;
  get downloadCompleteNotification =>
      _downloadCompleteNotification & _allNotificationEnabled;
  get showDarkMode => _showDarkMode;

  setSettings(Settings newSettings) {
    _allNotificationEnabled = newSettings.allNotificationEnabled;
    _diskSpaceNotification = newSettings.diskSpaceNotification;
    _addTorrentNotification = newSettings.addTorrentNotification;
    _downloadCompleteNotification = newSettings.downloadCompleteNotification;
    _showDarkMode = newSettings.showDarkMode;
  }

  toggleAllNotificationsEnabled() {
    _allNotificationEnabled = !allNotificationEnabled;
    notifyListeners();
  }

  toggleDiskSpaceNotification() {
    _diskSpaceNotification = !diskSpaceNotification;
    notifyListeners();
  }

  toggleAddTorrentNotification() {
    _addTorrentNotification = !addTorrentNotification;
    notifyListeners();
  }

  toggleDownloadCompleteNotification() {
    _downloadCompleteNotification = !downloadCompleteNotification;
    notifyListeners();
  }

  setAllNotification(bool newVal) {
    _allNotificationEnabled = newVal;
    notifyListeners();
  }

  setDiskSpaceNotification(bool newVal) {
    _diskSpaceNotification = newVal;
    notifyListeners();
  }

  setAddTorrentNotification(bool newVal) {
    _addTorrentNotification = newVal;
    notifyListeners();
  }

  setDownloadCompleteNotification(bool newVal) {
    _downloadCompleteNotification = newVal;
    notifyListeners();
  }

  setShowDarkMode(bool isDarkMode) {
    _showDarkMode = isDarkMode;
    notifyListeners();
  }
}
