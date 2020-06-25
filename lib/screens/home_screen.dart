import 'package:filesize/filesize.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/components/torrent_add_dialog.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import '../api/api_conf.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rutorrentflutter/components/torrent_tile.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import '../constants.dart' as Constants;

class HomeScreen extends StatefulWidget {
  final Api api;
  HomeScreen(this.api);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Torrent> torrentsList = [];
  Sort sortPreference;
  TextEditingController searchTextController  = TextEditingController();
  bool isSearching = false;
  FocusNode searchBarFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer<GeneralFeatures>(
      builder: (context,generalFeatures,child) {
        return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  showDialog(context: context,
                      builder: (context) =>
                          TorrentAddDialog(widget.api));
                },
                icon: Icon(Icons.add),
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.solidMoon),
                onPressed: () {
                  Fluttertoast.showToast(msg: "Night mode currently unavailable");
                },
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  child: Image(
                    image: AssetImage(
                        'assets/images/ruTorrent_mobile_logo.png'),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Disk Space (${generalFeatures.diskSpace.getPercentage()}%)', style: TextStyle(fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'SFUIDisplay/sf-ui-display-high.otf'),),
                        SizedBox(height: 10,),
                        Text('${filesize(generalFeatures.diskSpace.free)} left of ${filesize(generalFeatures.diskSpace.total)}', style: TextStyle(fontSize: 14,
                            color: Constants.kDarkGrey,
                            fontFamily: 'SFUIDisplay/sf-ui-display-medium.otf')),
                        SizedBox(height: 5,),
                        Container(
                          height: 10,
                          child: LinearProgressIndicator(
                            value: generalFeatures.diskSpace.getPercentage()/100,
                            backgroundColor: Constants.kLightGrey,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                    generalFeatures.diskSpace.isLow()?
                                    Constants.kRed: Constants.kBlue),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'Filters', style: TextStyle(color: Colors.black),),
                  children: generalFeatures.filterTileList,
                ),
                Divider(),
                ListTile(title: Text('Settings'),),
                ListTile(title: Text('About'),),
              ],
            ),
          ),
          body: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0),
                            child: Icon(
                              Icons.search,
                              color: Colors.grey[600],
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              focusNode: searchBarFocus,
                              onChanged: (value) {
                                if(value.isEmpty)
                                  searchBarFocus.unfocus();
                                setState(() {
                                  isSearching =
                                      searchTextController.text.isNotEmpty;
                                });
                              },
                              controller: searchTextController,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  hintText: 'Search your item by name'),
                            ),
                          ),
                          isSearching ?
                          IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              searchTextController.clear();
                              searchBarFocus.unfocus();
                              setState(() {
                                isSearching = false;
                              });
                            },
                          ) :
                          PopupMenuButton<Sort>(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(FontAwesomeIcons.slidersH,
                                color: Colors.grey[700],),
                            ),
                            onSelected: (selectedChoice) {
                              setState(() {
                                sortPreference = selectedChoice;
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return Sort.values.map((
                                  Sort choice) {
                                return PopupMenuItem<Sort>(
                                  enabled: !(sortPreference == choice),
                                  value: choice,
                                  child: Text(Constants.sortMap[choice]),
                                );
                              }).toList();
                            },
                          ),
                        ],
                      ),
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: ApiRequests.initTorrentsData(context,widget.api,generalFeatures),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: Text('No Torrents to Show'),);
                        }
                        torrentsList = generalFeatures.sortList(snapshot.data, sortPreference);

                        //filtering list on basis of selected filter
                        torrentsList = generalFeatures.filterList(
                            torrentsList, generalFeatures.selectedFilter);

                        if (searchTextController.text.isNotEmpty) {
                          //showing list on basis of searched text
                          torrentsList = torrentsList.where((element) =>
                              element.name.toLowerCase().contains(
                                  searchTextController.text.toLowerCase()))
                              .toList();
                        }
                        return ListView.builder(
                          itemCount: torrentsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return TorrentTile(torrentsList[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              )
          ),
        );
      }
    );
  }

  

  @override
  void dispose() {
    super.dispose();
    widget.api.client.close();
  }
}

