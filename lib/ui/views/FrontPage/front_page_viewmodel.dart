import 'package:flutter/material.dart';
import 'package:rutorrentflutter/ui/views/Download/download_view.dart';
import 'package:rutorrentflutter/ui/views/RSSFeed/RSSFeed_view.dart';
import 'package:rutorrentflutter/ui/views/RSSFilters/RSSFilters_view.dart';
import 'package:rutorrentflutter/ui/views/TorrentList/Torrent_list_view.dart';
import 'package:stacked/stacked.dart';

class FrontPageViewModel extends BaseViewModel {


  PageController _pageController = PageController();
  PageController get pageController => _pageController;
  int? homeViewPageIndex = 0 ;
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