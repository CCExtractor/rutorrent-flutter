import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/constants.dart' as Constants;
import 'package:rutorrentflutter/models/torrent.dart';

class TorrentDetailSheet extends StatelessWidget {
  final Torrent torrent;
  TorrentDetailSheet(this.torrent);

  Color _getStatusColor(Status status) {
    switch (status) {
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
    return Consumer<Api>(builder: (context, api, child) {
      return SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32,horizontal: 16),
                  child: Text(torrent.name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                StreamBuilder(
                    initialData: torrent,
                    stream: ApiRequests.updateSheetData(api, torrent),
                    builder: (context, snapshot) {
                      Torrent updatedTorrent = snapshot.data ?? torrent;
                      return Column(
                        children: <Widget>[
                          Text(
                            '${updatedTorrent.percentageDownload}%',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _getStatusColor(updatedTorrent.status)),
                          ),
                          Divider(
                            thickness: 8,
                            color: _getStatusColor(updatedTorrent.status),
                          ),
                        ],
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Size: ${filesize(torrent.size)}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      Text(
                          'Added: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(torrent.torrentAdded * 1000))}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('${filesize(torrent.downloadedData)}\nDownloaded',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                      Text('${filesize(torrent.uploadedData)}\nUploaded',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Save Path: ${torrent.savePath}',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
                StreamBuilder(
                  initialData: torrent,
                  stream: ApiRequests.updateSheetData(api, torrent),
                  builder: (context, snapshot) {
                    Torrent updatedTorrent = snapshot.data ?? torrent;
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.grey)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                    height: 10,
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
                                    height: 10,
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
                                    height: 10,
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
                                    height: 10,
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
                FutureBuilder(
                    future: ApiRequests.getFiles(api, torrent.hash),
                    builder: (context, snapshot) {
                      List<String> list = snapshot.data ?? [];
                      return ExpansionTile(
                        title: Text('Files',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        children: list
                            .map((e) => ListTile(
                                    title: Text(
                                  e,
                                  style: TextStyle(fontSize: 12),
                                )))
                            .toList(),
                      );
                    }),
                FutureBuilder(
                  future: ApiRequests.getTrackers(api, torrent.hash),
                  builder: (context, snapshot) {
                    List<String> list = snapshot.data ?? [];
                    return ExpansionTile(
                      title: Text(
                        'Trackers',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      children: list
                          .map((e) => ListTile(
                                  title: Text(
                                e,
                                style: TextStyle(fontSize: 12),
                              )))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
