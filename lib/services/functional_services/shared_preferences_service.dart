
import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/logger.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';
Logger log = getLogger("SharedPreferencesService");

class SharedPreferencesService {

  String accountsData = 'data';
  SharedPreferences _store;

  Future<SharedPreferences> store() async {
    if (_store == null) {
      _store = await SharedPreferences.getInstance();
    }
    return _store;
  }

  saveLogin(List<Account> accounts) async {
    final String data = encodeAccounts(accounts);
    SharedPreferences prefs = await store();
    prefs.setString(accountsData, data);
  }

  Future<List<Account>> fetchSavedLogin() async {
    SharedPreferences prefs = await store();
    if (prefs.containsKey(accountsData))
      return decodeAccounts(prefs.getString(accountsData));
    else
      return [];
  }

  clearLogin() async {
    SharedPreferences prefs = await store();
    prefs.remove(accountsData);
  }

  String encodeAccounts(List<Account> accounts) => json.encode(
        accounts
            .map<Map<String, dynamic>>((account) => account.toJson())
            .toList(),
      );

  List<Account> decodeAccounts(String data) {
    return (json.decode(data) as List<dynamic>)
        .map<Account>((item) => Account.fromJson(item))
        .toList();
  }

}