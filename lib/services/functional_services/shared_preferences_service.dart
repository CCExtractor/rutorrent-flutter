import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

Logger log = getLogger("SharedPreferencesService");

class SharedPreferencesService {
  String accountsData = 'data';
  SharedPreferences? _store;

  // ignore: non_constant_identifier_names
  Box DB = Hive.box("DB");

  Future<SharedPreferences?> store() async {
    if (_store == null) {
      _store = await SharedPreferences.getInstance();
    }
    return _store;
  }

  saveLogin(List<Account?> accounts) async {
    final String data = _encodeAccounts(accounts);
    final prefs = await store();
    prefs?.setString(accountsData, data);
  }

  Future<List<Account?>> fetchSavedLogin() async {
    final prefs = await store();
    if (prefs?.containsKey(accountsData) ?? false)
      return _decodeAccounts(prefs?.getString(accountsData));
    else
      return [];
  }

  clearLogin() async {
    final prefs = await store();
    prefs?.remove(accountsData);
  }

  String _encodeAccounts(List<Account?> accounts) => json.encode(
        accounts
            .map<Map<String, dynamic>>((account) => account!.toJson())
            .toList(),
      );

  List<Account?> _decodeAccounts(String? data) {
    return (json.decode(data!) as List<dynamic>)
        .map<Account?>((item) => Account.fromJson(item))
        .toList();
  }
}
