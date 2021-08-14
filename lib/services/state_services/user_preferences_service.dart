import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:package_info/package_info.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/services/functional_services/shared_preferences_service.dart';
import 'package:rutorrentflutter/services/state_services/disk_file_service.dart';
import 'package:rutorrentflutter/services/state_services/history_service.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';
import 'package:rutorrentflutter/theme/app_state_notifier.dart';

Logger log = getLogger("UserPreferencesService");

///Service for keeping track of [User] Data
class UserPreferencesService {
  SharedPreferencesService? _sharedPreferencesService =
      locator<SharedPreferencesService>();

  TextEditingController searchTextController = TextEditingController();
  bool showAllAccounts = false;
  bool _allNotificationEnabled = true;
  bool _diskSpaceNotification = true;
  bool _addTorrentNotification = true;
  bool _downloadCompleteNotification = true;
  bool _isDarkModeOn = false;
  late PackageInfo _packageInfo;

  get allNotificationEnabled => _allNotificationEnabled;
  get diskSpaceNotification =>
      _diskSpaceNotification && _allNotificationEnabled;
  get addTorrentNotification =>
      _addTorrentNotification && _allNotificationEnabled;
  get downloadCompleteNotification =>
      _downloadCompleteNotification && _allNotificationEnabled;
  get isDarkModeOn => _isDarkModeOn;
  get packageInfo => _packageInfo;

  init() {

    //Fetch all User Preferences from local storage
    //And restore state

    TorrentService _torrentService = locator<TorrentService>();
    DiskFileService _diskFileService = locator<DiskFileService>();
    HistoryService _historyService = locator<HistoryService>();
    AppStateNotifier _appStateNotifier = locator<AppStateNotifier>();

    // ignore: non_constant_identifier_names
    Box DB = _sharedPreferencesService!.DB;
    showAllAccounts = DB.get("showAllAccounts") ?? false;
    _isDarkModeOn = DB.get("isDarkModeOn") ?? false;
    int sortPreferenceIdx = DB.get("sortPreference", defaultValue: 6);
    int sortPreferenceIdxDiskFile = DB.get("sortPreference_diskFiles", defaultValue: 6);
    int sortPreferenceIdxHistory = DB.get("sortPreferenceHistory", defaultValue: 6);
    _torrentService.setSortPreference(Sort.values[sortPreferenceIdx]);
    _diskFileService.setSortPreference(Sort.values[sortPreferenceIdxDiskFile]);
    _historyService.setSortPreference(Sort.values[sortPreferenceIdxHistory]);
    _allNotificationEnabled = DB.get("allNotificationEnabled") ?? true;
    _diskSpaceNotification = DB.get("diskSpaceNotification") ?? true;
    _addTorrentNotification = DB.get("addTorrentNotification") ?? true;
    _downloadCompleteNotification =
        DB.get("downloadCompleteNotification") ?? true;
        //todo remove
    print(_isDarkModeOn);
    _appStateNotifier.updateTheme(_isDarkModeOn);
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

  setDarkMode(bool newVal) {
    log.v("DarkMode set to " + newVal.toString());
    _isDarkModeOn = newVal;
    _sharedPreferencesService!.DB
        .put("isDarkModeOn", _isDarkModeOn);
  }
  
  setPackageInfo(PackageInfo newVal) {
    //Application Version will not be saved to local storage
    //Since we want it to be fetched everytime user opens application
    log.v("PackageInfo Received ${newVal.version}");
    _packageInfo = newVal;
  }
}
