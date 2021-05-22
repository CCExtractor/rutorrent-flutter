import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:rutorrentflutter/AppTheme/AppStateNotifier.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:rutorrentflutter/services/functional_services/api_service.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';
import 'package:rutorrentflutter/ui/shared/shared_styles.dart';
import 'package:stacked/stacked.dart';

class TorrentTileViewModel extends BaseViewModel {  
  
  ApiService _apiService = locator<ApiService>();
  UserPreferencesService _userPreferencesService = locator<UserPreferencesService>();
  TorrentService _torrentService = locator<TorrentService>();

  Torrent torrent = Torrent("dummy");

  get showAllAccounts => _userPreferencesService.showAllAccounts;
  Color statusColor = kGreyDT;

  init(Torrent torrentReceived,context){
    torrent = torrentReceived;
    statusColor = getStatusColor(torrent.status, context);
  }
  
  removeTorrentWithData(String hashValue) {
    _apiService.removeTorrentWithData(hashValue);
  }

  removeTorrent(String hashValue) {
    _apiService.removeTorrent(hashValue);
  }

  IconData getTorrentIconData() {
    return torrent.isOpen == 0
        ? Icons.play_circle_filled
        : torrent.getState == 0
            ? (Icons.play_circle_filled)
            : Icons.pause_circle_filled;
  }

  toggleTorrentStatus(Torrent torrent) async {
    await _apiService.toggleTorrentStatus(torrent);
    _userPreferencesService.showAllAccounts
    ? await _apiService.getAllAccountsTorrentList().listen((event) { }).cancel()
    : await _apiService.getTorrentList().listen((event) { }).cancel();
  } 

  getStatusColor(Status status, BuildContext context) {
    switch (status) {
      case Status.downloading:
        return Theme.of(context).primaryColor;
      case Status.paused:
        return !AppStateNotifier.isDarkModeOn ? kGreyDT : kGreyLT;
      case Status.stopped:
        return !AppStateNotifier.isDarkModeOn ? kGreyDT : kGreyLT;
      case Status.completed:
        return !AppStateNotifier.isDarkModeOn
            ? kGreenActiveLT
            : kGreenActiveDT;
      case Status.errors:
        return !AppStateNotifier.isDarkModeOn
            ? kGreenActiveLT
            : kRedErrorDT;
    }
  }
}