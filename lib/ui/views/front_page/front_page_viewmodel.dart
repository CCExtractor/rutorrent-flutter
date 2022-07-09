// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:rutorrentflutter/ui/views/Download/download_view.dart';
import 'package:rutorrentflutter/ui/views/rss_feed/rss_feed_view.dart';
import 'package:rutorrentflutter/ui/views/rss_filters/rss_filters_view.dart';
import 'package:rutorrentflutter/ui/views/torrent_list/torrent_list_view.dart';
import 'package:stacked/stacked.dart';

class FrontPageViewModel extends BaseViewModel {
  PageController _pageController = PageController();
  PageController get pageController => _pageController;
  int? homeViewPageIndex = 0;
  int currentIndex = 0;

  List<String> kTorrentTitle = [
    'All Torrents',
    'Downloaded',
  ];

  List<String> kFeedsTitle = [
    'RSS Feeds',
    'RSS Filters',
  ];

  List<Widget> kTorrentPages = [
    TorrentListView(),
    DownloadView(),
  ];

  List<Widget> kFeedPages = [
    RSSFeedView(),
    RSSFiltersView(),
  ];

  String getTitle(int titleNumber) {
    return homeViewPageIndex == 0
        ? kTorrentTitle[titleNumber]
        : kFeedsTitle[titleNumber];
  }

  List<Widget> getPagesList() {
    return homeViewPageIndex == 0 ? kTorrentPages : kFeedPages;
  }

  void changeIndex(int i) {
    currentIndex = i;
    notifyListeners();
  }
}
