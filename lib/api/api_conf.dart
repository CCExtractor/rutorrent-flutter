import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';

/// This class deals with storing API endpoints (and credentials) of deployed ruTorrent server

class Api {
  get ioClient {
    /// Url with some issue with their SSL certificates can be trusted explicitly with this
    bool trustSelfSigned = true;
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);

    IOClient _ioClient = new IOClient(httpClient);
    return _ioClient;
  }

  String _url;
  String _username;
  String _password;

  setUrl(String url) => _url = url;
  setPassword(String password) => _password = password;
  setUsername(String username) => _username = username;

  get url => _url;
  get username => _username;
  get password => _password;

  /// Plugins url
  get httpRpcPluginUrl => url + '/plugins/httprpc/action.php';

  get addTorrentPluginUrl => url + '/php/addtorrent.php';

  get diskSpacePluginUrl => url + '/plugins/diskspace/action.php';

  get rssPluginUrl => url + '/plugins/rss/action.php';

  get historyPluginUrl => url + '/plugins/history/action.php';

  get explorerPluginUrl => url + '/plugins/explorer/action.php';

  /// Authentication header
  Map<String, String> getAuthHeader() => {
        'authorization':
            'Basic ' + base64Encode(utf8.encode('$_username:$_password')),
      };
}
