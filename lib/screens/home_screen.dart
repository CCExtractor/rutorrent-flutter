import 'dart:async';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/components/disk_space_block.dart';
import 'package:rutorrentflutter/components/add_dialog.dart';
import 'package:rutorrentflutter/components/history_sheet.dart';
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
import '../constants.dart' as Constants;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  List<Api> apis=[];

  bool matchApi(Api api1,Api api2){
    if(api1.url==api2.url &&
        api1.username==api2.username &&
        api1.password==api2.password)
      return true;
    else
      return false;
  }

  _initPlugins() async{
    Provider.of<GeneralFeatures>(context,listen: false).scaffoldKey=_scaffoldKey;
    apis = await Preferences.fetchSavedLogin();
    setState(() {
    });
    while(mounted){
      try {
        await Future.delayed(Duration(seconds: 1), () {});
        ApiRequests.updatePlugins(Provider.of(context, listen: false),
            Provider.of<GeneralFeatures>(context, listen: false));
      }
      catch(e){
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initPlugins();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<Mode, Api, GeneralFeatures>(
        builder: (context, mode, api, general, child) {
      return Scaffold(
        key: general.scaffoldKey,
        appBar: AppBar(
          backgroundColor: mode.isLightMode
              ?Colors.grey[300]
              :Colors.grey[900],
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
                    Text('Application version: 1.01',style: TextStyle(fontSize: 12,fontStyle: FontStyle.italic),),
                  ],
                ),
              ),
              ShowDiskSpace(),
              ExpansionTile(
                title: Text('Accounts'),
                children: apis.map((e) => Container(
                  color: matchApi(e, api)?(mode.isLightMode?
                    Constants.kLightGrey:
                    Constants.kDarkGrey):null,
                  child: ListTile(
                    dense: true,
                    title: Text(e.url,
                    style: TextStyle(fontSize: 12),),
                    onTap: (){
                      api.setUrl(e.url);
                      api.setUsername(e.username);
                      api.setPassword(e.password);
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context)=>HomeScreen()
                      ));
                    },
                  ),
                )).toList(),
              ),
              ListTile(
                dense: true,
                leading: Icon(Icons.add),
                title: Text('Add another account'),
                onTap: (){
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(
                        builder: (context)=> ConfigurationsScreen(),
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
            TorrentsListPage(),
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
