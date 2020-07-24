import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/components/disk_space_block.dart';
import 'package:rutorrentflutter/components/add_dialog.dart';
import 'package:rutorrentflutter/components/history_sheet.dart';
import 'package:rutorrentflutter/pages/rss_feeds.dart';
import 'package:rutorrentflutter/pages/torrents_list_page.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/screens/configurations_screen.dart';
import '../api/api_conf.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import '../constants.dart' as Constants;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer3<Mode, Api, GeneralFeatures>(
        builder: (context, mode, api, general, child) {
      return Scaffold(
        appBar: AppBar(
          leading: Builder(builder: (context) {
            return IconButton(
                icon: Icon(
                  Icons.subject,
                  size: 34,
                ),
                color: mode.isLightMode ? Constants.kDarkGrey : Colors.white,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                });
          }),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AddDialog(
                          dialogHint: 'Enter torrent url',
                          apiRequest: (url) {
                            ApiRequests.addTorrent(api, url);
                          },
                        ));
              },
              icon: Icon(
                Icons.library_add,
                color: mode.isLightMode ? Constants.kDarkGrey : Colors.white,
              ),
            ),
            IconButton(
                icon: Icon(
                  mode.isLightMode
                      ? FontAwesomeIcons.solidMoon
                      : FontAwesomeIcons.solidSun,
                  color: mode.isLightMode ? Constants.kDarkGrey : Colors.white,
                ),
                onPressed: () => mode.toggleMode()),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Image(
                  image: mode.isLightMode
                      ? AssetImage('assets/logo/light_mode.png')
                      : AssetImage('assets/logo/dark_mode.png'),
                ),
              ),
              ShowDiskSpace(),
              ExpansionTile(
                initiallyExpanded: true,
                title: Text(
                  'Filters',
                ),
                children: general.filterTileList,
              ),
              ListTile(
                onTap: () async {
                  Navigator.pop(context);
                  showMaterialModalBottomSheet(
                      context: context,
                      builder: (context, controller) => HistorySheet());
                },
                title: Text('History'),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConfigurationsScreen()));
                },
                title: Text('Reconfigure'),
              ),
            ],
          ),
        ),
        body: PageView(
          controller: general.pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            TorrentsListPage(),
            RSSFeeds(),
            Center(
              child: Text('Nothing Here Now'),
            ),
            Center(
              child: Text('Settings Page'),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() => _currentIndex = index);
            general.pageController.jumpToPage(index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              title: Text('Home'),
              icon: Icon(Icons.home),
              activeColor:
                  mode.isLightMode ? Constants.kBlue : Constants.kIndigo,
              inactiveColor:
                  mode.isLightMode ? Constants.kDarkGrey : Colors.white,
            ),
            BottomNavyBarItem(
              title: Text('Feeds'),
              icon: Icon(Icons.rss_feed),
              activeColor:
                  mode.isLightMode ? Constants.kBlue : Constants.kIndigo,
              inactiveColor:
                  mode.isLightMode ? Constants.kDarkGrey : Colors.white,
            ),
            BottomNavyBarItem(
              title: Text('Downloads'),
              icon: Icon(Icons.file_download),
              activeColor:
                  mode.isLightMode ? Constants.kBlue : Constants.kIndigo,
              inactiveColor:
                  mode.isLightMode ? Constants.kDarkGrey : Colors.white,
            ),
            BottomNavyBarItem(
              title: Text('Settings'),
              icon: Icon(Icons.settings),
              activeColor:
                  mode.isLightMode ? Constants.kBlue : Constants.kIndigo,
              inactiveColor:
                  mode.isLightMode ? Constants.kDarkGrey : Colors.white,
            ),
          ],
        ),
      );
    });
  }
}
