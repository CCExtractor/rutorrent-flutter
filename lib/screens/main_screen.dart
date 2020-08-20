import 'dart:async';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/components/disk_space_block.dart';
import 'package:rutorrentflutter/components/add_dialog.dart';
import 'package:rutorrentflutter/screens/history_sheet.dart';
import 'package:rutorrentflutter/components/rss_filter_details.dart';
import 'package:rutorrentflutter/pages/home_page.dart';
import 'package:rutorrentflutter/pages/rss_feeds.dart';
import 'package:rutorrentflutter/screens/settings_page.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/screens/configurations_screen.dart';
import 'package:rutorrentflutter/utilities/preferences.dart';
import '../api/api_conf.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utilities/constants.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 0; // HomePage

  _initPlugins() async {
    Provider.of<GeneralFeatures>(context, listen: false).scaffoldKey =
        _scaffoldKey;

    Provider.of<GeneralFeatures>(context, listen: false).apis =
        await Preferences.fetchSavedLogin();
    setState(() {}); // updating the drawer list

    while (this.mounted) {
      try {
        await Future.delayed(Duration(seconds: 1), () {});
        ApiRequests.updatePlugins(Provider.of(context, listen: false),
            Provider.of<GeneralFeatures>(context, listen: false));
      } catch (e) {}
    }
  }

  List<Widget> _getAccountsList(Api api, Mode mode, GeneralFeatures general) {
    List<Widget> accountsList = Provider.of<GeneralFeatures>(context)
        .apis
        .map((e) => Container(
              color: matchApi(e, api) && !general.allAccounts
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
                        MaterialPageRoute(builder: (context) => MainScreen()));
                  } else {
                    Navigator.pop(context);
                    setState(() => general.doNotShowAllAccounts());
                  }
                },
              ),
            ))
        .toList();

    accountsList.insert(
        0,
        Container(
          color: general.allAccounts
              ? (mode.isLightMode ? Colors.grey[300] : kDarkGrey)
              : null,
          child: ListTile(
            onTap: () {
              setState(() => general.showAllAccounts());
              Navigator.pop(context);
            },
            title: Text(
              'All Accounts',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ));

    accountsList.add(Container(
      child: ListTile(
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
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.rss,
                color: mode.isLightMode ? kDarkGrey : Colors.white,
              ),
              onPressed: () {
                showDialog(
                    context: context, builder: (context) => RSSFilterDetails());
              },
            ),
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
                children: _getAccountsList(api, mode, general),
              ),
              ExpansionTile(
                initiallyExpanded: false,
                title: Text(
                  'Filters',
                ),
                children: general.filterTileList,
              ),
              ListTile(
                onTap: () async {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>HistorySheet()
                  ));
                },
                title: Text('History'),
              ),
              ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    )),
                title: Text('Settings'),
              )
            ],
          ),
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: general.pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            HomePage(),
            RSSFeeds(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
          selectedItemColor: mode.isLightMode ? kBlue : kIndigo,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: new Text('Home',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.rss_feed),
              title: Text(
                'Feeds',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
          onTap: (index) {
            setState(() => _currentIndex = index);
            general.pageController.jumpToPage(index);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: mode.isLightMode ? kBlue : kIndigo,
          child: Icon(
            Icons.library_add,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AddDialog(
                      dialogHint: _currentIndex == 0
                          ? 'Enter torrent url'
                          : 'Enter rss url',
                      apiRequest: (url) {
                        _currentIndex == 0
                            ? ApiRequests.addTorrent(api, url)
                            : ApiRequests.addRSS(api, url);
                      },
                    ));
          },
        ),
      );
    });
  }
}
