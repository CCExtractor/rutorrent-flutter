// ignore_for_file: type=lint
import 'package:flutter/foundation.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:rutorrentflutter/models/history_item.dart';
import 'package:rutorrentflutter/models/rss_filter.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:rutorrentflutter/services/services_info.dart';

/// This class contains the test data used in tests to remove non-deterministic behaviour
class TestData {
  static const url = "http://localhost:8080";
  static const String hash = "EB25F7EC8FDE4DA888C197DB0975FFF549C9D7FB";

  static ValueNotifier<List<Account>> accounts = ValueNotifier([
    Account(username: "test", password: "test", url: "http://localhost:8080")
  ]);

  static get authHeader => {
        "authorization": "Basic dGVzdDp0ZXN0",
        "origin": "http://localhost:8080"
      };

  static List<HistoryItem> historyItems = [
    HistoryItem("Test Torrent", 3, 1617006494, 276445467,
        "965a1ccb9c297983eeb4e6e1f7a6f693"),
  ];

  static Torrent get torrent => Torrent("dddd");
  static RSSFilter get rssFilter => RSSFilter("", 0, "", "", "", "");

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

  //API Call Mock Data

  ///GET Calls

  //> Update History || getAllAccountsHistory || getHistory
  static const updateHistoryJSONReponse =
      '{"items":[{"action":3,"name":"Test Torrent","size":276445467,"downloaded":0,"uploaded":0,"ratio":0,"creation":1490916601,"added":1617006438,"finished":0,"tracker":"udp:\/\/tracker.leechers-paradise.org:6969","label":"","action_time":1617006494,"hash":"965a1ccb9c297983eeb4e6e1f7a6f693"}],"mode":false}';

  //> updateDiskSpace
  static const updateDiskSpaceResponse =
      '{"total":456328667136,"free":456309145600}';

  ///POST Calls

  //> getAllAccountsTorrentList || getTorrentList
  static const getAllAccountsTorrentListBody = {'mode': 'list'};
  static const getAllAccountsTorrentListResponse =
      '{"t":{"EB25F7EC8FDE4DA888C197DB0975FFF549C9D7FB":["1","0","1","1","Circus_Capers_PSP.MP4","79529790","0","304","0","0","0","0","0","262144","","0","0","0","0","79529790","2","1657548808","0","0","304","\/downloads\/Circus_Capers_PSP.MP4","1138563506","2","1","","","456309145600","0","0","","","","","0#0#","2#0#","","rat_7","","1657467587"]},"cid":2490211954}';

  //> getDiskFiles || getAllAccountsDiskFiles
  static const getDiskFilesBody = {'cmd': 'get', 'src': "/"};
  static const getDiskFilesResponse =
      '{"time":1657467450,"path":"\/","files":[{"is_dir":true,"link":"deluge_completed","icon":"Icon_Dir","data":{"name":"deluge_completed","size":null,"time":1655769307,"comment":""}},{"is_dir":true,"link":"deluge_watchdir","icon":"Icon_Dir","data":{"name":"deluge_watchdir","size":null,"time":1655769307,"comment":""}},{"is_dir":true,"link":"dropbox","icon":"Icon_Dir","data":{"name":"dropbox","size":null,"time":1655769413,"comment":""}},{"is_dir":true,"link":"mnt","icon":"Icon_Dir","data":{"name":"mnt","size":null,"time":1655769777,"comment":""}},{"is_dir":true,"link":"newsgroups","icon":"Icon_Dir","data":{"name":"newsgroups","size":null,"time":1655768763,"comment":""}},{"is_dir":true,"link":"watchdir_rtorrent","icon":"Icon_Dir","data":{"name":"watchdir_rtorrent","size":null,"time":1655769304,"comment":""}},{"is_dir":false,"link":null,"icon":"Icon_vsample","data":{"name":"Circus_Capers_PSP.MP4","size":0,"time":1657467450,"comment":""},"ext":["convert","mediainfo","ffmpeg","vcs","vsample"]}]}';

  //> getFiles
  static const getFilesBody = {
    'mode': 'fls',
    'hash': "EB25F7EC8FDE4DA888C197DB0975FFF549C9D7FB"
  };
  static const getFilesResponse = [
    ["Circus_Capers_PSP.MP4", "0", "304", "79529790", "1", "0", "0"]
  ];

  //> getTrackers
  static const getTrackersBody = {
    'mode': 'trk',
    'hash': "EB25F7EC8FDE4DA888C197DB0975FFF549C9D7FB"
  };
  static const getTrackersResponse = [
    [
      "http:\/\/files.publicdomaintorrents.com\/bt\/announce.php",
      "1",
      "1",
      "0",
      "0",
      "2",
      "12",
      "1800",
      "1657467617"
    ],
    ["dht:\/\/", "3", "1", "1", "0", "0", "0", "1200", "0"]
  ];

  //> loadRSS || loadAllAccountsRSS
  static const loadRSSResponse = {
    "errors": [],
    "list": [
      {
        "label": "YTS RSS",
        "auto": 0,
        "enabled": 1,
        "hash": "ea2836f2bb5ba172da8b91bad88589cc",
        "url": "https:\/\/www.yts.mx\/rss\/",
        "items": [
          {
            "time": 1627546376,
            "title": "Anything for Jackson (2020) [BluRay] [720p] [YTS.MX]",
            "href":
                "https:\/\/yts.mx\/torrent\/download\/29EF75BF0C529DE5775619722BFF88709F1D9DFC",
            "guid": "https:\/\/yts.mx\/movies\/anything-for-jackson-2020#720p",
            "errcount": 0,
            "hash": ""
          },
          {
            "time": 1627549835,
            "title": "Anything for Jackson (2020) [BluRay] [1080p] [YTS.MX]",
            "href":
                "https:\/\/yts.mx\/torrent\/download\/BA5AA606C0508AA851855457C1648C4B28A89994",
            "guid": "https:\/\/yts.mx\/movies\/anything-for-jackson-2020#1080p",
            "errcount": 0,
            "hash": ""
          },
          {
            "time": 1627545874,
            "title": "Resort to Love (2021) [WEBRip] [720p] [YTS.MX]",
            "href":
                "https:\/\/yts.mx\/torrent\/download\/AE0B15B4BA7E8C094C3DC652C000CC65CB4D7E26",
            "guid": "https:\/\/yts.mx\/movies\/resort-to-love-2021#720p",
            "errcount": 0,
            "hash": ""
          },
          {
            "time": 1627549507,
            "title": "Resort to Love (2021) [WEBRip] [1080p] [YTS.MX]",
            "href":
                "https:\/\/yts.mx\/torrent\/download\/3D24BAC44C228B6C690F933145C2405FA7A07FB1",
            "guid": "https:\/\/yts.mx\/movies\/resort-to-love-2021#1080p",
            "errcount": 0,
            "hash": ""
          },
        ],
      },
    ],
    "groups": []
  };

  //> getRSSFilters || getAllAccountsRSSFilters
  static const getRSSFiltersBody = {'mode': 'getfilters'};
  static const getRSSFiltersResponse = [
    {
      "name": "CheckAgain",
      "enabled": 1,
      "pattern": "\/Blue Strait*\/",
      "label": "",
      "exclude": "",
      "throttle": "",
      "ratio": "",
      "hash": "",
      "start": 1,
      "add_path": 1,
      "chktitle": 1,
      "chkdesc": 0,
      "chklink": 0,
      "no": 2,
      "interval": -1,
      "dir": ""
    },
    {
      "name": "FilterTitle",
      "enabled": 0,
      "pattern": "FilterNameInRegex",
      "label": "LabelName",
      "exclude": "ExcludeThis",
      "throttle": "thr_0",
      "ratio": "rat_0",
      "hash": "",
      "start": 1,
      "add_path": 1,
      "chktitle": 1,
      "chkdesc": 0,
      "chklink": 0,
      "no": 3,
      "interval": 12,
      "dir": "\/torrents\/ritik\/"
    },
    {
      "name": "FirstTest",
      "enabled": 1,
      "pattern": "\/Ghosts of War*\/",
      "label": "",
      "exclude": "",
      "throttle": "",
      "ratio": "",
      "hash": "",
      "start": 1,
      "add_path": 1,
      "chktitle": 1,
      "chkdesc": 0,
      "chklink": 0,
      "no": 1,
      "interval": -1,
      "dir": ""
    }
  ];
}
