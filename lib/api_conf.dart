import 'package:flutter/foundation.dart';

class Api {
  String _url;
  String _username;
  String _password;

  Api(this._url);

  setPassword(String password) => _password=password;
  setUsername(String username) => _username=username;

  get url => _url;
  get username => _username;
  get password => _password;

  get httprpcPluginUrl => url+'/plugins/httprpc/action.php';
  get addTorrentUrl => url + '/php/addtorrent.php';

}