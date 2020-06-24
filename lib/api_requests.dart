import 'dart:convert';
import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'api_conf.dart';
import 'models/torrent.dart';
import 'package:http/http.dart' as http;
import 'package:rutorrentflutter/constants.dart' as Constants;

class ApiRequests{

  static Stream<List<Torrent>> initTorrentsData(BuildContext context,Api api) async* {

    while(true) {
      await Future.delayed(Duration(seconds: 1),(){
      });
      List<Torrent> torrentsList = [];
      var response = await http.post(Uri.parse(api.httprpcPluginUrl),
          headers: {
            'authorization':api.getBasicAuth(),
          },
          body: {
            'mode': 'list',
          });

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
        torrent.isActive = int.parse(torrentObject[28]);
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


}