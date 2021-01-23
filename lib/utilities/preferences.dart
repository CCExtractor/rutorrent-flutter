import 'dart:convert';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  /// Saving and fetching [Settings] from [Preferences]
  static saveSettings(Settings settings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Settings.kAllNotification, settings.allNotificationEnabled);
    prefs.setBool(
        Settings.kDiskSpaceNotifications, settings.diskSpaceNotification);
    prefs.setBool(
        Settings.kAddTorrentNotifications, settings.addTorrentNotification);
    prefs.setBool(Settings.kDownloadCompleteNotification,
        settings.downloadCompleteNotification);
    prefs.setBool(Settings.kShowDarkMode, settings.showDarkMode);
  }

  static fetchSettings() async {
    Settings settings = Settings();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(Settings.kAllNotification))
      settings.setAllNotification(prefs.getBool(Settings.kAllNotification));

    if (prefs.containsKey(Settings.kDiskSpaceNotifications))
      settings.setDiskSpaceNotification(
          prefs.getBool(Settings.kDiskSpaceNotifications));

    if (prefs.containsKey(Settings.kAddTorrentNotifications))
      settings.setAddTorrentNotification(
          prefs.getBool(Settings.kAddTorrentNotifications));

    if (prefs.containsKey(Settings.kDownloadCompleteNotification))
      settings.setDownloadCompleteNotification(
          prefs.getBool(Settings.kDownloadCompleteNotification));

    if (prefs.containsKey(Settings.kShowDarkMode))
      settings.setShowDarkMode(prefs.getBool(Settings.kShowDarkMode));

    return settings;
  }

  /// Saving and fetching [Apis] from [Preferences]

  static const String accountsData = 'data';

  static clearLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(accountsData);
  }

  static saveLogin(List<Api> apis) async {
    final String data = Preferences.encodeApis(apis);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(accountsData, data);
  }

  static Future<List<Api>> fetchSavedLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(accountsData))
      return decodeApis(prefs.getString(accountsData));
    else
      return [];
  }

  static Api fromJson(Map<String, dynamic> jsonData) {
    Api api = Api();
    api.setUrl(jsonData['url']);
    api.setUsername(jsonData['username']);
    api.setPassword(jsonData['password']);
    return api;
  }

  static Map<String, dynamic> toMap(Api api) => {
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
        .map<Api>((item) => Preferences.fromJson(item))
        .toList();
  }
}
