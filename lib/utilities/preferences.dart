import 'dart:convert';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  /// Saving and fetching [Settings] from [Preferences]
  static Future<void> saveSettings(Settings settings) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        Settings.kAllNotification, settings.allNotificationEnabled);
    await prefs.setBool(
        Settings.kDiskSpaceNotifications, settings.diskSpaceNotification);
    await prefs.setBool(
        Settings.kAddTorrentNotifications, settings.addTorrentNotification);
    await prefs.setBool(Settings.kDownloadCompleteNotification,
        settings.downloadCompleteNotification);
    await prefs.setBool(Settings.kShowDarkMode, settings.showDarkMode);
  }

  static Future<Settings> fetchSettings() async {
    var settings = Settings();
    var prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(Settings.kAllNotification)) {
      settings.setAllNotification(prefs.getBool(Settings.kAllNotification));
    }

    if (prefs.containsKey(Settings.kDiskSpaceNotifications)) {
      settings.setDiskSpaceNotification(
          prefs.getBool(Settings.kDiskSpaceNotifications));
    }

    if (prefs.containsKey(Settings.kAddTorrentNotifications)) {
      settings.setAddTorrentNotification(
          prefs.getBool(Settings.kAddTorrentNotifications));
    }

    if (prefs.containsKey(Settings.kDownloadCompleteNotification)) {
      settings.setDownloadCompleteNotification(
          prefs.getBool(Settings.kDownloadCompleteNotification));
    }

    if (prefs.containsKey(Settings.kShowDarkMode)) {
      settings.setShowDarkMode(prefs.getBool(Settings.kShowDarkMode));
    }

    return settings;
  }

  /// Saving and fetching [Apis] from [Preferences]

  static const String accountsData = 'data';

  static Future<void> clearLogin() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove(accountsData);
  }

  static Future<void> saveLogin(List<Api> apis) async {
    final data = Preferences.encodeApis(apis);
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(accountsData, data);
  }

  static Future<List<Api>> fetchSavedLogin() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(accountsData)) {
      return decodeApis(prefs.getString(accountsData));
    }
    return [];
  }

  static Api fromJson(Map<String, dynamic> jsonData) {
    var api = Api();
    api.setUrl(jsonData['url'].toString());
    api.setUsername(jsonData['username'].toString());
    api.setPassword(jsonData['password'].toString());
    return api;
  }

  static Map<String, dynamic> toMap(Api api) => <String, dynamic>{
        'url': api.url,
        'username': api.username,
        'password': api.password,
      };

  static String encodeApis(List<Api> apis) => json.encode(
        apis
            .map<Map<String, dynamic>>((api) => Preferences.toMap(api))
            .toList(),
      );

  static List<Api> decodeApis(String data) {
    return (json.decode(data) as List<dynamic>)
        .map<Api>((dynamic item) =>
            Preferences.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
