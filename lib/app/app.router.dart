// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../models/torrent.dart';
import '../ui/views/DiskExplorer/disk_explorer_view.dart';
import '../ui/views/History/history_view.dart';
import '../ui/views/MediaPlayer/media_stream_view.dart';
import '../ui/views/Settings/settings_view.dart';
import '../ui/views/TorrentDetail/torrent_detail_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/splash/splash_view.dart';

class Routes {
  static const String splashView = '/';
  static const String loginView = '/login-view';
  static const String homeView = '/home-view';
  static const String historyView = '/history-view';
  static const String settingsView = '/settings-view';
  static const String diskExplorerView = '/disk-explorer-view';
  static const String mediaStreamView = '/media-stream-view';
  static const String torrentDetailView = '/torrent-detail-view';
  static const all = <String>{
    splashView,
    loginView,
    homeView,
    historyView,
    settingsView,
    diskExplorerView,
    mediaStreamView,
    torrentDetailView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.splashView, page: SplashView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.historyView, page: HistoryView),
    RouteDef(Routes.settingsView, page: SettingsView),
    RouteDef(Routes.diskExplorerView, page: DiskExplorerView),
    RouteDef(Routes.mediaStreamView, page: MediaStreamView),
    RouteDef(Routes.torrentDetailView, page: TorrentDetailView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    SplashView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const SplashView(),
        settings: data,
      );
    },
    LoginView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginView(),
        settings: data,
      );
    },
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const HomeView(),
        settings: data,
      );
    },
    HistoryView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const HistoryView(),
        settings: data,
      );
    },
    SettingsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const SettingsView(),
        settings: data,
      );
    },
    DiskExplorerView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const DiskExplorerView(),
        settings: data,
      );
    },
    MediaStreamView: (data) {
      var args = data.getArgs<MediaStreamViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => MediaStreamView(
          mediaName: args.mediaName,
          mediaUrl: args.mediaUrl,
          path: args.path,
        ),
        settings: data,
      );
    },
    TorrentDetailView: (data) {
      var args = data.getArgs<TorrentDetailViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => TorrentDetailView(torrent: args.torrent),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// MediaStreamView arguments holder class
class MediaStreamViewArguments {
  final String mediaName;
  final String mediaUrl;
  final String path;
  MediaStreamViewArguments(
      {required this.mediaName, required this.mediaUrl, required this.path});
}

/// TorrentDetailView arguments holder class
class TorrentDetailViewArguments {
  final Torrent torrent;
  TorrentDetailViewArguments({required this.torrent});
}
