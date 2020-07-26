import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/components/torrent_details_sheet.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import '../api/api_conf.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rutorrentflutter/constants.dart';

class TorrentTile extends StatelessWidget {
  final Torrent torrent;
  TorrentTile(this.torrent);

  static Color getStatusColor(Status status, BuildContext context) {
    switch (status) {
      case Status.downloading:
        return Provider.of<Mode>(context).isLightMode
            ? kBlue
            : kIndigo;
      case Status.paused:
        return Provider.of<Mode>(context).isLightMode
            ? kDarkGrey
            : kLightGrey;
      case Status.errors:
        return kRed;
      case Status.completed:
        return Provider.of<Mode>(context).isLightMode
            ? kGreen
            : kLightGreen;
      default:
        return kDarkGrey;
    }
  }

  IconData _getTorrentIconData() {
    return torrent.isOpen == 0
        ? Icons.play_circle_filled
        : torrent.getState == 0
            ? (Icons.play_circle_filled)
            : Icons.pause_circle_filled;
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = getStatusColor(torrent.status, context);
    return Consumer<Api>(
      builder: (context, api, child) {
        return GestureDetector(
          onTap: () {
            showMaterialModalBottomSheet(
                expand: true,
                context: context,
                builder: (context, scrollContainer) => Provider<Api>(
                    create: (context) => api,
                    child: TorrentDetailSheet(torrent)));
          },
          child: Slidable(
            actionPane: SlidableScrollActionPane(),
            actions: <Widget>[
              SlideAction(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                          color: Provider.of<Mode>(context).isLightMode
                              ? kDarkGrey
                              : kLightGrey,
                          width: 2)),
                  child: Icon(
                    Icons.clear,
                    color: Provider.of<Mode>(context).isLightMode
                        ? kDarkGrey
                        : kLightGrey,
                    size: 34,
                  ),
                ),
                onTap: () => ApiRequests.removeTorrent(api, torrent.hash),
              )
            ],
            secondaryActions: <Widget>[
              SlideAction(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                          color: Provider.of<Mode>(context).isLightMode
                              ? kDarkGrey
                              : kLightGrey,
                          width: 2)),
                  child: Icon(
                    Icons.stop,
                    color: Provider.of<Mode>(context).isLightMode
                        ? kDarkGrey
                        : kLightGrey,
                    size: 32,
                  ),
                ),
                onTap: () => ApiRequests.stopTorrent(api, torrent.hash),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                    child: Text(
                                  torrent.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                )),
                                Flexible(
                                  child: Text(
                                    '${filesize(torrent.downloadedData)}${torrent.dlSpeed == 0 ? '' : ' | ' + torrent.getEta}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                        color: Provider.of<Mode>(context)
                                                .isLightMode
                                            ? kDarkGrey
                                            : kLightGrey),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '↓ ${filesize(torrent.dlSpeed.toString()) + '/s'} | ↑ ${filesize(torrent.ulSpeed.toString()) + '/s'}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10,
                                            color: Provider.of<Mode>(context)
                                                    .isLightMode
                                                ? kDarkGrey
                                                : kLightGrey),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      LinearProgressIndicator(
                                          value:
                                              torrent.percentageDownload / 100,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  statusColor),
                                          backgroundColor:
                                              Provider.of<Mode>(context)
                                                      .isLightMode
                                                  ? kLightGrey
                                                  : kDarkGrey),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            torrent.percentageDownload.toString() + '%',
                            style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.w700),
                          ),
                          IconButton(
                            color: statusColor,
                            iconSize: 40,
                            icon: Icon(_getTorrentIconData()),
                            onPressed: () => ApiRequests.toggleTorrentStatus(
                                api,
                                torrent.hash,
                                torrent.isOpen,
                                torrent.getState),
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
      },
    );
  }
}
