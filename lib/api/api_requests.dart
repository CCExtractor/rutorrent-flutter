import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rutorrentflutter/models/disk_file.dart';
import 'package:rutorrentflutter/models/history_item.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/rss.dart';
import 'package:rutorrentflutter/models/rss_filter.dart';
import 'package:rutorrentflutter/models/torrent_file.dart';
import 'api_conf.dart';
import 'package:http/http.dart' as http;
import '../models/torrent.dart';
import 'package:xml/xml.dart' as xml;

class ApiRequests {
  /// This class will be responsible for making all API Calls to the ruTorrent server

  /// Checks Added and Finished Torrents asynchronously by fetching History of last ten seconds
  static updateHistory(
      Api api, GeneralFeatures general, BuildContext context) async {
    String timestamp = ((DateTime.now().millisecondsSinceEpoch -
                Duration(seconds: 10).inMilliseconds) ~/
            1000)
        .toString();
    List<HistoryItem> historyItems = [];
    var response = await api.ioClient.post(Uri.parse(api.historyPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'cmd': 'get',
          'mark': timestamp,
        });

    var items = jsonDecode(response.body)['items'];
    for (var item in items) {
      HistoryItem historyItem = HistoryItem(
          item['name'], item['action'], item['action_time'], item['size']);
      historyItems.add(historyItem);
    }
    general.updateHistoryItems(historyItems, context);
  }

  /// Checks disk space asynchronously for low disk space alert
  static updateDiskSpace(
      Api api, GeneralFeatures general, BuildContext context) async {
    var diskSpaceResponse = await api.ioClient
        .get(Uri.parse(api.diskSpacePluginUrl), headers: api.getAuthHeader());
    var diskSpace = jsonDecode(diskSpaceResponse.body);
    general.updateDiskSpace(diskSpace['total'], diskSpace['free'], context);
  }

  static updatePlugins(Api api, GeneralFeatures general, BuildContext context) {
    /// Updating DiskSpace
    updateDiskSpace(api, general, context);

    /// Updating History
    updateHistory(api, general, context);
  }

  /// Parses json data into list of torrents
  static List<Torrent> parseTorrentsData(
      String responseBody, GeneralFeatures general, Api api) {
    // takes response and parse and return the torrents data
    List<Torrent> torrentsList = [];
    // A list of active torrents is required for changing the connection state from waiting to active
    List<Torrent> activeTorrents = [];
    var torrentsPath = jsonDecode(responseBody)['t'];
    for (var hashKey in torrentsPath.keys) {
      var torrentObject = torrentsPath[hashKey];
      Torrent torrent = Torrent(hashKey); // new torrent created
      torrent.name = torrentObject[4];
      torrent.size = int.parse(torrentObject[5]);
      torrent.savePath = torrentObject[25];
      torrent.completedChunks = int.parse(torrentObject[6]);
      torrent.totalChunks = int.parse(torrentObject[7]);
      torrent.sizeOfChunk = int.parse(torrentObject[13]);
      torrent.torrentAdded = int.parse(torrentObject[21]);
      torrent.torrentCreated = int.parse(torrentObject[26]);
      torrent.seedsActual = int.parse(torrentObject[18]);
      torrent.peersActual = int.parse(torrentObject[15]);
      torrent.ulSpeed = int.parse(torrentObject[11]);
      torrent.dlSpeed = int.parse(torrentObject[12]);
      torrent.isOpen = int.parse(torrentObject[0]);
      torrent.getState = int.parse(torrentObject[3]);
      torrent.msg = torrentObject[29];
      torrent.downloadedData = int.parse(torrentObject[8]);
      torrent.uploadedData = int.parse(torrentObject[9]);
      torrent.ratio = int.parse(torrentObject[10]);

      torrent.api = api;
      torrent.eta = torrent.getEta;
      torrent.percentageDownload = torrent.getPercentageDownload;
      torrent.status = torrent.getTorrentStatus;
      torrentsList.add(torrent);

      if (torrent.status == Status.downloading &&
          torrent.percentageDownload < 100) activeTorrents.add(torrent);
    }
    general.setActiveDownloads(activeTorrents);
    return torrentsList;
  }

  /// Gets list of torrents for all saved accounts [Apis]
  static Stream<List<Torrent>> getAllAccountsTorrentList(
      List<Api> apis, GeneralFeatures general) async* {
    while (true) {
      List<Torrent> allTorrentList = [];
      try {
        for (Api api in apis) {
          try {
            var response = await api.ioClient.post(
                Uri.parse(api.httpRpcPluginUrl),
                headers: api.getAuthHeader(),
                body: {
                  'mode': 'list',
                });
            allTorrentList
                .addAll(parseTorrentsData(response.body, general, api));
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
  static Stream<List<Torrent>> getTorrentList(
      Api api, GeneralFeatures general) async* {
    while (true) {
      try {
        var response = await api.ioClient.post(Uri.parse(api.httpRpcPluginUrl),
            headers: api.getAuthHeader(),
            body: {
              'mode': 'list',
            });

        yield parseTorrentsData(response.body, general, api);
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

  static startTorrent(Api api, String hashValue) async {
    await api.ioClient.post(Uri.parse(api.httpRpcPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'mode': 'start',
          'hash': hashValue,
        });
  }

  static pauseTorrent(Api api, String hashValue) async {
    await api.ioClient.post(Uri.parse(api.httpRpcPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'mode': 'pause',
          'hash': hashValue,
        });
  }

  static stopTorrent(Api api, String hashValue) async {
    await api.ioClient.post(Uri.parse(api.httpRpcPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'mode': 'stop',
          'hash': hashValue,
        });
  }

  static removeTorrent(Api api, String hashValue) async {
    var response = await api.ioClient.post(Uri.parse(api.httpRpcPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'mode': 'remove',
          'hash': hashValue,
        });

    if(response.statusCode==200)
      Fluttertoast.showToast(msg: 'Removed Torrent Successfully');
  }

  static removeTorrentWithData(Api api, String hashValue) async {
    var client = api.ioClient;
    var request = http.Request(
      'POST',
      Uri.parse(api.httpRpcPluginUrl),
    );
    request.headers.addAll(api.getAuthHeader());
    var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><methodCall><methodName>system.multicall</methodName><params><param><value><array><data><value><struct><member><name>methodName</name><value><string>d.custom5.set</string></value></member><member><name>params</name><value><array><data><value><string>${hashValue.toString()}</string></value><value><string>1</string></value></data></array></value></member></struct></value><value><struct><member><name>methodName</name><value><string>d.delete_tied</string></value></member><member><name>params</name><value><array><data><value><string>${hashValue.toString()}</string></value></data></array></value></member></struct></value><value><struct><member><name>methodName</name><value><string>d.erase</string></value></member><member><name>params</name><value><array><data><value><string>${hashValue.toString()}</string></value></data></array></value></member></struct></value></data></array></value></param></params></methodCall>";
    request.body = xml;
    var streamedResponse = await client.send(request);

    if(streamedResponse.statusCode==200)
      Fluttertoast.showToast(msg: 'Removed Torrent and Deleted Data Successfully');

    var responseBody = await streamedResponse.stream.transform(utf8.decoder).join();
    print(responseBody);
    client.close();
  }

  static toggleTorrentStatus(
      Api api, String hashValue, int isOpen, int getState) async {
    const Map<Status, String> statusMap = {
      Status.downloading: 'start',
      Status.paused: 'pause',
      Status.stopped: 'stop',
    };

    Status toggleStatus = isOpen == 0
        ? Status.downloading
        : getState == 0
            ? (Status.downloading)
            : Status.paused;

    await api.ioClient.post(Uri.parse(api.httpRpcPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'mode': statusMap[toggleStatus],
          'hash': hashValue,
        });
  }

  static addTorrent(Api api, String url) async {
    Fluttertoast.showToast(msg: 'Adding torrent');
    await api.ioClient.post(Uri.parse(api.addTorrentPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'url': url,
        });
  }

  static addTorrentFile(Api api, String torrentPath) async {
    Fluttertoast.showToast(msg: 'Adding torrent');
    var request =
        http.MultipartRequest('POST', Uri.parse(api.addTorrentPluginUrl));
    request.files
        .add(await http.MultipartFile.fromPath('torrent_file', torrentPath));
    try {
      var response = await request.send();
      print(response.headers);
    } catch (e) {
      print(e.toString());
    }
  }

  /// Gets list of trackers for a particular torrent
  static Future<List<String>> getTrackers(Api api, String hashValue) async {
    List<String> trackersList = [];

    var trKResponse = await api.ioClient.post(Uri.parse(api.httpRpcPluginUrl),
        headers: api.getAuthHeader(), body: {'mode': 'trk', 'hash': hashValue});

    var trackers = jsonDecode(trKResponse.body);
    for (var tracker in trackers) {
      trackersList.add(tracker[0]);
    }
    return trackersList;
  }

  /// Gets list of files for a particular torrent
  static Future<List<TorrentFile>> getFiles(Api api, String hashValue) async {
    List<TorrentFile> filesList = [];

    var flsResponse = await api.ioClient.post(Uri.parse(api.httpRpcPluginUrl),
        headers: api.getAuthHeader(), body: {'mode': 'fls', 'hash': hashValue});

    var files = jsonDecode(flsResponse.body);
    for (var file in files) {
      TorrentFile torrentFile = TorrentFile(file[0], file[1], file[2], file[3]);
      filesList.add(torrentFile);
    }
    return filesList;
  }

  /// Gets list of saved RSS Feeds
  static Future<List<RSSLabel>> loadRSS(Api api) async {
    List<RSSLabel> rssLabels = [];
    var rssResponse = await api.ioClient
        .post(Uri.parse(api.rssPluginUrl), headers: api.getAuthHeader());

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
  static removeRSS(Api api, String hashValue) async {
    await api.ioClient
        .post(Uri.parse(api.rssPluginUrl), headers: api.getAuthHeader(), body: {
      'mode': 'remove',
      'rss': hashValue,
    });
  }

  /// Adds new RSS Feed
  static addRSS(Api api, String rssUrl) async {
    Fluttertoast.showToast(msg: 'Adding RSS');
    await api.ioClient
        .post(Uri.parse(api.rssPluginUrl), headers: api.getAuthHeader(), body: {
      'mode': 'add',
      'url': rssUrl,
    });
  }

  /// Gets details of available torrent in RSS Feed
  static Future<bool> getRSSDetails(
      Api api, RSSItem rssItem, String labelHash) async {
    bool dataAvailable = true;
    try {
      var response = await api.ioClient.post(Uri.parse(api.rssPluginUrl),
          headers: api.getAuthHeader(),
          body: {
            'mode': 'getdesc',
            'href': rssItem.url,
            'rss': labelHash,
          });
      var xmlResponse = xml.parse(response.body);

      var data =
          xmlResponse.lastChild.text; // extracting value stored in data tag
      var list = data.split('<br />');
      var secondList = list[0].split('\"');

      rssItem.imageUrl = secondList[3];
      rssItem.name = secondList[5];

      rssItem.rating = list[1];
      rssItem.genre = list[2];
      rssItem.size = list[3];
      rssItem.runtime = list[4];
      rssItem.description = list[6];
    } catch (e) {
      dataAvailable = false;
      print(e);
    }
    return dataAvailable;
  }

  /// Gets details of RSS Filters
  static Future<List<RSSFilter>> getRSSFilters(Api api) async {
    List<RSSFilter> rssFilters = [];
    var response = await api.ioClient
        .post(Uri.parse(api.rssPluginUrl), headers: api.getAuthHeader(), body: {
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

  /// Gets History of last [lastHours] hours
  static Future<List<HistoryItem>> getHistory(Api api, {int lastHours}) async {
    String timestamp = '0';
    if (lastHours != null) {
      timestamp = ((DateTime.now().millisecondsSinceEpoch -
                  Duration(hours: lastHours).inMilliseconds) ~/
              1000)
          .toString();
    }

    var response = await api.ioClient.post(Uri.parse(api.historyPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'cmd': 'get',
          'mark': timestamp,
        });

    var items = jsonDecode(response.body)['items'];

    List<HistoryItem> historyItems = [];
    for (var item in items) {
      HistoryItem historyItem = HistoryItem(
          item['name'], item['action'], item['action_time'], item['size']);
      historyItems.add(historyItem);
    }
    return historyItems;
  }

  /// Gets Disk Files
  static Future<List<DiskFile>> getDiskFiles(Api api, String path) async {
    var response = await api.ioClient.post(Uri.parse(api.explorerPluginUrl),
        headers: api.getAuthHeader(),
        body: {
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

    return diskFiles;
  }
}
