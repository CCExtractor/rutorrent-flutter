import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/components/torrent_details_sheet.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import '../api/api_conf.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rutorrentflutter/constants.dart' as Constants;

class TorrentTile extends StatelessWidget {
  final Torrent torrent;
  TorrentTile(this.torrent);

  Color _getStatusColor() {
    switch (torrent.status) {
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

  IconData _getTorrentIconData() {
    return torrent.isOpen == 0
        ? Icons.play_circle_filled
        : torrent.getState == 0
            ? (Icons.play_circle_filled)
            : Icons.pause_circle_filled;
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = _getStatusColor();
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
                color: Colors.red[800],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.remove_circle_outline,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                onTap: () => ApiRequests.removeTorrent(api, torrent.hash),
              )
            ],
            secondaryActions: <Widget>[
              SlideAction(
                color: Colors.grey[700],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: FaIcon(
                    FontAwesomeIcons.stop,
                    color: Colors.white,
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
                                        color:
                                        Provider.of<Mode>(context)
                                            .isLightMode
                                            ? Constants.kDarkGrey
                                            : Constants.kLightGrey),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            '↓ ${filesize(torrent.dlSpeed.toString()) + '/s'} | ↑ ${filesize(torrent.ulSpeed.toString()) + '/s'}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 10,
                                                color:
                                                    Provider.of<Mode>(context)
                                                            .isLightMode
                                                        ? Constants.kDarkGrey
                                                        : Constants.kLightGrey),
                                          ),
                                          Text(
                                            torrent.ratio == 0
                                                ? 'R: 0.000'
                                                : 'R: ${(torrent.ratio / 1000).toStringAsFixed(3)}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 10,
                                                color: Provider.of<Mode>(context)
                                                    .isLightMode
                                                    ? Constants.kDarkGrey
                                                    : Constants.kLightGrey),
                                          ),
                                        ],
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
                                              Constants.kLightGrey),
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
