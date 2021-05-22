import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:rutorrentflutter/AppTheme/AppStateNotifier.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:rutorrentflutter/services/functional_services/api_service.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';
import 'package:rutorrentflutter/ui/shared/shared_styles.dart';
import 'package:stacked/stacked.dart';
final log = getLogger("TorrentTileViewModel");
class TorrentTileViewModel extends BaseViewModel {  
  
  ApiService? _apiService = locator<ApiService>();
  UserPreferencesService? _userPreferencesService = locator<UserPreferencesService>();
  TorrentService? _torrentService = locator<TorrentService>();

  Torrent? torrent = Torrent("dummy");

  get showAllAccounts => _userPreferencesService!.showAllAccounts;
  Color statusColor = kGreyDT;

  init(Torrent? torrentReceived,context){
    log.v("rebuild");
    torrent = torrentReceived;
    statusColor = getStatusColor(torrent!.status, context);
  }
  
  removeTorrentWithData(String hashValue) {
    _apiService!.removeTorrentWithData(hashValue);
  }

  removeTorrent(String hashValue) {
    _apiService!.removeTorrent(hashValue);
  }

  

  toggleTorrentStatus(Torrent torrent) async {
    await _apiService!.toggleTorrentStatus(torrent);
    //Refresh torrent list
    _userPreferencesService!.showAllAccounts
    ? await _apiService!.getAllAccountsTorrentList().listen((event) { }).cancel()
    : await _apiService!.getTorrentList().listen((event) { }).cancel();
    await _torrentService?.updateTorrentDisplayList(searchText: _userPreferencesService?.searchTextController.text);
  } 

  getStatusColor(Status? status, BuildContext context) {
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