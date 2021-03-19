import 'dart:async';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/components/add_url_bottom_sheet.dart';
import 'package:rutorrentflutter/components/disk_space_block.dart';
import 'package:rutorrentflutter/components/label_tile.dart';
import 'package:rutorrentflutter/models/settings.dart';
import 'package:rutorrentflutter/screens/disk_explorer_screen.dart';
import 'package:rutorrentflutter/screens/history_screen.dart';
import 'package:rutorrentflutter/pages/home_page.dart';
import 'package:rutorrentflutter/screens/settings_screen.dart';
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
  int _currentIndex = 0; // HomePage
  PackageInfo packageInfo = new PackageInfo(
      packageName: '', appName: '', buildNumber: '', version: '');

  _initPlugins() async {
    /// Setting application version
    packageInfo = await PackageInfo.fromPlatform();

    /// Setting accounts list
    Provider.of<GeneralFeatures>(context, listen: false).apis =
        await Preferences.fetchSavedLogin();
    setState(() {});

    while (this.mounted) {
      try {
        await Future.delayed(Duration(seconds: 1), () {});
        ApiRequests.updatePlugins(Provider.of(context, listen: false),
            Provider.of<GeneralFeatures>(context, listen: false), context);
      } catch (e) {}
    }
  }

  List<Widget> _getAccountsList(Api api, Mode mode, GeneralFeatures general) {
    // Function to match two Api configurations
    bool matchApi(Api api1, Api api2) {
      if (api1.url == api2.url &&
          api1.username == api2.username &&
          api1.password == api2.password) {
        return true;
      }
      return false;
    }

    // Add List of Accounts
    List<Widget> accountsList = general.apis
        .map((e) => Container(
              color: matchApi(e, api) ? Theme.of(context).disabledColor : null,
              child: ListTile(
                dense: true,
                title: Text(
                  e.url,
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {
                  if (!matchApi(e, api)) {
                    // Change Account
                    api.setUrl(e.url);
                    api.setUsername(e.username);
                    api.setPassword(e.password);

                    // Swapping Apis to make selected api as default
                    int index = general.apis.indexOf(e);
                    Api swapApi = general.apis[0];
                    general.apis[0] = general.apis[index];
                    general.apis[index] = swapApi;

                    Preferences.saveLogin(general.apis);

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

    // Add "All Accounts" Mode Option
    accountsList.insert(
        0,
        Container(
          child: ListTile(
            dense: true,
            leading: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: general.allAccounts
                    ? Theme.of(context).accentColor
                    : Theme.of(context).disabledColor,
              ),
            ),
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

    // Add "Add Another Accounts" Option
    accountsList.add(Container(
      child: ListTile(
        dense: true,
        leading: Icon(Icons.add),
        title: Text('Add another account'),
        onTap: () {
          Navigator.push(
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

  @override
  Widget build(BuildContext context) {
    return Consumer3<Mode, Api, GeneralFeatures>(
        builder: (context, mode, api, general, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Hey, ${api.username}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          elevation: 0.0,
          leading: Builder(builder: (context) {
            return IconButton(
                icon: Icon(
                  Icons.subject,
                  size: 34,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                });
          }),
          actions: <Widget>[
            IconButton(
                icon: FaIcon(
                  mode.isLightMode
                      ? FontAwesomeIcons.solidMoon
                      : FontAwesomeIcons.solidSun,
                ),
                onPressed: () async {
                  mode.toggleMode();
                  Provider.of<Settings>(context, listen: false)
                      .setShowDarkMode(mode.isDarkMode);
                  await Preferences.saveSettings(
                      Provider.of<Settings>(context, listen: false));
                }),
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
                    SizedBox(height: 20),
                    Text(
                      'Application version: ${packageInfo.version}',
                      style:
                          TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              ShowDiskSpace(),
              ExpansionTile(
                leading: Icon(Icons.supervisor_account,
                    color: mode.isLightMode ? Colors.black : Colors.white),
                title: Text('Accounts'),
                children: _getAccountsList(api, mode, general),
              ),
              ExpansionTile(
                initiallyExpanded: true,
                leading: Icon(Icons.sort,
                    color: mode.isLightMode ? Colors.black : Colors.white),
                title: Text(
                  'Filters',
                ),
                children: general.filterTileList,
              ),
              ExpansionTile(
                initiallyExpanded: true,
                leading: Icon(Icons.sort,
                    color: mode.isLightMode ? Colors.black : Colors.white),
                title: Text(
                  'Labels',
                ),
                children: (general.listOfLabels as List<String>)
                    .map((e) => LabelTile(label: e))
                    .toList(),
              ),
              ListTile(
                leading: Icon(Icons.history,
                    color: mode.isLightMode ? Colors.black : Colors.white),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HistoryScreen()));
                },
                title: Text('History'),
              ),
              ListTile(
                leading: Icon(Icons.folder_open,
                    color: mode.isLightMode ? Colors.black : Colors.white),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DiskExplorer(),
                      ));
                },
                title: Text('Explorer'),
              ),
              ListTile(
                leading: Icon(Icons.settings,
                    color: mode.isLightMode ? Colors.black : Colors.white),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ));
                },
                title: Text('Settings'),
              ),
              ListTile(
                leading: Icon(Icons.info_outline,
                    color: mode.isLightMode ? Colors.black : Colors.white),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationVersion: packageInfo.version,
                    applicationIcon: Image(
                      height: 75,
                      image: mode.isLightMode
                          ? AssetImage('assets/logo/light_mode_icon.png')
                          : AssetImage('assets/logo/dark_mode_icon.png'),
                    ),
                    children: [
                      Text(
                        'Build Number : $BUILD_NUMBER',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Release Date : $RELEASE_DATE',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Package Name : ${packageInfo.packageName}',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  );
                },
                title: Text('About'),
              ),
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
            HomePage(0),
            HomePage(1),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor:
              Provider.of<Mode>(context).isDarkMode ? kGreyDT : null,
          selectedItemColor: Theme.of(context).primaryColor,
          currentIndex: _currentIndex,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.rss_feed), label: 'Feeds')
          ],
          onTap: (index) {
            setState(() => _currentIndex = index);
            general.pageController.jumpToPage(index);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.library_add,
            color: Colors.white,
          ),
          onPressed: () {
            if (_currentIndex == 0) {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext bc) {
                    return AddBottomSheet(
                        api: api,
                        apiRequest: (url) {
                          ApiRequests.addTorrent(api, url);
                        },
                        dialogHint: 'Enter Torrent Url');
                  });
            } else {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext bc) {
                    return AddBottomSheet(
                        apiRequest: (url) async {
                          await ApiRequests.addRSS(api, url);
                          setState(() {});
                        },
                        dialogHint: 'Enter Rss Url');
                  });
            }
          },
        ),
      );
    });
  }
}
