// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, unused_import, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../models/torrent.dart';
import '../ui/views/History/history_view.dart';
import '../ui/views/IRSSI/IRSSI_view.dart';
import '../ui/views/Settings/settings_view.dart';
import '../ui/views/disk_explorer/disk_explorer_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/media_player/media_stream_view.dart';
import '../ui/views/splash/splash_view.dart';
import '../ui/views/torrent_detail/torrent_detail_view.dart';

class Routes {
  static const String splashView = '/';
  static const String loginView = '/login-view';
  static const String homeView = '/home-view';
  static const String historyView = '/history-view';
  static const String settingsView = '/settings-view';
  static const String diskExplorerView = '/disk-explorer-view';
  static const String mediaStreamView = '/media-stream-view';
  static const String torrentDetailView = '/torrent-detail-view';
  static const String iRSSIView = '/i-rs-si-view';
  static const all = <String>{
    splashView,
    loginView,
    homeView,
    historyView,
    settingsView,
    diskExplorerView,
    mediaStreamView,
    torrentDetailView,
    iRSSIView,
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
    RouteDef(Routes.iRSSIView, page: IRSSIView),
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
    IRSSIView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => IRSSIView(),
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

/// ************************************************************************
/// Extension for strongly typed navigation
/// *************************************************************************

extension NavigatorStateExtension on NavigationService {
  Future<dynamic> navigateToSplashView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.splashView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToLoginView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.loginView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToHomeView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.homeView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToHistoryView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.historyView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToSettingsView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.settingsView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToDiskExplorerView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.diskExplorerView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToMediaStreamView({
    required String mediaName,
    required String mediaUrl,
    required String path,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.mediaStreamView,
      arguments: MediaStreamViewArguments(
          mediaName: mediaName, mediaUrl: mediaUrl, path: path),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToTorrentDetailView({
    required Torrent torrent,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.torrentDetailView,
      arguments: TorrentDetailViewArguments(torrent: torrent),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToIRSSIView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.iRSSIView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }
}
