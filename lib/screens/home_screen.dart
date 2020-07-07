import 'package:provider/provider.dart';
import 'package:rutorrentflutter/components/search_bar.dart';
import 'package:rutorrentflutter/components/show_disk_space.dart';
import 'package:rutorrentflutter/components/torrent_add_dialog.dart';
import 'package:rutorrentflutter/components/torrent_list_stream.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/screens/configurations_screen.dart';
import '../api/api_conf.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants.dart' as Constants;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                    builder: (context) => TorrentAddDialog(api));
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
                  image: AssetImage('assets/images/ruTorrent_mobile_logo.png'),
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
        body: Column(
          children: <Widget>[
            SearchBar(),
            Expanded(child: TorrentListStream()),
          ],
        ),
      );
    });
  }
}
