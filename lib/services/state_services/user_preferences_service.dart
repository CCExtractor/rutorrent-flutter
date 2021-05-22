import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/services/functional_services/shared_preferences_service.dart';

Logger log = getLogger("ApiService");

///[Service] for keeping track of User Data
class UserPreferencesService {
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

  bool showAllAccounts = false;
  TextEditingController searchTextController = TextEditingController();

  init() {
    showAllAccounts =
        _sharedPreferencesService.DB.get("showAllAccounts") ?? false;
  }
}
