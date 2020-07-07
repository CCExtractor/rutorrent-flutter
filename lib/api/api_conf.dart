import 'dart:convert';

import 'dart:io';

import 'package:http/io_client.dart';

class Api {
  IOClient _ioClient;

  Api() {
    // url with some issue with their SSL certificates can be trusted explicitly with this
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);
    _ioClient = new IOClient(httpClient);
  }

  get ioClient => _ioClient;

  String _url;
  String _username;
  String _password;

  setUrl(String url) => _url = url;
  setPassword(String password) => _password = password;
  setUsername(String username) => _username = username;

  get url => _url;
  get username => _username;
  get password => _password;

  get httprpcPluginUrl => url + '/plugins/httprpc/action.php';
  get addTorrentUrl => url + '/php/addtorrent.php';
  get diskSpacePluginUrl => url + '/plugins/diskspace/action.php';

  Map<String, String> getAuthHeader() => {
        'authorization':
            'Basic ' + base64Encode(utf8.encode('$_username:$_password'))
      };
}
