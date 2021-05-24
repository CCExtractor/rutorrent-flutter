// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../ui/views/Disk%20Explorer/disk_explorer_view.dart';
import '../ui/views/History/history_view.dart';
import '../ui/views/Settings/settings_view.dart';
import '../ui/views/Video%20Stream/video_stream_view.dart';
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
  static const String videoStreamView = '/video-stream-view';
  static const all = <String>{
    splashView,
    loginView,
    homeView,
    historyView,
    settingsView,
    diskExplorerView,
    videoStreamView,
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
    RouteDef(Routes.videoStreamView, page: VideoStreamView),
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
    VideoStreamView: (data) {
      var args = data.getArgs<VideoStreamViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => VideoStreamView(
          mediaName: args.mediaName,
          mediaUrl: args.mediaUrl,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// VideoStreamView arguments holder class
class VideoStreamViewArguments {
  final String mediaName;
  final String mediaUrl;
  VideoStreamViewArguments({required this.mediaName, required this.mediaUrl});
}
