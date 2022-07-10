// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:rutorrentflutter/theme/app_state_notifier.dart';
import 'package:rutorrentflutter/ui/shared/shared_styles.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/remove_torrent_dialog_widget.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/torrent_tile/torrent_tile_viewmodel.dart';
import 'package:stacked/stacked.dart';

class TorrentTileView extends StatelessWidget {
  final Torrent torrent;
  TorrentTileView(this.torrent);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TorrentTileViewModel>.reactive(
      onModelReady: (model) => model.init(torrent, context),
      builder: (context, model, child) => GestureDetector(
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) => RemoveTorrentDialog(
                    callBackRight: model.removeTorrentWithData,
                    callBackLeft: model.removeTorrent,
                    torrent: torrent,
                  ));
        },
        behavior: HitTestBehavior.opaque,
        onTap: () {
          model.navigateToTorrentDetail(torrent);
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
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                            ),
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
                                      model.showAllAccounts
                                          ? Text(
                                              '${Uri.parse(torrent.account.url!).host}',
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
                                        !AppStateNotifier.isDarkModeOn
                                            ? kGreyLT
                                            : kGreyDT,
                                    value: torrent.percentageDownload / 100,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        _getStatusColor(
                                            torrent.status, context)),
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
                            color: _getStatusColor(torrent.status, context),
                            fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        color: _getStatusColor(torrent.status, context),
                        iconSize: 40,
                        icon: Icon(_getTorrentIconData()),
                        onPressed: () => model.toggleTorrentStatus(torrent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => TorrentTileViewModel(),
    );
  }

  IconData _getTorrentIconData() {
    return torrent.isOpen == 0
        ? Icons.play_circle_filled
        : torrent.getState == 0
            ? (Icons.play_circle_filled)
            : Icons.pause_circle_filled;
  }

  _getStatusColor(Status? status, BuildContext context) {
    switch (status) {
      case Status.downloading:
        return Theme.of(context).primaryColor;
      case Status.paused:
        return !AppStateNotifier.isDarkModeOn ? kGreyDT : kGreyLT;
      case Status.stopped:
        return !AppStateNotifier.isDarkModeOn ? kGreyDT : kGreyLT;
      case Status.completed:
        return !AppStateNotifier.isDarkModeOn ? kGreenActiveLT : kGreenActiveDT;
      case Status.errors:
        return !AppStateNotifier.isDarkModeOn ? kGreenActiveLT : kRedErrorDT;
      default:
        break;
    }
  }
}
