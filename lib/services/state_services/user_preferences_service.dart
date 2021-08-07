import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/services/functional_services/shared_preferences_service.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';

Logger log = getLogger("UserPreferencesService");

///[Service] for keeping track of User Data
class UserPreferencesService {
  SharedPreferencesService? _sharedPreferencesService =
      locator<SharedPreferencesService>();

  TextEditingController searchTextController = TextEditingController();
  bool showAllAccounts = false;
  bool _allNotificationEnabled = true;
  bool _diskSpaceNotification = true;
  bool _addTorrentNotification = true;
  bool _downloadCompleteNotification = true;

  get allNotificationEnabled => _allNotificationEnabled;
  get diskSpaceNotification =>
      _diskSpaceNotification && _allNotificationEnabled;
  get addTorrentNotification =>
      _addTorrentNotification && _allNotificationEnabled;
  get downloadCompleteNotification =>
      _downloadCompleteNotification && _allNotificationEnabled;

  init() {
    // ignore: non_constant_identifier_names
    Box DB = _sharedPreferencesService!.DB;
    showAllAccounts = DB.get("showAllAccounts") ?? false;
    int sortPreferenceIdx = DB.get("sortPreference", defaultValue: 6);
    TorrentService _torrentService = locator<TorrentService>();
    _torrentService.setSortPreference(Sort.values[sortPreferenceIdx]);
    _allNotificationEnabled = DB.get("allNotificationEnabled") ?? true;
    _diskSpaceNotification = DB.get("diskSpaceNotification") ?? true;
    _addTorrentNotification = DB.get("addTorrentNotification") ?? true;
    _downloadCompleteNotification =
        DB.get("downloadCompleteNotification") ?? true;
  }

  setShowAllAccounts(bool showAccounts) {
    showAllAccounts = showAccounts;
    log.v("ShowAllAccounts set to " + showAllAccounts.toString());
    _sharedPreferencesService!.DB.put("showAllAccounts", showAllAccounts);
  }

  toggleShowAllAccounts() {
    showAllAccounts = !showAllAccounts;
    log.v("ShowAllAccounts set to " + showAllAccounts.toString());
    _sharedPreferencesService!.DB.put("showAllAccounts", showAllAccounts);
  }

  toggleAllNotificationsEnabled() {
    _allNotificationEnabled = !allNotificationEnabled;
    log.v(
        "AllNotificationsEnabled set to " + _allNotificationEnabled.toString());
    _sharedPreferencesService!.DB
        .put("allNotificationEnabled", _allNotificationEnabled);
  }

  toggleDiskSpaceNotification() {
    _diskSpaceNotification = !diskSpaceNotification;
    log.v("DiskSpaceNotification set to " + diskSpaceNotification.toString());
    _sharedPreferencesService!.DB
        .put("diskSpaceNotification", _diskSpaceNotification);
  }

  toggleAddTorrentNotification() {
    _addTorrentNotification = !addTorrentNotification;
    log.v("AddTorrentNotification set to " + addTorrentNotification.toString());
    _sharedPreferencesService!.DB
        .put("addTorrentNotification", _addTorrentNotification);
  }

  toggleDownloadCompleteNotification() {
    _downloadCompleteNotification = !downloadCompleteNotification;
    log.v("DownloadCompleteNotification set to " +
        downloadCompleteNotification.toString());
    _sharedPreferencesService!.DB
        .put("downloadCompleteNotification", _downloadCompleteNotification);
  }

  setAllNotification(bool newVal) {
    _allNotificationEnabled = newVal;
    log.v("AllNotification set to " + newVal.toString());
    _sharedPreferencesService!.DB
        .put("allNotificationEnabled", _allNotificationEnabled);
  }

  setDiskSpaceNotification(bool newVal) {
    log.v("DiskSpaceNotification set to " + newVal.toString());
    _diskSpaceNotification = newVal;
    _sharedPreferencesService!.DB
        .put("diskSpaceNotification", _diskSpaceNotification);
  }

  setAddTorrentNotification(bool newVal) {
    log.v("addTorrentNotification set to " + newVal.toString());
    _addTorrentNotification = newVal;
    _sharedPreferencesService!.DB
        .put("addTorrentNotification", _addTorrentNotification);
  }

  setDownloadCompleteNotification(bool newVal) {
    log.v("DownloadCompleteNotification set to " + newVal.toString());
    _downloadCompleteNotification = newVal;
    _sharedPreferencesService!.DB
        .put("downloadCompleteNotification", _downloadCompleteNotification);
  }
}
