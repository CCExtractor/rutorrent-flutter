import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/components/torrent_details_sheet.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import '../api/api_conf.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rutorrentflutter/constants.dart' as Constants;

class TorrentTile extends StatelessWidget {

  final Torrent torrent;
  TorrentTile(this.torrent);

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
    return Consumer<Api>(
      builder: (context,api,child) {
        return GestureDetector(
          onTap: () {
            showMaterialModalBottomSheet(
                expand: true,
                context: context,
                builder: (context,scrollContainer) =>
                    Provider<Api>(
                    create: (context) =>api,
                    child: TorrentDetailSheet(torrent)
                )
            );
          },
          child: Slidable(
            actionPane: SlidableScrollActionPane(),
            actions: <Widget>[
              SlideAction(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  color:  Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Icons.clear,color: Constants.kRed,),
                    )),
                onTap: () => ApiRequests.removeTorrent(api,torrent.hash),
              )],
            secondaryActions: <Widget>[
              SlideAction(
                child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    color:  Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Icons.stop,color: Constants.kDarkGrey,),
                    )),
                  onTap: () => ApiRequests.stopTorrent(api,torrent.hash)
              )],
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 12),
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
                            SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(child: Text(torrent.name,
                                    style: TextStyle(fontWeight: FontWeight.w600,
                                        fontSize: 16),)),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: <Widget>[
                                            Text('${filesize(
                                                torrent.downloadedData)}${torrent
                                                .dlSpeed == 0 ? '' : ' | ' +
                                                torrent.getEta}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                  color: Colors.grey[800]),),
                                            Text('↓ ${filesize(
                                                torrent.dlSpeed.toString()) +
                                                '/s'} | ↑ ${filesize(
                                                torrent.ulSpeed.toString()) +
                                                '/s'}', style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 10,
                                                color: Colors.grey[700]),),
                                          ],
                                        ),
                                        SizedBox(height: 4,),
                                        LinearProgressIndicator(
                                            value: torrent.percentageDownload /
                                                100,
                                            valueColor: AlwaysStoppedAnimation<
                                                Color>(statusColor),
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
                            Text(torrent.getPercentageDownload.toString() + '%',
                              style: TextStyle(color: statusColor,
                                  fontWeight: FontWeight.w600),),
                            IconButton(
                              color: statusColor,
                              iconSize: 40,
                              icon: Icon(_getTorrentIconData()),
                              onPressed: ()=>
                                  ApiRequests.toggleTorrentStatus(api,torrent.hash,torrent.isOpen,torrent.getState),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
