import 'dart:convert';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/constants.dart' as Constants;
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:http/http.dart' as http;

class TorrentDetailSheet extends StatefulWidget {
  final Torrent torrent;
  TorrentDetailSheet(this.torrent);
  @override
  _TorrentDetailSheetState createState() => _TorrentDetailSheetState();
}

class _TorrentDetailSheetState extends State<TorrentDetailSheet> {

  Torrent torrent;
  List<String> trackersList =[];
  List<String> filesList =[];

  _updateSheetData(String hashValue) async{

    var trKResponse = await http.post(Uri.parse(Provider.of<Api>(context,listen: false).httprpcPluginUrl),
        headers: {
          'authorization':Provider.of<Api>(context,listen: false).getBasicAuth(),
        },
        body: {
          'mode': 'trk',
          'hash': hashValue
        });

    var trackers = jsonDecode(trKResponse.body);
    for(var tracker in trackers){
      trackersList.add(tracker[0]);
    }

    var flsResponse = await http.post(Uri.parse(Provider.of<Api>(context,listen: false).httprpcPluginUrl),
        headers: {
          'authorization':Provider.of<Api>(context,listen: false).getBasicAuth(),
        },
        body: {
          'mode': 'fls',
          'hash': hashValue
        });

    var files = jsonDecode(flsResponse.body);
    for(var file in files){
      filesList.add(file[0]);
    }

    while(mounted){
      await Future.delayed(Duration(seconds: 1),(){
      });

      var response = await http.post(Uri.parse(Provider.of<Api>(context,listen: false).httprpcPluginUrl),
          headers: {
            'authorization':Provider.of<Api>(context,listen: false).getBasicAuth(),
          },
          body: {
            'mode': 'list',
          });

      var torrentObject = jsonDecode(response.body)['t'][hashValue];
      Torrent updatedTorrent = torrent;
      // updating the values which possibly change over time
      updatedTorrent.completedChunks = int.parse(torrentObject[6]);
      updatedTorrent.totalChunks = int.parse(torrentObject[7]);
      updatedTorrent.sizeOfChunk = int.parse(torrentObject[13]);
      updatedTorrent.seedsActual = int.parse(torrentObject[18]);
      updatedTorrent.peersActual = int.parse(torrentObject[15]);
      updatedTorrent.ulSpeed = int.parse(torrentObject[11]);
      updatedTorrent.dlSpeed = int.parse(torrentObject[12]);
      updatedTorrent.isOpen = int.parse(torrentObject[0]);
      updatedTorrent.getState = int.parse(torrentObject[3]);
      updatedTorrent.msg = torrentObject[29];
      updatedTorrent.downloadedData = int.parse(torrentObject[8]);
      updatedTorrent.uploadedData = int.parse(torrentObject[9]);
      updatedTorrent.ratio = int.parse(torrentObject[10]);

      updatedTorrent.eta = updatedTorrent.getEta;
      updatedTorrent.percentageDownload = updatedTorrent.getPercentageDownload;
      updatedTorrent.status = updatedTorrent.getTorrentStatus;

      if(mounted) {
        setState(() {
          torrent = updatedTorrent;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    torrent=widget.torrent;
    _updateSheetData(widget.torrent.hash);
  }

  Color _getStatusColor(){
    switch(torrent.status){
      case Status.downloading:
        return Constants.kBlue;
      case Status.paused:
        return Constants.kDarkGrey;
      case Status.errors:
        return Constants.kRed;
      case Status.completed:
        return Constants.kGreen;
      default:
        return Constants.kDarkGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = _getStatusColor();
    return SingleChildScrollView(
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black)
          ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(torrent.name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
              ),
              Text('${torrent.percentageDownload}%',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: statusColor),),
              Divider(
                thickness: 8,
                color: statusColor,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Size: ${filesize(torrent.size)}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600)),
                    Text('Added: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(torrent.torrentAdded*1000))}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('${filesize(torrent.downloadedData)}\nDownloaded',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600)),
                    Text('${filesize(torrent.uploadedData)}\nUploaded',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Save Path: ${torrent.savePath}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(torrent.dlSpeed>0?torrent.eta:'∞',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600)),
                              Text('ETA',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600)),
                              SizedBox(height: 10,),
                              Text('${torrent.seedsActual}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600)),
                              Text('Seeds',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600)),
                              SizedBox(height: 10,),
                              Text('${filesize(torrent.dlSpeed)}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600)),
                              Text('Downloading Speed',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text('${torrent.ratio/1000}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600)),
                              Text('Ratio',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600)),
                              SizedBox(height: 10,),
                              Text('${torrent.peersActual}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600)),
                              Text('Peers',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600)),
                              SizedBox(height: 10,),
                              Text('${filesize(torrent.ulSpeed)}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600)),
                              Text('Uploading Speed',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600)),
                            ],
                          )
                        ],
                      ),
                    ),
                ),
              ),
              ExpansionTile(
                title: Text('Files',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600)),
                children: filesList.map((e) => ListTile(title: Text(e,style: TextStyle(fontSize: 12),),)).toList(),
              ),
              ExpansionTile(
                title: Text('Trackers',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600)),
                children: trackersList.map((e) => ListTile(title: Text(e,style: TextStyle(fontSize: 12),))).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
