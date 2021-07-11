import 'package:http/io_client.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:rutorrentflutter/models/disk_file.dart';
import 'package:rutorrentflutter/models/history_item.dart';
import 'package:rutorrentflutter/models/rss.dart';
import 'package:rutorrentflutter/models/rss_filter.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:rutorrentflutter/models/torrent_file.dart';

abstract class IApiService {
  IOClient get ioClient;
  Account? get account;
  get accounts;
  get url;

  /// Plugin urls
  get httpRpcPluginUrl;
  get addTorrentPluginUrl;
  get diskSpacePluginUrl;
  get rssPluginUrl;
  get historyPluginUrl;
  get explorerPluginUrl;

  Map<String, String> getAuthHeader();

  testConnectionAndLogin(Account? account);

  Future<void> updateDiskSpace();

  Stream<List<Torrent>> getAllAccountsTorrentList();

  Stream<List<Torrent?>?> getTorrentList();

  startTorrent(String? hashValue);

  pauseTorrent(String? hashValue);

  stopTorrent(String hashValue);

  removeTorrent(String hashValue);

  removeTorrentWithData(String hashValue);

  addTorrent(String url);

  addTorrentFile(String torrentPath);

  toggleTorrentStatus(Torrent torrent);

  Future<List<HistoryItem>> getHistory({int? lastHours});

  removeHistoryItem(String hashValue);

  updateHistory();

  setTorrentLabel({required String hashValue, required String label});

  removeTorrentLabel({required String hashValue});

  Future<bool> changePassword(int index, String newPassword);

  /// Gets Disk Files
  Future<List<DiskFile>> getDiskFiles(String path);

  /// Gets list of files for a particular torrent
  Future<List<TorrentFile>> getFiles(String hashValue);

  /// Gets list of trackers for a particular torrent
  Future<List<String>> getTrackers(String hashValue);

  /*      RSS Functions      */

  /// Gets list of saved RSS Feeds
  Future<List<RSSLabel>> loadRSS();

  /// Removes RSS Feed
  removeRSS(String hashValue);

  /// Adds new RSS Feed
  addRSS(String rssUrl);

  /// Gets details of available torrent in RSS Feed
  Future<bool> getRSSDetails(RSSItem rssItem, String labelHash);

  /// Gets details of RSS Filters
  Future<List<RSSFilter>> getRSSFilters();

  // ignore: unused_element
  List<Torrent>? _parseTorrentData(String responseBody, Account? currAccount);
}
