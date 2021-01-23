import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/screens/torrent_details_screen.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import '../api/api_conf.dart';
import 'package:rutorrentflutter/utilities/constants.dart';

class TorrentTile extends StatelessWidget {
  final Torrent torrent;
  TorrentTile(this.torrent);

  static getStatusColor(Status status, BuildContext context) {
    switch (status) {
      case Status.downloading:
        return Theme.of(context).primaryColor;
      case Status.paused:
        return Provider.of<Mode>(context).isLightMode ? kGreyDT : kGreyLT;
      case Status.stopped:
        return Provider.of<Mode>(context).isLightMode ? kGreyDT : kGreyLT;
      case Status.completed:
        return Provider.of<Mode>(context).isLightMode
            ? kGreenActiveLT
            : kGreenActiveDT;
      case Status.errors:
        return Provider.of<Mode>(context).isLightMode
            ? kGreenActiveLT
            : kRedErrorDT;
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
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TorrentDetailSheet(torrent)));
          },
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
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              )),
                              Flexible(
                                child: Text(
                                  '${filesize(torrent.downloadedData)}${torrent.dlSpeed == 0 ? '' : ' | ' + torrent.getEta}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          '↓ ${filesize(torrent.dlSpeed.toString()) + '/s'} | ↑ ${filesize(torrent.ulSpeed.toString()) + '/s'}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Provider.of<GeneralFeatures>(context)
                                                .allAccounts
                                            ? Text(
                                                '${Uri.parse(torrent.api.url).host}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    LinearProgressIndicator(
                                      backgroundColor:
                                          Provider.of<Mode>(context).isLightMode
                                              ? kGreyLT
                                              : kGreyDT,
                                      value: torrent.percentageDownload / 100,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          statusColor),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          torrent.percentageDownload.toString() + '%',
                          style: TextStyle(
                              color: statusColor, fontWeight: FontWeight.w700),
                        ),
                        IconButton(
                          color: statusColor,
                          iconSize: 40,
                          icon: Icon(_getTorrentIconData()),
                          onPressed: () => ApiRequests.toggleTorrentStatus(
                              torrent.api,
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
        );
      },
    );
  }
}
