import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rutorrentflutter/models/history_item.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/rss.dart';
import 'package:rutorrentflutter/models/rss_filter.dart';
import 'package:rutorrentflutter/models/torrent_file.dart';
import 'api_conf.dart';
import '../models/torrent.dart';
import 'package:xml/xml.dart' as xml;

class ApiRequests {
  /// This class will be responsible for making all API Calls to the ruTorrent server

  static updateHistory(Api api, GeneralFeatures general) async {
    String timestamp = ((DateTime.now().millisecondsSinceEpoch -
                Duration(minutes: 1).inMilliseconds) ~/
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
      HistoryItem historyItem =
          HistoryItem(item['name'], item['action'], item['action_time']);
      historyItems.add(historyItem);
    }
    general.updateHistoryItems(historyItems);
  }

  static updateDiskSpace(Api api, GeneralFeatures general) async {
    var diskSpaceResponse = await api.ioClient
        .get(Uri.parse(api.diskSpacePluginUrl), headers: api.getAuthHeader());
    var diskSpace = jsonDecode(diskSpaceResponse.body);
    general.updateDiskSpace(diskSpace['total'], diskSpace['free']);
  }

  static updatePlugins(Api api, GeneralFeatures general) {
    /// Updating DiskSpace
    updateDiskSpace(api, general);

    /// Updating History
    updateHistory(api, general);
  }

  static List<Torrent> parseTorrentsData(
      String responseBody, GeneralFeatures general,Api api) {
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

  static Stream<List<Torrent>> getAllAccountsTorrentList(
      List<Api> apis, GeneralFeatures general) async* {
    while (true) {
      try {
        List<Torrent> allTorrentList = [];
        for (Api api in apis) {
          var response = await api.ioClient.post(
              Uri.parse(api.httprpcPluginUrl),
              headers: api.getAuthHeader(),
              body: {
                'mode': 'list',
              });
          allTorrentList.addAll(parseTorrentsData(response.body, general,api));
        }
        yield allTorrentList;
      } catch (e) {
        print(e);
        yield null;
      }
      await Future.delayed(Duration(seconds: 1), () {});
    }
  }

  static Stream<List<Torrent>> getTorrentList(
      Api api, GeneralFeatures general) async* {
    while (true) {
      try {
        var response = await api.ioClient.post(Uri.parse(api.httprpcPluginUrl),
            headers: api.getAuthHeader(),
            body: {
              'mode': 'list',
            });

        yield parseTorrentsData(response.body, general,api);
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
    await api.ioClient.post(Uri.parse(api.httprpcPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'mode': 'start',
          'hash': hashValue,
        });
  }

  static pauseTorrent(Api api, String hashValue) async {
    await api.ioClient.post(Uri.parse(api.httprpcPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'mode': 'pause',
          'hash': hashValue,
        });
  }

  static stopTorrent(Api api, String hashValue) async {
    await api.ioClient.post(Uri.parse(api.httprpcPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'mode': 'stop',
          'hash': hashValue,
        });
  }

  static removeTorrent(Api api, String hashValue) async {
    await api.ioClient.post(Uri.parse(api.httprpcPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'mode': 'remove',
          'hash': hashValue,
        });
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
        : getState == 0 ? (Status.downloading) : Status.paused;

    await api.ioClient.post(Uri.parse(api.httprpcPluginUrl),
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

  static Future<List<String>> getTrackers(Api api, String hashValue) async {
    List<String> trackersList = [];

    var trKResponse = await api.ioClient.post(Uri.parse(api.httprpcPluginUrl),
        headers: api.getAuthHeader(), body: {'mode': 'trk', 'hash': hashValue});

    var trackers = jsonDecode(trKResponse.body);
    for (var tracker in trackers) {
      trackersList.add(tracker[0]);
    }
    return trackersList;
  }

  static Future<List<TorrentFile>> getFiles(Api api, String hashValue) async {
    List<TorrentFile> filesList = [];

    var flsResponse = await api.ioClient.post(Uri.parse(api.httprpcPluginUrl),
        headers: api.getAuthHeader(), body: {'mode': 'fls', 'hash': hashValue});

    var files = jsonDecode(flsResponse.body);
    for (var file in files) {
      TorrentFile torrentFile = TorrentFile(file[0], file[1], file[2], file[3]);
      filesList.add(torrentFile);
    }
    return filesList;
  }

  static Stream<Torrent> updateSheetData(Api api, Torrent torrent) async* {
    try {
      while (true) {
        var response = await api.ioClient.post(Uri.parse(api.httprpcPluginUrl),
            headers: api.getAuthHeader(),
            body: {
              'mode': 'list',
            });

        var torrentObject = jsonDecode(response.body)['t'][torrent.hash];
        Torrent updatedTorrent = torrent;
        // updating the values which possibly change over time
        updatedTorrent.completedChunks = int.parse(torrentObject[6]);
        updatedTorrent.totalChunks = int.parse(torrentObject[7]);
        updatedTorrent.sizeOfChunk = int.parse(torrentObject[13]);
        updatedTorrent.seedsActual = int.parse(torrentObject[18]);
        updatedTorrent.peersActual = int.parse(torrentObject[15]);
        updatedTorrent.ulSpeed = int.parse(torrentObject[11]);
        updatedTorrent.dlSpeed = int.parse(torrentObject[12]);
        updatedTorrent.isOpen = int.parse(torrentObject[0]);
        updatedTorrent.getState = int.parse(torrentObject[3]);
        updatedTorrent.msg = torrentObject[29];
        updatedTorrent.downloadedData = int.parse(torrentObject[8]);
        updatedTorrent.uploadedData = int.parse(torrentObject[9]);
        updatedTorrent.ratio = int.parse(torrentObject[10]);

        updatedTorrent.eta = updatedTorrent.getEta;
        updatedTorrent.percentageDownload =
            updatedTorrent.getPercentageDownload;
        updatedTorrent.status = updatedTorrent.getTorrentStatus;

        yield updatedTorrent;

        await Future.delayed(Duration(seconds: 1), () {});
      }
    } catch (e) {
      print('Exception Caught in Torrent Details ' + e.toString());
      /* Exception may arise when you are constantly updating the torrent details and
      that torrent task might have been removed either from
      web interface or through any other device.*/
    }
  }

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

  static removeRSS(Api api, String hashValue) async {
    await api.ioClient
        .post(Uri.parse(api.rssPluginUrl), headers: api.getAuthHeader(), body: {
      'mode': 'remove',
      'rss': hashValue,
    });
  }

  static addRSS(Api api, String rssUrl) async {
    Fluttertoast.showToast(msg: 'Adding RSS');
    await api.ioClient
        .post(Uri.parse(api.rssPluginUrl), headers: api.getAuthHeader(), body: {
      'mode': 'add',
      'url': rssUrl,
    });
  }

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

  static Future<List<HistoryItem>> getHistory(Api api) async {
    String timestamp = ((DateTime.now().millisecondsSinceEpoch -
                Duration(hours: 24).inMilliseconds) ~/
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
      HistoryItem historyItem =
          HistoryItem(item['name'], item['action'], item['action_time']);
      historyItems.add(historyItem);
    }
    return historyItems;
  }
}
