import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/logger.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:rutorrentflutter/services/functional_services/authentication_service.dart';
import 'package:rutorrentflutter/services/functional_services/disk_space_service.dart';

Logger log = getLogger("AuthenticationService");

///[Service] for communicating with the [RuTorrent] APIs
class ApiService {

  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  DiskSpaceService _diskSpaceService = locator<DiskSpaceService>();

  IOClient get ioClient {
    /// Url with some issue with their SSL certificates can be trusted explicitly with this
    bool trustSelfSigned = true;
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);

    IOClient _ioClient = new IOClient(httpClient);
    return _ioClient;
  }

  Account get account => _authenticationService.accounts.isEmpty
      ? _authenticationService.tempAccount
      : _authenticationService.accounts[0];

  get url => account.url;

  /// Plugins url
  get httpRpcPluginUrl => url + '/plugins/httprpc/action.php';

  get addTorrentPluginUrl => url + '/php/addtorrent.php';

  get diskSpacePluginUrl => url + '/plugins/diskspace/action.php';

  get rssPluginUrl => url + '/plugins/rss/action.php';

  get historyPluginUrl => url + '/plugins/history/action.php';

  get explorerPluginUrl => url + '/plugins/explorer/action.php';

  /// Authentication header
  Map<String, String> getAuthHeader() {
    return {
      'authorization': 'Basic ' +
          base64Encode(utf8.encode('${account.username}:${account.password}')),
    };
  }

  testConnectionAndLogin(Account account) async {
    Response response;
    var total;
    try {
      response = await ioClient.get(Uri.parse(diskSpacePluginUrl),
          headers: getAuthHeader());
      log.i("Test Connection Response : " + response.body);
      total = jsonDecode(response.body)['total'];
      Fluttertoast.showToast(msg: 'Connected');
    } catch (e) {
      Fluttertoast.showToast(msg: 'invalid');
    }
    if (response != null && total != null && response.statusCode != 200) {
      Fluttertoast.showToast(msg: 'Something\'s Wrong');
      return;
    }
    await _authenticationService.saveLogin(account);
  }

  updateDiskSpace() async {
    var diskSpaceResponse = await ioClient.get(Uri.parse(diskSpacePluginUrl),
        headers: getAuthHeader());
    var diskSpace = jsonDecode(diskSpaceResponse.body);
    _diskSpaceService.updateDiskSpace(diskSpace['total'], diskSpace['free']);
  }
}
