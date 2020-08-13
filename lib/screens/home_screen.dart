import 'dart:async';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/components/disk_space_block.dart';
import 'package:rutorrentflutter/components/add_dialog.dart';
import 'package:rutorrentflutter/components/history_sheet.dart';
import 'package:rutorrentflutter/components/rss_filter_details.dart';
import 'package:rutorrentflutter/pages/downloads_page.dart';
import 'package:rutorrentflutter/pages/rss_feeds.dart';
import 'package:rutorrentflutter/pages/settings_page.dart';
import 'package:rutorrentflutter/pages/torrents_list_page.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/screens/configurations_screen.dart';
import 'package:rutorrentflutter/services/preferences.dart';
import '../api/api_conf.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 0; // TorrentsListPage
  List<Api> apis = []; // Containing info of all saved accounts
  bool showAllAccounts = false;

  _initPlugins() async {
    Provider.of<GeneralFeatures>(context, listen: false).scaffoldKey =
        _scaffoldKey;

    apis = await Preferences.fetchSavedLogin();
    setState(() {});// updating the drawer list

    while (mounted) {
      try {
        await Future.delayed(Duration(seconds: 1), () {});
        ApiRequests.updatePlugins(Provider.of(context, listen: false),
            Provider.of<GeneralFeatures>(context, listen: false));
      } catch (e) {}
    }
  }

  List<Widget> _getAccountsList(Api api, Mode mode) {
    List<Widget> accountsList = apis
        .map((e) => Container(
              color: matchApi(e, api) && !showAllAccounts
                  ? (mode.isLightMode ? Colors.grey[300] : kDarkGrey)
                  : null,
              child: ListTile(
                dense: true,
                title: Text(
                  e.url,
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {
                  if (!matchApi(e, api)) {
                    api.setUrl(e.url);
                    api.setUsername(e.username);
                    api.setPassword(e.password);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  } else {
                    Navigator.pop(context);
                    setState(() => showAllAccounts = false);
                  }
                },
              ),
            ))
        .toList();
    accountsList.insert(
        0,
        Container(
          color: showAllAccounts
              ? (mode.isLightMode ? Colors.grey[300] : kDarkGrey)
              : null,
          child: ListTile(
            onTap: () {
              setState(() => showAllAccounts = true);
              Navigator.pop(context);
            },
            title: Text(
              'All Accounts',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ));
    return accountsList;
  }

  @override
  void initState() {
    super.initState();
    _initPlugins();
  }

  bool matchApi(Api api1, Api api2) {
    if (api1.url == api2.url &&
        api1.username == api2.username &&
        api1.password == api2.password)
      return true;
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<Mode, Api, GeneralFeatures>(
        builder: (context, mode, api, general, child) {
      return Scaffold(
        key: general.scaffoldKey,
        appBar: AppBar(
          backgroundColor:
              mode.isLightMode ? Colors.grey[300] : Colors.grey[900],
          leading: Builder(builder: (context) {
            return IconButton(
                icon: Icon(
                  Icons.subject,
                  size: 34,
                ),
                color: mode.isLightMode ? kDarkGrey : Colors.white,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                });
          }),
          actions: <Widget>[
            _currentIndex == 0
                ? IconButton(
                    icon: Icon(
                      Icons.library_add,
                      color: mode.isLightMode ? kDarkGrey : Colors.white,
                    ),
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
                  )
                : _currentIndex == 1
                    ? IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.rss,
                          color: mode.isLightMode ? kDarkGrey : Colors.white,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => RSSFilterDetails());
                        },
                      )
                    : Container(),
            IconButton(
                icon: Icon(
                  mode.isLightMode
                      ? FontAwesomeIcons.solidMoon
                      : FontAwesomeIcons.solidSun,
                  color: mode.isLightMode ? kDarkGrey : Colors.white,
                ),
                onPressed: () => mode.toggleMode()),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image(
                      image: mode.isLightMode
                          ? AssetImage('assets/logo/light_mode.png')
                          : AssetImage('assets/logo/dark_mode.png'),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Application version: 0.01',
                      style:
                          TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              ShowDiskSpace(),
              ExpansionTile(
                title: Text('Accounts'),
                children: _getAccountsList(api, mode),
              ),
              ListTile(
                dense: true,
                leading: Icon(Icons.add),
                title: Text('Add another account'),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfigurationsScreen(),
                      ));
                },
              ),
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
                      expand: true,
                      context: context,
                      builder: (context, controller) => HistorySheet());
                },
                title: Text('Show History'),
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
            TorrentsListPage(showAllAccounts, apis),
            RSSFeeds(),
            DownloadsPage(),
            SettingsPage(),
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
              activeColor: mode.isLightMode ? kBlue : kIndigo,
              inactiveColor: mode.isLightMode ? kDarkGrey : Colors.white,
            ),
            BottomNavyBarItem(
              title: Text('Feeds'),
              icon: Icon(Icons.rss_feed),
              activeColor: mode.isLightMode ? kBlue : kIndigo,
              inactiveColor: mode.isLightMode ? kDarkGrey : Colors.white,
            ),
            BottomNavyBarItem(
              title: Text('Downloads'),
              icon: Icon(Icons.file_download),
              activeColor: mode.isLightMode ? kBlue : kIndigo,
              inactiveColor: mode.isLightMode ? kDarkGrey : Colors.white,
            ),
            BottomNavyBarItem(
              title: Text('Settings'),
              icon: Icon(Icons.settings),
              activeColor: mode.isLightMode ? kBlue : kIndigo,
              inactiveColor: mode.isLightMode ? kDarkGrey : Colors.white,
            ),
          ],
        ),
      );
    });
  }
}
