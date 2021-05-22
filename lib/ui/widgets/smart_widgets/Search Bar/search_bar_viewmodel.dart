import 'package:flutter/material.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/enums/bottom_sheet_type.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchBarWidgetViewModel extends BaseViewModel {

  UserPreferencesService? _userPreferencesService = locator<UserPreferencesService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  TorrentService _torrentService = locator<TorrentService>();

  bool isSearching = false;
  FocusNode _searchBarFocus = FocusNode();
  get searchBarFocus => _searchBarFocus;

  get searchTextController => _userPreferencesService!.searchTextController;

  setSearchingState(bool search) {
    isSearching = search;
    notifyListeners();
  }

  void showSortBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.sortBottomSheet
    );
  }

  onTyping(String searchKey) {
    _torrentService.updateTorrentDisplayList(searchText: searchKey);
  }
}