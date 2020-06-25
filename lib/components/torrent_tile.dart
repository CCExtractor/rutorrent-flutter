import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/components/torrent_details_sheet.dart';
import 'package:rutorrentflutter/constants.dart' as Constants;
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:http/http.dart' as http;

import '../api/api_conf.dart';

class TorrentTile extends StatelessWidget {

  final Torrent torrent;
  TorrentTile(this.torrent);

  _stopTorrent(BuildContext context) async{
    await http.post(Uri.parse(Provider.of<Api>(context,listen: false).httprpcPluginUrl),
        headers: {
          'authorization':Provider.of<Api>(context,listen: false).getBasicAuth(),
        },
        body: {
          'mode': Constants.statusMap[Status.stopped],
          'hash': '${torrent.hash}',
        });
  }

  _removeTorrent(BuildContext context) async{
    Fluttertoast.showToast(msg: 'Removing Torrent');
    await http.post(Uri.parse(Provider.of<Api>(context,listen: false).httprpcPluginUrl),
        headers: {
          'authorization':Provider.of<Api>(context,listen: false).getBasicAuth(),
        },
        body: {
          'mode': 'remove',
          'hash': '${torrent.hash}',
        });
  }

  _toggleTorrentStatus(BuildContext context) async{
    Status toggleStatus = torrent.isOpen==0?
        Status.downloading:torrent.getState==0?(Status.downloading):Status.paused;

    await http.post(Uri.parse(Provider.of<Api>(context,listen: false).httprpcPluginUrl),
        headers: {
          'authorization':Provider.of<Api>(context,listen: false).getBasicAuth(),
        },
        body: {
          'mode': Constants.statusMap[toggleStatus],
          'hash': '${torrent.hash}',
        });
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

  IconData _getTorrentIconData(){
      return torrent.isOpen==0?Icons.play_circle_filled:torrent.getState==0?
          (Icons.play_circle_filled):Icons.pause_circle_filled;
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = _getStatusColor();
    return GestureDetector(
      onTap: (){
        showModalBottomSheet(
            context: context,
            builder: (BuildContext buildContext){
              return TorrentDetailSheet(torrent);
            },
        );
      },
      child: Slidable(
        actionPane: SlidableScrollActionPane(),
        actions: <Widget>[
          SlideAction(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.clear),
                Text('Remove'),
              ],
            ),
            onTap: ()=>_removeTorrent(context),
          ),
          SlideAction(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.stop),
                Flexible(child: Text('Stop')),
              ],
            ),
            onTap: ()=>_stopTorrent(context)
          )
        ],
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Container(
            width: double.infinity,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Row(
                    children: <Widget>[
                      VerticalDivider(
                        thickness: 5,
                        color: statusColor,
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(child: Text(torrent.name,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),)),
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(filesize(torrent.size),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,),),
                                  Text(torrent.ratio==0?'R: 0.000':'R: ${(torrent.ratio/1000).toString()}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,color: Colors.grey[700]),),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('${torrent.downloadedData}${torrent.dlSpeed==0?'':' | '+torrent.getEta}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 10,color: Colors.grey[800]),),
                                      Text('↓ ${filesize(torrent.dlSpeed.toString())+'/s'} | ↑ ${filesize(torrent.ulSpeed.toString())+'/s'}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 10,color: Colors.grey[700]),),
                                    ],
                                  ),
                                  SizedBox(height: 4,),
                                  LinearProgressIndicator(
                                    value: torrent.percentageDownload/100,
                                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                                    backgroundColor: Constants.kLightGrey
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(torrent.getPercentageDownload.toString()+'%',style: TextStyle(color: statusColor,fontWeight: FontWeight.w600),),
                      IconButton(
                        color: statusColor,
                        iconSize: 40,
                        icon: Icon(_getTorrentIconData()),
                        onPressed: (){
                          _toggleTorrentStatus(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
