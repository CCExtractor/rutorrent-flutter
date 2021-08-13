import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:rutorrentflutter/models/disk_file.dart';
import 'package:rutorrentflutter/models/history_item.dart';
import 'package:rutorrentflutter/models/rss.dart';
import 'package:rutorrentflutter/models/rss_filter.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:rutorrentflutter/models/torrent_file.dart';
import 'package:rutorrentflutter/services/functional_services/authentication_service.dart';
import 'package:rutorrentflutter/services/functional_services/disk_space_service.dart';
import 'package:rutorrentflutter/services/api/i_api_service.dart';
import 'package:rutorrentflutter/services/services_info.dart';
import 'package:rutorrentflutter/services/state_services/disk_file_service.dart';
import 'package:rutorrentflutter/services/state_services/history_service.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';
import 'package:xml/xml.dart';

Logger log = getLogger("ApiService");

///[Service] for communicating with the [RuTorrent] APIs
class ProdApiService implements IApiService {
  AuthenticationService? _authenticationService =
      locator<AuthenticationService>();
  DiskSpaceService? _diskSpaceService = locator<DiskSpaceService>();
  TorrentService? _torrentService = locator<TorrentService>();
  HistoryService? _historyService = locator<HistoryService>();
  DiskFileService _diskFileService = locator<DiskFileService>();

  IOClient get ioClient {
    /// Url with some issue with their SSL certificates can be trusted explicitly with this
    bool trustSelfSigned = true;
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);

    IOClient _ioClient = new IOClient(httpClient);
    return _ioClient;
  }

  Account? get account => _authenticationService!.accounts.value.isEmpty
      ? _authenticationService!.tempAccount
      : _authenticationService!.accounts.value[0];

  get accounts => _authenticationService?.accounts;

  get url => account!.url;

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
          base64Encode(
              utf8.encode('${account!.username}:${account!.password}')),
    };
  }

  Future<bool> testConnectionAndLogin(Account? account) async {
    log.v("Testing connection with server");
    Response? response;
    var total;
    try {
      response = await ioClient.get(Uri.parse(diskSpacePluginUrl),
          headers: getAuthHeader());
      log.i("Test Connection Response : " + response.body);
      total = jsonDecode(response.body)['total'];
    } catch (e) {
      Fluttertoast.showToast(msg: 'Username or Password incorrect');
      return false;
    }
    if (total != null && response.statusCode != 200) {
      Fluttertoast.showToast(msg: 'Something\'s Wrong');
      return false;
    }
    
    Fluttertoast.showToast(msg: 'Connected');
    await _authenticationService!.saveLogin(account);
    return true;
  }

  Future<void> updateDiskSpace() async {
    log.v("updating disk space");
    var diskSpaceResponse = await ioClient.get(Uri.parse(diskSpacePluginUrl),
        headers: getAuthHeader());
    var diskSpace = jsonDecode(diskSpaceResponse.body);
    _diskSpaceService!.updateDiskSpace(diskSpace['total'], diskSpace['free']);
  }

  /// Gets list of torrents for all saved accounts [Apis]
  Stream<List<Torrent>> getAllAccountsTorrentList() async* {
    log.v("Fetching torrent lists from all accounts\n [Will be run every other second]");
    List<Account?>? accounts = _authenticationService!.accounts.value;
    while (true) {
    List<Torrent> allTorrentList = [];
    try {
      for (Account? account in accounts) {
        try {
          var response = await ioClient.post(Uri.parse(httpRpcPluginUrl),
              headers: getAuthHeader(),
              body: {
                'mode': 'list',
              });
          allTorrentList.addAll(_parseTorrentData(response.body, account)!);
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
  Stream<List<Torrent?>?> getTorrentList() async* {
    log.v("Fetching torrent lists from all accounts\n [Will be run every other second]");
    while (true) {
    try {
      var response = await ioClient
          .post(Uri.parse(httpRpcPluginUrl), headers: getAuthHeader(), body: {
        'mode': 'list',
      });

      yield _parseTorrentData(response.body, account)!;
    } catch (e) {
      print('Exception caught in getTorrentList Api Request ' + e.toString());
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

  startTorrent(String? hashValue) async {
    log.v("Starting Torrent");
    await ioClient
        .post(Uri.parse(httpRpcPluginUrl), headers: getAuthHeader(), body: {
      'mode': 'start',
      'hash': hashValue,
    });
  }

  pauseTorrent(String? hashValue) async {
    log.v("Pausing Torrent");
    await ioClient
        .post(Uri.parse(httpRpcPluginUrl), headers: getAuthHeader(), body: {
      'mode': 'pause',
      'hash': hashValue,
    });
  }

  stopTorrent(String hashValue) async {
    log.v("Stop Torrent");
    await ioClient
        .post(Uri.parse(httpRpcPluginUrl), headers: getAuthHeader(), body: {
      'mode': 'stop',
      'hash': hashValue,
    });
  }

  removeTorrent(String hashValue) async {
    log.v("Remove Torrent");
    var response = await ioClient
        .post(Uri.parse(httpRpcPluginUrl), headers: getAuthHeader(), body: {
      'mode': 'remove',
      'hash': hashValue,
    });

    if (response.statusCode == 200)
      Fluttertoast.showToast(msg: 'Removed Torrent Successfully');
  }

  removeTorrentWithData(String hashValue) async {
    log.v("removing torrent");
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

  addTorrent(String url) async {
    Fluttertoast.showToast(msg: 'Adding torrent');
    await ioClient
        .post(Uri.parse(addTorrentPluginUrl), headers: getAuthHeader(), body: {
      'url': url,
    });
  }

  addTorrentFile(String torrentPath) async {
    Fluttertoast.showToast(msg: 'Adding torrent');
    var request = MultipartRequest('POST', Uri.parse(addTorrentPluginUrl));
    // request.fields['label'] = "hell";

    request.files
        .add(await MultipartFile.fromPath('torrent_file', torrentPath));
    try {
      var response = await request.send();

      print(response.headers);
    } catch (e) {
      print(e.toString());
    }
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

    await ioClient
        .post(Uri.parse(httpRpcPluginUrl), headers: getAuthHeader(), body: {
      'mode': statusMap[toggleStatus],
      'hash': torrent.hash,
    });
    log.v("Toggling torrent status to " + statusMap[toggleStatus].toString());
  }

  /// Gets History of last [lastHours] hours
  Future<List<HistoryItem>> getHistory({int? lastHours}) async {
    log.v(
        "Fetching history items from server for ${lastHours ?? 'infinite'} hours ago");
    String timestamp = '0';
    if (lastHours != null) {
      timestamp = ((DateTime.now().millisecondsSinceEpoch -
                  Duration(hours: lastHours).inMilliseconds) ~/
              1000)
          .toString();
    }

    var response = await ioClient
        .post(Uri.parse(historyPluginUrl), headers: getAuthHeader(), body: {
      'cmd': 'get',
      'mark': timestamp,
    });

    var items = jsonDecode(response.body)['items'];

    List<HistoryItem> historyItems = [];
    for (var item in items) {
      HistoryItem historyItem = HistoryItem(item['name'], item['action'],
          item['action_time'], item['size'], item['hash']);
      historyItems.add(historyItem);
    }
    _historyService?.setTorrentHistoryList(historyItems);
    return historyItems;
  }

  removeHistoryItem(String hashValue) async {
    log.v("Removing history item from server");
    Fluttertoast.showToast(msg: 'Removing Torrent from History');
    try {
      await ioClient
          .post(Uri.parse(historyPluginUrl), headers: getAuthHeader(), body: {
        'cmd': 'delete',
        'mode': 'hstdelete',
        'hash': hashValue,
      });
    } on Exception catch (e) {
      print('err: ${e.toString()}');
    }
  }

  updateHistory() async {
    log.v("Updating history items from server");
    String timestamp = ((CustomizableDateTime.current.millisecondsSinceEpoch -
                Duration(seconds: 10).inMilliseconds) ~/
            1000)
        .toString();
    List<HistoryItem> historyItems = [];
    var response = await ioClient
        .post(Uri.parse(historyPluginUrl), headers: getAuthHeader(), body: {
      'cmd': 'get',
      'mark': timestamp,
    });

    var items = jsonDecode(response.body)['items'];
    for (var item in items) {
      HistoryItem historyItem = HistoryItem(item['name'], item['action'],
          item['action_time'], item['size'], item['hash']);
      historyItems.add(historyItem);
    }
    _historyService?.setTorrentHistoryList(historyItems);
    _historyService?.notify();
  }

  setTorrentLabel({required String hashValue, required String label}) async {
    log.v(
        "Setting torrent label with $label for torrent with hashValue $hashValue");
    try {
      await ioClient.post(Uri.parse(httpRpcPluginUrl),
          headers: getAuthHeader(),
          body: {
            'mode': 'setlabel',
            'hash': hashValue,
            'v': label.replaceAll(" ", "%20")
          });
    } on Exception catch (e) {
      print(e);
    }
  }

  removeTorrentLabel({required String hashValue}) async {
    log.v("Remove torrent label for torrent with hashValue $hashValue");
    try {
      await ioClient.post(Uri.parse(httpRpcPluginUrl),
          headers: getAuthHeader(),
          body: {'mode': 'setlabel', 'hash': hashValue, 'v': ''});
    } on Exception catch (e) {
      print(e.toString() + "error");
    }
  }

  Future<bool> changePassword(int index, String newPassword) async {
    log.v("Changing password");
    Account account = accounts[index];
    var response;
    int total = -100;
    try {
      response = await ioClient.get(Uri.parse(diskSpacePluginUrl), headers: {
        'authorization': 'Basic ' +
            base64Encode(utf8.encode('${account.username}:$newPassword')),
      });
      total = jsonDecode(response.body)['total'];
    } catch (e) {
      Fluttertoast.showToast(msg: 'Invalid Password');
    }

    if (response != null && total > -100 && response.statusCode == 200) {
      return true;
    }

    return false;
  }

  /// Gets Disk Files
  Future<List<DiskFile>> getDiskFiles(String path) async {
    log.v("Fetching Disk Files");
    try {
      var response = await ioClient
          .post(Uri.parse(explorerPluginUrl), headers: getAuthHeader(), body: {
        'cmd': 'get',
        'src': path,
      });

      var files = jsonDecode(response.body)['files'];

      List<DiskFile> diskFiles = [];

      for (var file in files) {
        DiskFile diskFile = DiskFile();

        diskFile.isDirectory = file['is_dir'];
        diskFile.name = file['data']['name'];
        diskFiles.add(diskFile);
      }

      _diskFileService.setDiskFileList(diskFiles);
      return diskFiles;
    } on Exception catch (e) {
      print(e.toString());
      return [];
    }
  }

  /// Gets list of files for a particular torrent
  Future<List<TorrentFile>> getFiles(String hashValue) async {
    log.v("Fetching filles for torrent with hash $hashValue");
    List<TorrentFile> filesList = [];

    var flsResponse = await ioClient.post(Uri.parse(httpRpcPluginUrl),
        headers: getAuthHeader(), body: {'mode': 'fls', 'hash': hashValue});

    var files = jsonDecode(flsResponse.body);
    for (var file in files) {
      TorrentFile torrentFile = TorrentFile(file[0], file[1], file[2], file[3]);
      filesList.add(torrentFile);
    }
    return filesList;
  }

  /// Gets list of trackers for a particular torrent
  Future<List<String>> getTrackers(String hashValue) async {
    log.v("Fetching trackers for torrent with hash $hashValue");
    List<String> trackersList = [];

    var trKResponse = await ioClient.post(Uri.parse(httpRpcPluginUrl),
        headers: getAuthHeader(), body: {'mode': 'trk', 'hash': hashValue});

    var trackers = jsonDecode(trKResponse.body);
    for (var tracker in trackers) {
      trackersList.add(tracker[0]);
    }
    return trackersList;
  }

  /*      RSS Functions      */

  /// Gets list of saved RSS Feeds
  Future<List<RSSLabel>> loadRSS() async {
    log.v("Loading RSS");
    List<RSSLabel> rssLabels = [];
    var rssResponse =
        await ioClient.post(Uri.parse(rssPluginUrl), headers: getAuthHeader());

    var feeds = jsonDecode(rssResponse.body)['list'];
    for (var label in feeds) {
      RSSLabel rssLabel = RSSLabel(label['hash'], label['label']);
      for (var item in label['items']) {
        RSSItem rssItem = RSSItem(item['title'], item['time'], item['href']);
        rssLabel.items.add(rssItem);
      }
      rssLabels.add(rssLabel);
    }
    return rssLabels;
  }

  /// Removes RSS Feed
  removeRSS(String hashValue) async {
    log.v("Removing RSS");
    await ioClient
        .post(Uri.parse(rssPluginUrl), headers: getAuthHeader(), body: {
      'mode': 'remove',
      'rss': hashValue,
    });
  }

  /// Adds new RSS Feed
  addRSS(String rssUrl) async {
    log.v("Adding RSS");
    Fluttertoast.showToast(msg: 'Adding RSS');
    await ioClient
        .post(Uri.parse(rssPluginUrl), headers: getAuthHeader(), body: {
      'mode': 'add',
      'url': rssUrl,
    });
  }

  /// Gets details of available torrent in RSS Feed
  Future<bool> getRSSDetails(RSSItem rssItem, String labelHash) async {
    log.v("Fetching RSS Details");
    bool dataAvailable = true;
    try {
      var response = await ioClient
          .post(Uri.parse(rssPluginUrl), headers: getAuthHeader(), body: {
        'mode': 'getdesc',
        'href': rssItem.url,
        'rss': labelHash,
      });
      var xmlResponse = XmlDocument.parse(response.body);

      var data =
          xmlResponse.lastChild?.text; // extracting value stored in data tag
      var list = data?.split('<br />');
      var secondList = list?[0].split('\"');

      rssItem.imageUrl = secondList?[3];
      rssItem.name = secondList?[5];

      rssItem.rating = list?[1];
      rssItem.genre = list?[2];
      rssItem.size = list?[3];
      rssItem.runtime = list?[4];
      rssItem.description = list?[6];
    } catch (e) {
      log.e("Error " + e.toString());
      dataAvailable = false;
      print(e);
    }
    return dataAvailable;
  }

  /// Gets details of RSS Filters
  Future<List<RSSFilter>> getRSSFilters() async {
    log.v("Fetching RSS Filters");
    List<RSSFilter> rssFilters = [];
    var response = await ioClient
        .post(Uri.parse(rssPluginUrl), headers: getAuthHeader(), body: {
      'mode': 'getfilters',
    });

    var filters = jsonDecode(response.body);
    for (var filter in filters) {
      RSSFilter rssFilter = RSSFilter(
        filter['name'],
        filter['enabled'],
        filter['pattern'],
        filter['label'],
        filter['exclude'],
        filter['dir'],
      );
      rssFilters.add(rssFilter);
    }
    return rssFilters;
  }

  List<Torrent>? _parseTorrentData(String responseBody, Account? currAccount) {
    // log.v("List of Torrents being parsed");
    // takes response and parse and return the torrents data
    List<Torrent> torrentsList = [];
    // A list of active torrents is required for changing the connection state from waiting to active
    List<Torrent> activeTorrents = [];
    List<String> labels = [];
    var torrentsPath = jsonDecode(responseBody)['t'];

    if (torrentsPath.length == 0) {
      log.i("No torrent to parse");
      return [];
    }

    for (var hashKey in torrentsPath.keys) {
      var torrentObject = torrentsPath[hashKey];
      Torrent torrent = Torrent.fromObject(
          account: currAccount, hashKey: hashKey, torrentObject: torrentObject);

      bool downloading = torrent.status == Status.downloading;
      bool loading = torrent.percentageDownload < 100;

      if (downloading && loading) {
        activeTorrents.add(torrent);
      }

      if (!labels.contains(torrent.label) && torrent.label != "") {
        labels.add(torrent.label!);
      }
      torrentsList.add(torrent);
    }
    _torrentService!.setActiveDownloads(activeTorrents);
    _torrentService!.setTorrentList(torrentsList);
    _torrentService!.setListOfLabels(labels);
    return torrentsList;
  }
}
