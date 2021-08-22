import 'package:flutter/material.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/services/state_services/disk_file_service.dart';
import 'package:rutorrentflutter/services/state_services/history_service.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';
import 'package:stacked/stacked.dart';

class SearchBarWidgetViewModel extends BaseViewModel {
  UserPreferencesService? _userPreferencesService =
      locator<UserPreferencesService>();
  TorrentService _torrentService = locator<TorrentService>();
  DiskFileService _diskFileService = locator<DiskFileService>();
  HistoryService _historyService = locator<HistoryService>();

  Screens screen = Screens.TorrentListViewScreen;
  bool isSearching = false;
  FocusNode _searchBarFocus = FocusNode();

  get searchBarFocus => _searchBarFocus;
  get searchTextController => _userPreferencesService!.searchTextController;

  setSearchingState(bool search) {
    isSearching = search;
    notifyListeners();
  }

  onTyping(String searchKey) {
    switch (screen) {
      case Screens.TorrentListViewScreen:
        _torrentService.updateTorrentDisplayList();
        break;
      case Screens.DiskExplorerViewScreen:
        _diskFileService.updateDiskFileDisplayList();
        break;
      case Screens.TorrentHistoryViewScreen:
        _historyService.updateTorrentHistoryDisplayList();
        break;
      default:
        break;
    }
  }

  void init(Screens screen) {
    this.screen = screen;
  }

  String getHintText() {
    switch (screen) {
      case Screens.TorrentListViewScreen:
        return 'Search torrent by name';
      case Screens.DiskExplorerViewScreen:
        return 'Search file by name';
      case Screens.TorrentHistoryViewScreen:
        return 'Search History items by name';
    }
  }
}
