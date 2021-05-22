import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/services/functional_services/shared_preferences_service.dart';

Logger log = getLogger("ApiService");

///[Service] for keeping track of User Data
class UserPreferencesService {
  SharedPreferencesService? _sharedPreferencesService =
      locator<SharedPreferencesService>();

  bool showAllAccounts = false;
  Sort sortPreference = Sort.none;
  TextEditingController searchTextController = TextEditingController();

  init() {
    Box DB = _sharedPreferencesService!.DB; 
    showAllAccounts = DB.get("showAllAccounts") ?? false;
    int sortPreferenceIdx = DB.get("sortPreference",defaultValue: 6);
    sortPreference = Sort.values[sortPreferenceIdx];

  }

  setSortPreference(Sort newPreference) {
    sortPreference = newPreference;
    _sharedPreferencesService!.DB.put("sortPreference",newPreference.index);
  }
}
