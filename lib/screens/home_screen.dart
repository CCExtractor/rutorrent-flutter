import '../constants.dart' as Constants;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rutorrentflutter/components/torrent_tile.dart';
import 'dart:convert';
import 'package:rutorrentflutter/models/torrent.dart';

class HomeScreen extends StatefulWidget {
  static String url = 'https://fremicro081.xirvik.com/rtorrent/plugins/httprpc/action.php';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Torrent> sortedList = [];
  Constants.Sort sortPreference;
  TextEditingController searchTextController  = TextEditingController();
  bool isSearching = false;

  Stream<List<Torrent>> _initTorrentsData() async* {
    while(true) {
      await Future.delayed(Duration(seconds: 1),(){
      });
      List<Torrent> torrentsList = [];
      var response = await http.post(Uri.parse(HomeScreen.url),
          headers: {
            'authorization':Constants.getBasicAuth(),
          },
          body: {
            'mode': 'list',
          },
          encoding: Encoding.getByName("utf-8"));

      var torrentsPath = jsonDecode(response.body)['t'];
      for (var hashKey in torrentsPath.keys) {
        var torrentObject = torrentsPath[hashKey];
        Torrent torrent = Torrent(hashKey); // new torrent created
        torrent.name = torrentObject[4];
        torrent.size = int.parse(torrentObject[5]);
        torrent.savePath = torrentObject[25];
        torrent.remainingContent = filesize(torrentObject[19]);
        torrent.completedChunks = int.parse(torrentObject[6]);
        torrent.totalChunks = int.parse(torrentObject[7]);
        torrent.sizeOfChunk = int.parse(torrentObject[13]);
        torrent.torrentAdded = int.parse(torrentObject[21]);
        torrent.torrentCreated = int.parse(torrentObject[26]);
        torrent.seedsActual = int.parse(torrentObject[18]);
        torrent.peersActual = int.parse(torrentObject[15]);
        torrent.ulSpeed = int.parse(torrentObject[11]);
        torrent.dlSpeed = int.parse(torrentObject[12]);
        torrent.isOpen = int.parse(torrentObject[0]);
        torrent.getState = int.parse(torrentObject[3]);
        torrent.msg = torrentObject[29];
        torrent.downloadedData = filesize(torrentObject[8]);
        torrent.ratio = int.parse(torrentObject[10]);

        torrent.eta = torrent.getEta;
        torrent.percentageDownload= torrent.getPercentageDownload;
        torrent.status = torrent.getTorrentStatus;
        torrentsList.add(torrent);
      }
      yield torrentsList;
    }
  }

  @override
  void initState() {
    super.initState();
    _initTorrentsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.solidMoon),
            onPressed: (){
              Fluttertoast.showToast(msg: "Night mode currently unavailable");
            },
          ),
        ],
      ),
      drawer: Drawer(),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey[600],
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (value){
                          setState(() {
                            isSearching = searchTextController.text.isNotEmpty;
                          });
                        },
                        controller: searchTextController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                            hintText: 'Search your item by name'),
                      ),
                    ),
                    isSearching?
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: (){
                        searchTextController.clear();
                        setState(() {
                          isSearching=false;
                        });
                      },
                    ):
                    PopupMenuButton<Constants.Sort>(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(FontAwesomeIcons.slidersH,color: Colors.grey[700],),
                      ),
                      onSelected: (selectedChoice){
                        setState(() {
                          sortPreference = selectedChoice;
                        });
                      },
                      itemBuilder: (BuildContext context){
                        return Constants.Sort.values.map((Constants.Sort choice) {
                          return PopupMenuItem<Constants.Sort>(
                            enabled: !(sortPreference==choice),
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
                  border: Border.all(color: Colors.grey,width: 1.5),
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: _initTorrentsData(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(!snapshot.hasData){
                    return Center(child: Text('No Torrents to Show'),);
                  }
                  sortedList = _sortList(snapshot.data, sortPreference);
                  if(searchTextController.text.isNotEmpty) {
                    sortedList = sortedList.where((element) =>
                        element.name.toLowerCase().contains(searchTextController.text.toLowerCase()))
                        .toList();
                  }
                  return ListView.builder(
                    itemCount: sortedList.length,
                    itemBuilder: (BuildContext context,int index){
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

  List<Torrent> _sortList(List<Torrent> torrentsList, Constants.Sort sort,){
    switch(sort){
      case Constants.Sort.name:
        torrentsList.sort((a,b)=>a.name.compareTo(b.name));
        return torrentsList;
      case Constants.Sort.dateAdded:
        torrentsList.sort((a,b)=>a.torrentAdded.compareTo(b.torrentAdded));
        return torrentsList;
      case Constants.Sort.percentDownloaded:
        torrentsList.sort((a,b)=>a.percentageDownload.compareTo(b.percentageDownload));
        return torrentsList;
      case Constants.Sort.downloadSpeed:
        torrentsList.sort((a,b)=>a.dlSpeed.compareTo(b.dlSpeed));
        return torrentsList;
      case Constants.Sort.uploadSpeed:
        torrentsList.sort((a,b)=>a.ulSpeed.compareTo(b.ulSpeed));
        return torrentsList;
      case Constants.Sort.ratio:
        torrentsList.sort((a,b)=>a.ratio.compareTo(b.ratio));
        return torrentsList;
      case Constants.Sort.size:
        torrentsList.sort((a,b)=>a.size.compareTo(b.size));
        return torrentsList;
      default:
        return torrentsList;
    }
  }

}

