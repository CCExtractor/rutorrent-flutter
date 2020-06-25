import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  String _url;
  String _username;
  String _password;
  http.Client client = http.Client();

  Api(this._url);

  setPassword(String password) => _password=password;
  setUsername(String username) => _username=username;

  get url => _url;
  get username => _username;
  get password => _password;

  get httprpcPluginUrl => url+'/plugins/httprpc/action.php';
  get addTorrentUrl => url + '/php/addtorrent.php';
  get diskSpacePluginUrl => url + '/plugins/diskspace/action.php';

  String getBasicAuth() => 'Basic ' + base64Encode(utf8.encode('$_username:$_password'));

}