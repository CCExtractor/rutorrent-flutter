import 'package:flutter/material.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';
import 'package:stacked/stacked.dart';

class SearchBarWidgetViewModel extends BaseViewModel {

  UserPreferencesService _userPreferencesService = locator<UserPreferencesService>();

  bool isSearching = false;
  FocusNode _searchBarFocus = FocusNode();
  get searchBarFocus => _searchBarFocus;

  get searchTextController => _userPreferencesService.searchTextController;

  setSearchingState(bool search) {
    isSearching = search;
    notifyListeners();
  }
}