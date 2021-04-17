import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rutorrentflutter/models/disk_file.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/history_item.dart';
import 'package:rutorrentflutter/models/rss.dart';
import 'package:rutorrentflutter/models/rss_filter.dart';
import 'package:rutorrentflutter/models/torrent_file.dart';
import 'package:xml/xml.dart' as xml;

import '../models/torrent.dart';
import 'api_conf.dart';

class ApiRequests {
  /// This class will be responsible for making all API Calls to the ruTorrent server

  /// Checks Added and Finished Torrents asynchronously by fetching History of last ten seconds
  static Future<void> updateHistory(
      Api api, GeneralFeatures general, BuildContext context) async {
    var timestamp = ((CustomizableDateTime.current.millisecondsSinceEpoch -
                Duration(seconds: 10).inMilliseconds) ~/
            1000)
        .toString();
    var historyItems = <HistoryItem>[];
    var response = await api.ioClient.post(Uri.parse(api.historyPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'cmd': 'get',
          'mark': timestamp,
        });

    var items = jsonDecode(response.body)['items'] as List;
    for (var item in items) {
      var historyItem = HistoryItem(
          item['name'].toString(),
          item['action'] as int,
          item['action_time'] as int,
          item['size'] as int,
          item['hash'].toString());
      historyItems.add(historyItem);
    }
    general.updateHistoryItems(historyItems, context);
  }

  /// Checks disk space asynchronously for low disk space alert
  static Future<void> updateDiskSpace(
      Api api, GeneralFeatures general, BuildContext context) async {
    var diskSpaceResponse = await api.ioClient
        .get(Uri.parse(api.diskSpacePluginUrl), headers: api.getAuthHeader());
    var diskSpace = jsonDecode(diskSpaceResponse.body) as Map<String, dynamic>;
    general.updateDiskSpace(
        diskSpace['total'] as int, diskSpace['free'] as int, context);
  }

  static void updatePlugins(
      Api api, GeneralFeatures general, BuildContext context) {
    /// Updating DiskSpace
    updateDiskSpace(api, general, context);

    /// Updating History
    updateHistory(api, general, context);
  }

  /// Parses json data into list of torrents
  static List<Torrent> parseTorrentsData(
      String responseBody, GeneralFeatures general, Api api) {
    // takes response and parse and return the torrents data
    var torrentsList = <Torrent>[];
    // A list of active torrents is required for changing the connection state from waiting to active
    var activeTorrents = <Torrent>[];
    var labels = <String>[];
    var torrentsPath = jsonDecode(responseBody)['t'] is List
        ? <String, dynamic>{}
        : jsonDecode(responseBody)['t'] as Map<String, dynamic>;
    for (var hashKey in torrentsPath.keys) {
      var torrentObject = torrentsPath[hashKey] as List;
      var torrent = Torrent(hashKey); // new torrent created
      torrent.name = torrentObject[4].toString();
      torrent.size = int.parse(torrentObject[5].toString());
      torrent.savePath = torrentObject[25].toString();
      torrent.label = torrentObject[14].toString().replaceAll('%20', ' ');
      torrent.completedChunks = int.parse(torrentObject[6].toString());
      torrent.totalChunks = int.parse(torrentObject[7].toString());
      torrent.sizeOfChunk = int.parse(torrentObject[13].toString());
      torrent.torrentAdded = int.parse(torrentObject[21].toString());
      torrent.torrentCreated = int.parse(torrentObject[26].toString());
      torrent.seedsActual = int.parse(torrentObject[18].toString());
      torrent.peersActual = int.parse(torrentObject[15].toString());
      torrent.ulSpeed = int.parse(torrentObject[11].toString());
      torrent.dlSpeed = int.parse(torrentObject[12].toString());
      torrent.isOpen = int.parse(torrentObject[0].toString());
      torrent.getState = int.parse(torrentObject[3].toString());
      torrent.msg = torrentObject[29].toString();
      torrent.downloadedData = int.parse(torrentObject[8].toString());
      torrent.uploadedData = int.parse(torrentObject[9].toString());
      torrent.ratio = int.parse(torrentObject[10].toString());

      torrent.api = api;
      torrent.eta = torrent.getEta;
      torrent.percentageDownload = torrent.getPercentageDownload;
      torrent.status = torrent.getTorrentStatus;
      torrentsList.add(torrent);

      if (torrent.status == Status.downloading &&
          torrent.percentageDownload < 100) activeTorrents.add(torrent);
      if (!labels.contains(torrent.label) && torrent.label != '') {
        labels.add(torrent.label);
      }
    }
    general.setActiveDownloads(activeTorrents);
    general.setListOfLabels(labels);
    return torrentsList;
  }

  /// Gets list of torrents for all saved accounts [Apis]
  static Stream<List<Torrent>> getAllAccountsTorrentList(
      List<Api> apis, GeneralFeatures general) async* {
    while (true) {
      var allTorrentList = <Torrent>[];
      try {
        for (var api in apis) {
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

  static Future<void> startTorrent(Api api, String hashValue) async {
    await api.ioClient.post(Uri.parse(api.httpRpcPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'mode': 'start',
          'hash': hashValue,
        });
  }

  static Future<void> pauseTorrent(Api api, String hashValue) async {
    await api.ioClient.post(Uri.parse(api.httpRpcPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'mode': 'pause',
          'hash': hashValue,
        });
  }

  static Future<void> stopTorrent(Api api, String hashValue) async {
    await api.ioClient.post(Uri.parse(api.httpRpcPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'mode': 'stop',
          'hash': hashValue,
        });
  }

  static Future<void> removeTorrent(Api api, String hashValue) async {
    var response = await api.ioClient.post(Uri.parse(api.httpRpcPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'mode': 'remove',
          'hash': hashValue,
        });

    if (response.statusCode == 200) {
      await Fluttertoast.showToast(msg: 'Removed Torrent Successfully');
    }
  }

  static Future<void> removeTorrentWithData(Api api, String hashValue) async {
    var client = api.ioClient;
    var request = http.Request(
      'POST',
      Uri.parse(api.httpRpcPluginUrl),
    );
    request.headers.addAll(api.getAuthHeader());
    var xml =
        '<?xml version=\"1.0\" encoding=\"UTF-8\"?><methodCall><methodName>system.multicall</methodName><params><param><value><array><data><value><struct><member><name>methodName</name><value><string>d.custom5.set</string></value></member><member><name>params</name><value><array><data><value><string>${hashValue.toString()}</string></value><value><string>1</string></value></data></array></value></member></struct></value><value><struct><member><name>methodName</name><value><string>d.delete_tied</string></value></member><member><name>params</name><value><array><data><value><string>${hashValue.toString()}</string></value></data></array></value></member></struct></value><value><struct><member><name>methodName</name><value><string>d.erase</string></value></member><member><name>params</name><value><array><data><value><string>${hashValue.toString()}</string></value></data></array></value></member></struct></value></data></array></value></param></params></methodCall>';
    request.body = xml;
    var streamedResponse = await client.send(request);

    if (streamedResponse.statusCode == 200) {
      await Fluttertoast.showToast(
          msg: 'Removed Torrent and Deleted Data Successfully');
    }

    var responseBody =
        await streamedResponse.stream.transform(utf8.decoder).join();
    print(responseBody);
    client.close();
  }

  static Future<void> toggleTorrentStatus(
      Api api, String hashValue, int isOpen, int getState) async {
    const statusMap = <Status, String>{
      Status.downloading: 'start',
      Status.paused: 'pause',
      Status.stopped: 'stop',
    };

    var toggleStatus = isOpen == 0
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

  static Future<void> addTorrent(Api api, String url) async {
    await Fluttertoast.showToast(msg: 'Adding torrent');
    await api.ioClient.post(Uri.parse(api.addTorrentPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'url': url,
        });
  }

  static Future<void> addTorrentFile(Api api, String torrentPath) async {
    await Fluttertoast.showToast(msg: 'Adding torrent');
    var request =
        http.MultipartRequest('POST', Uri.parse(api.addTorrentPluginUrl));
    // request.fields['label'] = "hell";

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
    var trackersList = <String>[];

    var trKResponse = await api.ioClient.post(Uri.parse(api.httpRpcPluginUrl),
        headers: api.getAuthHeader(), body: {'mode': 'trk', 'hash': hashValue});

    var trackers = jsonDecode(trKResponse.body) as List;
    for (var tracker in trackers) {
      trackersList.add(tracker[0].toString());
    }
    return trackersList;
  }

  /// Gets list of files for a particular torrent
  static Future<List<TorrentFile>> getFiles(Api api, String hashValue) async {
    var filesList = <TorrentFile>[];

    var flsResponse = await api.ioClient.post(Uri.parse(api.httpRpcPluginUrl),
        headers: api.getAuthHeader(), body: {'mode': 'fls', 'hash': hashValue});

    var files = jsonDecode(flsResponse.body) as List;
    for (var file in files) {
      var torrentFile = TorrentFile(file[0] as String, file[1] as String,
          file[2] as String, file[3] as String);
      filesList.add(torrentFile);
    }
    return filesList;
  }

  /// Gets list of saved RSS Feeds
  static Future<List<RSSLabel>> loadRSS(Api api) async {
    var rssLabels = <RSSLabel>[];
    var rssResponse = await api.ioClient
        .post(Uri.parse(api.rssPluginUrl), headers: api.getAuthHeader());

    var feeds = jsonDecode(rssResponse.body)['list'] as List<dynamic>;
    for (var label in feeds) {
      var rssLabel =
          RSSLabel(label['hash'].toString(), label['label'].toString());
      for (var item in label['items']) {
        var rssItem = RSSItem(item['title'].toString(), item['time'] as int,
            item['href'].toString());
        rssLabel.items.add(rssItem);
      }
      rssLabels.add(rssLabel);
    }
    return rssLabels;
  }

  /// Removes RSS Feed
  static Future<void> removeRSS(Api api, String hashValue) async {
    await api.ioClient
        .post(Uri.parse(api.rssPluginUrl), headers: api.getAuthHeader(), body: {
      'mode': 'remove',
      'rss': hashValue,
    });
  }

  /// Adds new RSS Feed
  static Future<void> addRSS(Api api, String rssUrl) async {
    await Fluttertoast.showToast(msg: 'Adding RSS');
    await api.ioClient
        .post(Uri.parse(api.rssPluginUrl), headers: api.getAuthHeader(), body: {
      'mode': 'add',
      'url': rssUrl,
    });
  }

  /// Gets details of available torrent in RSS Feed
  static Future<bool> getRSSDetails(
      Api api, RSSItem rssItem, String labelHash) async {
    var dataAvailable = true;
    try {
      var response = await api.ioClient.post(Uri.parse(api.rssPluginUrl),
          headers: api.getAuthHeader(),
          body: {
            'mode': 'getdesc',
            'href': rssItem.url,
            'rss': labelHash,
          });
      var xmlResponse = xml.XmlDocument.parse(response.body);

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
    var rssFilters = <RSSFilter>[];
    var response = await api.ioClient
        .post(Uri.parse(api.rssPluginUrl), headers: api.getAuthHeader(), body: {
      'mode': 'getfilters',
    });

    var filters = jsonDecode(response.body) as List<dynamic>;
    for (var filter in filters) {
      var rssFilter = RSSFilter(
        filter['name'].toString(),
        filter['enabled'] as int,
        filter['pattern'].toString(),
        filter['label'].toString(),
        filter['exclude'].toString(),
        filter['dir'].toString(),
      );
      rssFilters.add(rssFilter);
    }
    return rssFilters;
  }

  /// Gets History of last [lastHours] hours
  static Future<List<HistoryItem>> getHistory(Api api, {int lastHours}) async {
    var timestamp = '0';
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

    var items = jsonDecode(response.body)['items'] as List;

    var historyItems = <HistoryItem>[];
    for (var item in items) {
      var historyItem = HistoryItem(
          item['name'].toString(),
          item['action'] as int,
          item['action_time'] as int,
          item['size'] as int,
          item['hash'].toString());
      historyItems.add(historyItem);
    }
    return historyItems;
  }

  /// Gets Disk Files
  static Future<List<DiskFile>> getDiskFiles(Api api, String path) async {
    try {
      var response = await api.ioClient.post(Uri.parse(api.explorerPluginUrl),
          headers: api.getAuthHeader(),
          body: {
            'cmd': 'get',
            'src': path,
          });

      var files = jsonDecode(response.body)['files'] as List<Map>;

      var diskFiles = <DiskFile>[];

      for (var file in files) {
        var diskFile = DiskFile();

        diskFile.isDirectory = file['is_dir'] as bool;
        diskFile.name = file['data']['name'].toString();
        diskFiles.add(diskFile);
      }

      return diskFiles;
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<void> setTorrentLabel(Api api, String hashValue,
      {String label}) async {
    try {
      await api.ioClient.post(Uri.parse(api.httpRpcPluginUrl),
          headers: api.getAuthHeader(),
          body: {
            'mode': 'setlabel',
            'hash': hashValue,
            'v': label.replaceAll(' ', '%20')
          });
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future<void> removeTorrentLabel(Api api, String hashValue) async {
    try {
      await api.ioClient.post(Uri.parse(api.httpRpcPluginUrl),
          headers: api.getAuthHeader(),
          body: {'mode': 'setlabel', 'hash': hashValue, 'v': ''});
    } on Exception catch (e) {
      print(e.toString() + 'errrrr');
    }
  }

  static Future<void> removeHistoryItem(Api api, String hashValue) async {
    await Fluttertoast.showToast(msg: 'Removing Torrent from History');
    try {
      await api.ioClient.post(Uri.parse(api.historyPluginUrl),
          headers: api.getAuthHeader(),
          body: {
            'cmd': 'delete',
            'mode': 'hstdelete',
            'hash': hashValue,
          });
    } on Exception catch (e) {
      print('err: ${e.toString()}');
    }
  }
}
