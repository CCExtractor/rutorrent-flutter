import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
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
import 'package:rutorrentflutter/services/mock_data/accounts.dart';
import 'package:rutorrentflutter/services/mock_data/disk_space.dart';
import 'package:rutorrentflutter/services/mock_data/history.dart';
import 'package:rutorrentflutter/services/mock_data/rss.dart';
import 'package:rutorrentflutter/services/mock_data/torrents.dart';
import 'package:rutorrentflutter/services/services_info.dart';
import 'package:rutorrentflutter/services/state_services/history_service.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';
import 'package:xml/xml.dart';

Logger log = getLogger("ApiService");

///[Service] for communicating with the [RuTorrent] APIs
class DevApiService implements IApiService {
  AuthenticationService? _authenticationService =
      locator<AuthenticationService>();
  DiskSpaceService? _diskSpaceService = locator<DiskSpaceService>();
  TorrentService? _torrentService = locator<TorrentService>();
  HistoryService? _historyService = locator<HistoryService>();

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
  get httpRpcPluginUrl => '';
  get addTorrentPluginUrl => '';
  get diskSpacePluginUrl => '';
  get rssPluginUrl => '';
  get historyPluginUrl => '';
  get explorerPluginUrl => '';

  /// Authentication header
  Map<String, String> getAuthHeader() {
    return {
      'authorization': 'Basic ' +
          base64Encode(
              utf8.encode('${account!.username}:${account!.password}')),
    };
  }

  Future<bool> testConnectionAndLogin(Account? account) async {
    log.v("Testing connection with mock server");
    for (int i = 0; i < devAccounts.length; i++) {
      if (devAccounts[i].url == account!.url &&
          devAccounts[i].username == account.username &&
          devAccounts[i].password == account.password) {
        Fluttertoast.showToast(msg: 'Connected');
        await _authenticationService!.saveLogin(account);
        return true;
      }
    }
    Fluttertoast.showToast(msg: 'invalid');
    return false;
  }

  Future<void> updateDiskSpace() async {
    log.v("updating disk space");
    var diskSpace = devDiskSpace;
    _diskSpaceService!.updateDiskSpace(diskSpace.total, diskSpace.free);
  }

  /// Gets list of torrents for all saved accounts [Apis]
  Stream<List<Torrent>> getAllAccountsTorrentList() async* {
    log.v("Fetching torrent lists from all accounts");
    List<Account?>? accounts = _authenticationService!.accounts.value;
    while (true) {
      List<Torrent> allTorrentList = [];
      for (Account? account in accounts) {
        var response = devTorrents;
        allTorrentList.addAll(_parseTorrentData(response, account)!);
      }
      yield allTorrentList;
      // Producing artificial delay of one second
      await Future.delayed(Duration(seconds: 1), () {});
    }
  }

  /// Gets list of torrents for a particular account
  Stream<List<Torrent?>?> getTorrentList() async* {
    log.v("Fetching torrent lists from one account");
    while (true) {
      var response = devTorrents;
      yield _parseTorrentData(response, account)!;
      // Producing artificial delay of one second
      await Future.delayed(Duration(seconds: 1), () {});
    }
  }

  startTorrent(String? hashValue) async {
    log.v("Starting Torrent");
    devTorrents[hashValue]![0] = "1";
    devTorrents[hashValue]![3] = "1";
  }

  pauseTorrent(String? hashValue) async {
    log.v("Pausing Torrent");
    devTorrents[hashValue]![3] = "0";
  }

  stopTorrent(String hashValue) async {
    log.v("Stop Torrent");
    devTorrents[hashValue]![0] = "0";
  }

  removeTorrent(String hashValue) async {
    log.v("Remove Torrent");
    if (devTorrents.containsKey(hashValue)) {
      devTorrents.remove(hashValue);
    }
    Fluttertoast.showToast(msg: 'Removed Torrent Successfully');
  }

  removeTorrentWithData(String hashValue) async {
    log.v("removing torrent");
    if (devTorrents.containsKey(hashValue)) {
      devTorrents.remove(hashValue);
    }
    Fluttertoast.showToast(msg: 'Removed Torrent Successfully');
  }

  addTorrent(String url) async {
    Fluttertoast.showToast(msg: 'Adding torrent');
    // todo
  }

  addTorrentFile(String torrentPath) async {
    Fluttertoast.showToast(msg: 'Adding torrent');
    // todo
  }

  toggleTorrentStatus(Torrent torrent) async {
    log.v("Toggling torrent status");
    Status toggleStatus = torrent.isOpen == 0
        ? Status.downloading
        : torrent.getState == 0
            ? (Status.downloading)
            : Status.paused;
    if (toggleStatus == Status.downloading) {
      devTorrents[torrent.hash]![0] = "1";
      devTorrents[torrent.hash]![3] = "1";
    } else if (toggleStatus == Status.paused) {
      devTorrents[torrent.hash]![3] = "0";
    } else {
      devTorrents[torrent.hash]![0] = "0";
    }
  }

  /// Gets History of last [lastHours] hours
  Future<List<HistoryItem>> getHistory({int? lastHours}) async {
    log.v(
        "Fetching history items from server for ${lastHours ?? 'infinite'} hours ago");
    // ignore: unused_local_variable
    String timestamp = '0';
    if (lastHours != null) {
      timestamp = ((DateTime.now().millisecondsSinceEpoch -
                  Duration(hours: lastHours).inMilliseconds) ~/
              1000)
          .toString();
    }
    // todo: implement search history with given timestamp
    var response = devHistory;
    var items = response['items'];

    List<HistoryItem> historyItems = [];
    for (var item in items!) {
      HistoryItem historyItem = HistoryItem(
        item['name'].toString(),
        int.parse(item['action'].toString()),
        int.parse(item['action_time'].toString()),
        int.parse(item['size'].toString()),
        item['hash'].toString(),
      );
      historyItems.add(historyItem);
    }
    _historyService?.setTorrentHistoryList(historyItems);
    return historyItems;
  }

  removeHistoryItem(String hashValue) async {
    log.v("Removing history item from server");
    Fluttertoast.showToast(msg: 'Removing Torrent from History');
    devHistory["items"]!.removeWhere((element) => element["hash"] == hashValue);
  }

  updateHistory() async {
    log.v("Updating history items from server");
    // ignore: unused_local_variable
    String timestamp = ((CustomizableDateTime.current.millisecondsSinceEpoch -
                Duration(seconds: 10).inMilliseconds) ~/
            1000)
        .toString();
    // todo: implement search history with given timestamp
    var response = devHistory;
    var items = response['items'];

    List<HistoryItem> historyItems = [];
    for (var item in items!) {
      HistoryItem historyItem = HistoryItem(
        item['name'].toString(),
        int.parse(item['action'].toString()),
        int.parse(item['action_time'].toString()),
        int.parse(item['size'].toString()),
        item['hash'].toString(),
      );
      historyItems.add(historyItem);
    }
    _historyService?.setTorrentHistoryList(historyItems);
    _historyService?.notify();
  }

  setTorrentLabel({required String hashValue, required String label}) async {
    log.v(
        "Setting torrent label with $label for torrent with hashValue $hashValue");
    devTorrents[hashValue]![14] = label;
  }

  removeTorrentLabel({required String hashValue}) async {
    log.v("Remove torrent label for torrent with hashValue $hashValue");
    devTorrents[hashValue]![14] = "";
  }

  Future<bool> changePassword(int index, String newPassword) async {
    log.v("Changing password");
    Account account = accounts.value[index];
    devPasswordChange(account.username, newPassword);
    return true;
  }

  /// Gets Disk Files
  Future<List<DiskFile>> getDiskFiles(String path) async {
    log.v("Fetching Disk Files");
    return [];
  }

  /// Gets list of files for a particular torrent
  Future<List<TorrentFile>> getFiles(String hashValue) async {
    log.v("Fetching files for torrent with hash $hashValue");
    List<TorrentFile> filesList = [];

    var files = devTorrentsData[hashValue];
    for (var file in files!) {
      TorrentFile torrentFile = TorrentFile(file[0], file[1], file[2], file[3]);
      filesList.add(torrentFile);
    }
    return filesList;
  }

  /// Gets list of trackers for a particular torrent
  Future<List<String>> getTrackers(String hashValue) async {
    log.v("Fetching trackers for torrent with hash $hashValue");
    List<String> trackersList = [];

    var trackers = devTorrentsTracker[hashValue];
    for (var tracker in trackers!) {
      trackersList.add(tracker[0]);
    }
    return trackersList;
  }

  /*      RSS Functions      */

  /// Gets list of saved RSS Feeds
  Future<List<RSSLabel>> loadRSS() async {
    log.v("Loading RSS");
    List<RSSLabel> rssLabels = [];
    var feeds = devRSS['list'];
    for (var label in feeds!) {
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
    Fluttertoast.showToast(msg: 'Removing RSS');
    devRSS['list']!.removeWhere((rss) => rss["hash"] == hashValue);
  }

  /// Adds new RSS Feed
  addRSS(String rssUrl) async {
    log.v("Adding RSS");
    Fluttertoast.showToast(msg: 'Adding RSS');
    // todo
  }

  /// Gets details of available torrent in RSS Feed
  Future<bool> getRSSDetails(RSSItem rssItem, String labelHash) async {
    log.v("Fetching RSS Details");
    bool dataAvailable = true;
    try {
      Map<String, dynamic> rss =
          devRSSItems.firstWhere((rss) => rss['hash'] == labelHash);
      var rssItems = [];
      rssItems.addAll(rss['items']);
      var item = rssItems.firstWhere((item) => item['href'] == rssItem.url);
      var xmlResponse = XmlDocument.parse(item['xml']);
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
    var filters = devRSSFilters;
    for (var filter in filters) {
      RSSFilter rssFilter = RSSFilter(
        filter['name'].toString(),
        int.parse(filter['enabled'].toString()),
        filter['pattern'].toString(),
        filter['label'].toString(),
        filter['exclude'].toString(),
        filter['dir'].toString(),
      );
      rssFilters.add(rssFilter);
    }
    return rssFilters;
  }

  List<Torrent>? _parseTorrentData(dynamic torrentsPath, Account? currAccount) {
    log.v("List of Torrents being parsed");
    // takes response and parse and return the torrents data
    List<Torrent> torrentsList = [];
    // A list of active torrents is required for changing the connection state from waiting to active
    List<Torrent> activeTorrents = [];
    List<String> labels = [];
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
      // log.e(torrent.account);
      torrentsList.add(torrent);
    }
    _torrentService!.setActiveDownloads(activeTorrents);
    _torrentService!.setListOfLabels(labels);
    _torrentService!.setTorrentList(torrentsList);
    return torrentsList;
  }
}
