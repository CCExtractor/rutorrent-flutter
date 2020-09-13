import 'package:flutter/material.dart';
import 'package:rutorrentflutter/pages/torrents_list_page.dart';
import 'downloads_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

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
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: GestureDetector(
                  onTap: () => _pageController.animateToPage(0,
                      duration: Duration(milliseconds: 100),
                      curve: Curves.linear),
                  child: Text('All Torrents',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _currentIndex == 0
                            ? Colors.white
                            : Colors.grey,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: GestureDetector(
                  onTap: () => _pageController.animateToPage(1,
                      duration: Duration(milliseconds: 100),
                      curve: Curves.linear),
                  child: Text(
                    'Downloaded',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _currentIndex == 1
                          ? Colors.white
                          : Colors.grey,
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
            children: <Widget>[
              TorrentsListPage(),
              DownloadsPage(),
            ],
          ),
        ),
      ],
    );
  }
}
