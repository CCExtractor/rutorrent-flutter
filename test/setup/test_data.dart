import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/history_item.dart';
import 'package:rutorrentflutter/models/rss.dart';
import 'package:rutorrentflutter/models/rss_filter.dart';
import 'package:rutorrentflutter/models/torrent.dart';

/// This class contains the test data used in tests to remove non-deterministic behaviour
class TestData {
  static const url = "localhost:8080";

  static const httpRpcPluginJSONResponse =
      '{"t":{"DD8255ECDC7CA55FB0BBF81323D87062DB1F6D1C":["1","0","1","1","Torrent Name","276445467","0","1055","0","0","0","0","0","262144","","0","0","0","0","276445467","2","1617814006","0","0","1055","\/downloads\/Torrent Name","1490916601","6","0","","VRS24mrkerWebTorrent%20%3Chttps%3A%2F%245Fwebtorrent.io%3E","0","0","1"]},"cid":1038957762}';

  static const updateDiskSpaceJSONResponse = '{"total": 5000, "free": 3000}';

  static const explorerPluginJSONResponse =
      '{"files":[{"is_dir":true,"data":{"name":"Disk File Name"}}]}';

  static const rssPluginXMLResponse =
      '<?xml version="1.0" encoding="UTF-8"?><data><![CDATA[New episode: 60 Minutes S53E28 WEB h264 BAE]]></data>';

  static const updateHistoryJSONReponse =
      '{"items":[{"action":3,"name":"Test Torrent","size":276445467,"downloaded":0,"uploaded":0,"ratio":0,"creation":1490916601,"added":1617006438,"finished":0,"tracker":"udp:\/\/tracker.leechers-paradise.org:6969","label":"","action_time":1617006494,"hash":"965a1ccb9c297983eeb4e6e1f7a6f693"}],"mode":false}';

  static List<HistoryItem> historyItems = [
    HistoryItem("Test Torrent", 3, 1617006494, 276445467,
        "965a1ccb9c297983eeb4e6e1f7a6f693"),
  ];

  static Torrent torrent = Torrent("DD8255ECDC7CA55FB0BBF81323D87062DB1F6D1C");

  static RSSItem rssItem = RSSItem("RSS_TITLE", 1234567890, "testURL");

  static RSSFilter rssFilter = RSSFilter(name: "TestName");

  static const httpRpcPluginUrl = url + '/plugins/httprpc/action.php';

  static const addTorrentPluginUrl = url + '/php/addtorrent.php';

  static const diskSpacePluginUrl = url + '/plugins/diskspace/action.php';

  static const rssPluginUrl = url + '/plugins/rss/action.php';

  static const historyPluginUrl = url + '/plugins/history/action.php';

  static const explorerPluginUrl = url + '/plugins/explorer/action.php';

  static const String path = "Test/Path";

  static String getUpdateHistoryConstantTimeStamp() {
    return ((CustomizableDateTime.current.millisecondsSinceEpoch -
                Duration(seconds: 10).inMilliseconds) ~/
            1000)
        .toString();
  }

  static String getGetHistoryConstantTimeStamp() {
    return ((CustomizableDateTime.current.millisecondsSinceEpoch -
                Duration(hours: 3).inMilliseconds) ~/
            1000)
        .toString();
  }
}
