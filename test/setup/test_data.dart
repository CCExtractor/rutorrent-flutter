import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/history_item.dart';

/// This class contains the test data used in tests to remove non-deterministic behaviour
class TestData {
  static const url = "localhost:8080";

  static const httpRpcPluginJSONResponse = '{"t": []}';

  static const updateHistoryJSONReponse =
      '{"items":[{"action":3,"name":"Test Torrent","size":276445467,"downloaded":0,"uploaded":0,"ratio":0,"creation":1490916601,"added":1617006438,"finished":0,"tracker":"udp:\/\/tracker.leechers-paradise.org:6969","label":"","action_time":1617006494,"hash":"965a1ccb9c297983eeb4e6e1f7a6f693"}],"mode":false}';

  static const updateDiskSpaceJSONResponse = '{"total": 5000, "free": 3000}';

  static List<HistoryItem> historyItems = [
    HistoryItem("Test Torrent", 3, 1617006494, 276445467,
        "965a1ccb9c297983eeb4e6e1f7a6f693"),
  ];

  static const httpRpcPluginUrl = url + '/plugins/httprpc/action.php';

  static const addTorrentPluginUrl = url + '/php/addtorrent.php';

  static const diskSpacePluginUrl = url + '/plugins/diskspace/action.php';

  static const rssPluginUrl = url + '/plugins/rss/action.php';

  static const historyPluginUrl = url + '/plugins/history/action.php';

  static const explorerPluginUrl = url + '/plugins/explorer/action.php';

  static String getConstantTimeStamp() {
    return ((CustomizableDateTime.current.millisecondsSinceEpoch -
                Duration(seconds: 10).inMilliseconds) ~/
            1000)
        .toString();
  }
}
