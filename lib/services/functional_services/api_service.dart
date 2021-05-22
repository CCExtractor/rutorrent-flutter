import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:rutorrentflutter/services/functional_services/authentication_service.dart';
import 'package:rutorrentflutter/services/functional_services/disk_space_service.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';

Logger log = getLogger("ApiService");

///[Service] for communicating with the [RuTorrent] APIs
class ApiService {

  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  DiskSpaceService _diskSpaceService = locator<DiskSpaceService>();
  TorrentService _torrentService = locator<TorrentService>();

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

  /// Plugin urls
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

  /// Gets list of torrents for all saved accounts [Apis]
  Stream<List<Torrent>> getAllAccountsTorrentList() async* {
    log.v("Fetching torrent lists from all accounts");
    List<Account> accounts = _authenticationService.accounts;
    while (true) {
      List<Torrent> allTorrentList = [];
      try {
        for (Account account in accounts) {
          try {
            var response = await ioClient.post(
                Uri.parse(httpRpcPluginUrl),
                headers: getAuthHeader(),
                body: {
                  'mode': 'list',
                });
            allTorrentList
                .addAll(_parseTorrentData(response.body,account));
          } catch (e) {
            print(e);
          }
        }
      } catch (e) {
        print('Account Changes');
      }
      yield allTorrentList;
      await Future.delayed(Duration(seconds: 1), () {});
    }
  }

  /// Gets list of torrents for a particular account
  Stream<List<Torrent>> getTorrentList() async* {
    log.v("Fetching torrent lists from all accounts");
    while (true) {
      try {
        var response = await ioClient.post(Uri.parse(httpRpcPluginUrl),
            headers: getAuthHeader(),
            body: {
              'mode': 'list',
            });

        yield _parseTorrentData(response.body, account);
      } catch (e) {
        print('Exception caught in Api Request ' + e.toString());
        /*returning null since the stream has to be active all the times to return something
          this usually occurs when there is no torrent task available or when the connect
          to rTorrent is not established
        */
        yield null;
      }
      // Producing artificial delay of one second
      await Future.delayed(Duration(seconds: 1), () {});
    }
  }

  startTorrent(String hashValue) async {
    log.v("Starting Torrent");
    await ioClient.post(Uri.parse(httpRpcPluginUrl),
        headers: getAuthHeader(),
        body: {
          'mode': 'start',
          'hash': hashValue,
        });
  }

  pauseTorrent(String hashValue) async {
    log.v("Pausing Torrent");
    await ioClient.post(Uri.parse(httpRpcPluginUrl),
        headers: getAuthHeader(),
        body: {
          'mode': 'pause',
          'hash': hashValue,
        });
  }

  stopTorrent(String hashValue) async {
    log.v("Stop Torrent");
    await ioClient.post(Uri.parse(httpRpcPluginUrl),
        headers: getAuthHeader(),
        body: {
          'mode': 'stop',
          'hash': hashValue,
        });
  }

  removeTorrent(String hashValue) async {
    log.v("Remove Torrent");
    var response = await ioClient.post(Uri.parse(httpRpcPluginUrl),
        headers: getAuthHeader(),
        body: {
          'mode': 'remove',
          'hash': hashValue,
        });

    if (response.statusCode == 200)
      Fluttertoast.showToast(msg: 'Removed Torrent Successfully');
  }

  removeTorrentWithData(String hashValue) async {
    var client = ioClient;
    var request = Request(
      'POST',
      Uri.parse(httpRpcPluginUrl),
    );
    request.headers.addAll(getAuthHeader());
    var xml =
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?><methodCall><methodName>system.multicall</methodName><params><param><value><array><data><value><struct><member><name>methodName</name><value><string>d.custom5.set</string></value></member><member><name>params</name><value><array><data><value><string>${hashValue.toString()}</string></value><value><string>1</string></value></data></array></value></member></struct></value><value><struct><member><name>methodName</name><value><string>d.delete_tied</string></value></member><member><name>params</name><value><array><data><value><string>${hashValue.toString()}</string></value></data></array></value></member></struct></value><value><struct><member><name>methodName</name><value><string>d.erase</string></value></member><member><name>params</name><value><array><data><value><string>${hashValue.toString()}</string></value></data></array></value></member></struct></value></data></array></value></param></params></methodCall>";
    request.body = xml;
    var streamedResponse = await client.send(request);

    if (streamedResponse.statusCode == 200)
      Fluttertoast.showToast(
          msg: 'Removed Torrent and Deleted Data Successfully');

    var responseBody =
        await streamedResponse.stream.transform(utf8.decoder).join();
    print(responseBody);
    client.close();
  }

  toggleTorrentStatus(Torrent torrent) async {
    const Map<Status, String> statusMap = {
      Status.downloading: 'start',
      Status.paused: 'pause',
      Status.stopped: 'stop',
    };

    Status toggleStatus = torrent.isOpen == 0
        ? Status.downloading
        : torrent.getState == 0
            ? (Status.downloading)
            : Status.paused;

    await ioClient.post(Uri.parse(httpRpcPluginUrl),
        headers: getAuthHeader(),
        body: {
          'mode': statusMap[toggleStatus],
          'hash': torrent.hash,
        });
  }

  List<Torrent> _parseTorrentData(String responseBody, Account currAccount) {
    log.v("List of Torrents being parsed");
    // takes response and parse and return the torrents data
    List<Torrent> torrentsList = [];
    // A list of active torrents is required for changing the connection state from waiting to active
    List<Torrent> activeTorrents = [];
    List<String> labels = [];
    var torrentsPath = jsonDecode(responseBody)['t'];

    if(torrentsPath.length == 0) return null;

    for (var hashKey in torrentsPath.keys) {
      var torrentObject = torrentsPath[hashKey];
      Torrent torrent = Torrent.fromObject(account: currAccount, hashKey: hashKey, torrentObject: torrentObject);

      bool downloading = torrent.status == Status.downloading;
      bool loading = torrent.percentageDownload < 100;

      if(downloading && loading){
        activeTorrents.add(torrent);
      }

      if (!labels.contains(torrent.label) && torrent.label != "") {
        labels.add(torrent.label);
      }

      torrentsList.add(torrent);
    }
    _torrentService.activeDownloads = activeTorrents;
    _torrentService.listOfLabels = labels;
    return torrentsList;
  }
}
