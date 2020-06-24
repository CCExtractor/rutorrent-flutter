import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api_requests.dart';
import 'package:rutorrentflutter/components/torrent_add_dialog.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import '../api_conf.dart';
import '../constants.dart' as Constants;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rutorrentflutter/components/torrent_tile.dart';
import 'package:rutorrentflutter/models/torrent.dart';

class HomeScreen extends StatefulWidget {
  final Api api;
  HomeScreen(this.api);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  http.Client client = http.Client();
  List<Torrent> sortedList = [];
  Sort sortPreference;
  TextEditingController searchTextController  = TextEditingController();
  bool isSearching = false;

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
                        Text('Disk Space (80%)', style: TextStyle(fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'SFUIDisplay/sf-ui-display-high.otf'),),
                        SizedBox(height: 10,),
                        Text('5GB left of 10GB', style: TextStyle(fontSize: 14,
                            color: Constants.kDarkGrey,
                            fontFamily: 'SFUIDisplay/sf-ui-display-medium.otf')),
                        SizedBox(height: 5,),
                        Container(
                          height: 10,
                          child: LinearProgressIndicator(
                            value: 0.66,
                            backgroundColor: Constants.kLightGrey,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Constants.kBlue),
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
                              onChanged: (value) {
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
                      stream: ApiRequests.initTorrentsData(context,widget.api),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: Text('No Torrents to Show'),);
                        }
                        sortedList = generalFeatures.sortList(snapshot.data, sortPreference);

                        //filtering list on basis of selected filter
                        sortedList = generalFeatures.filterList(
                            sortedList, generalFeatures.selectedFilter);

                        if (searchTextController.text.isNotEmpty) {
                          //showing list on basis of searched text
                          sortedList = sortedList.where((element) =>
                              element.name.toLowerCase().contains(
                                  searchTextController.text.toLowerCase()))
                              .toList();
                        }
                        return ListView.builder(
                          itemCount: sortedList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return TorrentTile(sortedList[index]);
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
    client.close();
  }
}

