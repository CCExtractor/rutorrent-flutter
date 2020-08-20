import 'dart:io';

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/components/file_tile.dart';
import 'package:rutorrentflutter/components/torrent_tile.dart';
import 'package:rutorrentflutter/utilities/constants.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/models/torrent.dart';

class TorrentDetailSheet extends StatefulWidget {
  final Torrent torrent;
  TorrentDetailSheet(this.torrent);

  @override
  _TorrentDetailSheetState createState() => _TorrentDetailSheetState();
}

class _TorrentDetailSheetState extends State<TorrentDetailSheet> {
  Torrent torrent;
  final ScrollController _scrollController = ScrollController();

  IconData _getTorrentIconData(Torrent torrent) {
    return torrent.isOpen == 0
        ? Icons.play_arrow
        : torrent.getState == 0 ? (Icons.play_arrow) : Icons.pause;
  }

  syncFiles() async{
    String localFilesPath = (await getExternalStorageDirectory()).path+'/';
    var localItems = Directory(localFilesPath).listSync(recursive: true);

    List<String> localFiles=[];
    for(dynamic localItem in localItems){
      if(localItem is File){
        localItem = localItem.path.substring(localItem.path.lastIndexOf('/')+1);
        localFiles.add(localItem);
      }
    }
    for(var file in torrent.files)
      if(localFiles.contains(file.name))
        file.isPresentLocally = true;

    setState(() {});
  }

  _getFiles() async {
    torrent.files =
        await ApiRequests.getFiles(widget.torrent.api, widget.torrent.hash);
    syncFiles();
    setState(() {});
  }

  _getTrackers() async {
    torrent.trackers =
        await ApiRequests.getTrackers(widget.torrent.api, widget.torrent.hash);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    torrent = widget.torrent;
    _getFiles();
    _getTrackers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.keyboard_backspace,
                          color: Provider.of<Mode>(context).isLightMode
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      Flexible(
                        child: Center(
                          child: Text(widget.torrent.name,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
                StreamBuilder(
                    initialData: widget.torrent,
                    stream: ApiRequests.updateSheetData(
                        widget.torrent.api, widget.torrent),
                    builder: (context, snapshot) {
                      Torrent updatedTorrent = snapshot.data ?? widget.torrent;
                      return Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              IconButton(
                                  color: kRed,
                                  iconSize: 40,
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    ApiRequests.removeTorrent(
                                        widget.torrent.api,
                                        widget.torrent.hash);
                                    Navigator.pop(context);
                                  }),
                              SizedBox(
                                width: 25,
                              ),
                              IconButton(
                                color: Provider.of<Mode>(context).isLightMode
                                    ? kBlue
                                    : kIndigo,
                                iconSize: 40,
                                icon: Icon(_getTorrentIconData(widget.torrent)),
                                onPressed: () =>
                                    ApiRequests.toggleTorrentStatus(
                                        widget.torrent.api,
                                        updatedTorrent.hash,
                                        updatedTorrent.isOpen,
                                        updatedTorrent.getState),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              IconButton(
                                  color: Colors.grey,
                                  iconSize: 44,
                                  icon: Icon(Icons.stop),
                                  onPressed: () => ApiRequests.stopTorrent(
                                      widget.torrent.api, widget.torrent.hash)),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          Text(
                            '${updatedTorrent.percentageDownload}%',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: TorrentTile.getStatusColor(
                                    updatedTorrent.status, context)),
                          ),
                          Divider(
                            thickness: 8,
                            color: TorrentTile.getStatusColor(
                                updatedTorrent.status, context),
                          ),
                        ],
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Size: ${filesize(widget.torrent.size)}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      Text(
                          'Added: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(widget.torrent.torrentAdded * 1000))}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Save Path: ${widget.torrent.savePath}',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
                StreamBuilder(
                  initialData: widget.torrent,
                  stream: ApiRequests.updateSheetData(
                      widget.torrent.api, widget.torrent),
                  builder: (context, snapshot) {
                    Torrent updatedTorrent = snapshot.data ?? widget.torrent;
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.grey)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                      updatedTorrent.dlSpeed > 0
                                          ? updatedTorrent.eta
                                          : '∞',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                  Text('ETA',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text('${updatedTorrent.seedsActual}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                  Text('Seeds',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    '${filesize(updatedTorrent.downloadedData)}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Downloaded',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text('${filesize(updatedTorrent.dlSpeed)}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                  Text('Downloading Speed',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text('${updatedTorrent.ratio / 1000}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                  Text('Ratio',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text('${updatedTorrent.peersActual}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                  Text('Peers',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    '${filesize(updatedTorrent.uploadedData)}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Uploaded',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text('${filesize(updatedTorrent.ulSpeed)}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                  Text('Uploading Speed',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text('Files',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  children: <Widget>[
                    ListView.builder(
                      controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: torrent.files.length,
                        itemBuilder: (context, index) {
                          return FileTile(torrent.files[index], torrent, syncFiles);
                        })
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    'Trackers',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  children: <Widget>[
                    ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: torrent.trackers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            dense: true,
                            title: Text(
                              torrent.trackers[index],
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ));
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
