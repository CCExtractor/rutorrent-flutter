import 'package:flutter/material.dart';
import 'package:rutorrentflutter/components/rss_filter_details.dart';
import 'package:rutorrentflutter/pages/rss_feeds.dart';
import 'package:rutorrentflutter/pages/torrents_list_page.dart';
import 'downloads_page.dart';

class HomePage extends StatefulWidget {
  final int pageIndex;
  HomePage(this.pageIndex);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  List<String> kTorrentTitle = [
    'All Torrents',
    'Downloaded',
  ];

  List<String> kFeedsTitle = [
    'RSS Feeds',
    'RSS Filters',
  ];

  List<Widget> kTorrentPages = [
    TorrentsListPage(),
    DownloadsPage(),
  ];

  List<Widget> kFeedPages = [
    RSSFeeds(),
    RSSFilterDetails(),
  ];

  String _getTitle(int titleNumber) {
    return widget.pageIndex == 0
        ? kTorrentTitle[titleNumber]
        : kFeedsTitle[titleNumber];
  }

  List<Widget> _getPagesList() {
    return widget.pageIndex == 0 ? kTorrentPages : kFeedPages;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor,
          height: 60,
          child: Row(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: GestureDetector(
                  onTap: () => _pageController.animateToPage(0,
                      duration: Duration(milliseconds: 100),
                      curve: Curves.linear),
                  child: Text(
                    _getTitle(0),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _currentIndex == 0 ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: GestureDetector(
                  onTap: () => _pageController.animateToPage(1,
                      duration: Duration(milliseconds: 100),
                      curve: Curves.linear),
                  child: Text(
                    _getTitle(1),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _currentIndex == 1 ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: PageView(
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            controller: _pageController,
            children: _getPagesList(),
          ),
        ),
      ],
    );
  }
}
