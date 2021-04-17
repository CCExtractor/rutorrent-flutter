import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';

/// This class deals with storing API endpoints (and credentials) of deployed ruTorrent server

class Api {
  IOClient get ioClient {
    /// Url with some issue with their SSL certificates can be trusted explicitly with this
    var trustSelfSigned = true;
    var httpClient = HttpClient()
      ..badCertificateCallback = ((cert, host, port) => trustSelfSigned);

    var _ioClient = IOClient(httpClient);
    return _ioClient;
  }

  String _url;
  String _username;
  String _password;

  String setUrl(String url) => _url = url;
  String setPassword(String password) => _password = password;
  String setUsername(String username) => _username = username;

  String get url => _url;
  String get username => _username;
  String get password => _password;

  bool _isSeedboxAccount;

  bool get isSeedboxAccount {
    _isSeedboxAccount = _username.isNotEmpty && _password.isNotEmpty;
    return _isSeedboxAccount;
  }

  /// Plugins url
  String get httpRpcPluginUrl => url + '/plugins/httprpc/action.php';

  String get addTorrentPluginUrl => url + '/php/addtorrent.php';

  String get diskSpacePluginUrl => url + '/plugins/diskspace/action.php';

  String get rssPluginUrl => url + '/plugins/rss/action.php';

  String get historyPluginUrl => url + '/plugins/history/action.php';

  String get explorerPluginUrl => url + '/plugins/explorer/action.php';

  /// Authentication header
  Map<String, String> getAuthHeader() => {
        'authorization':
            'Basic ' + base64Encode(utf8.encode('$_username:$_password')),
      };
}
