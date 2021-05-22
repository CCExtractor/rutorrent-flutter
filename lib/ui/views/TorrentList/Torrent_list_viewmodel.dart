import 'package:flutter/foundation.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:rutorrentflutter/services/functional_services/api_service.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';
import 'package:stacked/stacked.dart';

class TorrentListViewModel extends BaseViewModel {
  UserPreferencesService _userPreferencesService = locator<UserPreferencesService>();
  ApiService _apiService = locator<ApiService>();
  TorrentService _torrentService = locator<TorrentService>();

  bool get showAllAccounts => _userPreferencesService.showAllAccounts;
  ValueNotifier<List<Torrent>> get torrentList => _torrentService.torrentsList;

  getAllAccountsTorrentList() => _apiService.getAllAccountsTorrentList();
  getTorrentList() => _apiService.getTorrentList();

  checkForActiveDownloads() async {
    /* this method is responsible for changing the connection state from waiting to active by
    temporary pausing the active downloads and then resuming them again
     */
    List<Torrent> tempPausedDownloads = [];
    for (Torrent torrent in _torrentService.activeDownloads) {
      await _apiService.pauseTorrent(torrent.hash);
      tempPausedDownloads.add(torrent);
    }

    // Resuming the temporary paused active downloads
    for (Torrent torrent in tempPausedDownloads) {
      await _apiService.startTorrent(torrent.hash);
    }
  }

  updateTorrentsList() => _torrentService.updateTorrentDisplayList();
}