import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/pages/torrents_list_page.dart';
import 'package:rutorrentflutter/utilities/constants.dart';
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
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap:()=>_pageController.animateToPage(0, duration: Duration(milliseconds: 100), curve: Curves.linear),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('All Torrents',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _currentIndex == 0
                              ? (Provider.of<Mode>(context).isLightMode
                                  ? kBlue
                                  : kIndigo)
                              : Colors.grey,
                        )),
                    Container(
                      height: 3.5,
                      width: 60,
                      color: _currentIndex == 0
                          ? (Provider.of<Mode>(context).isLightMode
                          ? kBlue
                          : kIndigo)
                          : null,
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap:()=>_pageController.animateToPage(1, duration: Duration(milliseconds: 100), curve: Curves.linear),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Downloaded',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _currentIndex == 1
                            ? (Provider.of<Mode>(context).isLightMode
                                ? kBlue
                                : kIndigo)
                            : Colors.grey,
                      ),
                    ),
                    Container(
                      height: 3.5,
                      width: 60,
                      color: _currentIndex == 1
                          ? (Provider.of<Mode>(context).isLightMode
                          ? kBlue
                          : kIndigo)
                          : null,
                    ),
                  ],
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
