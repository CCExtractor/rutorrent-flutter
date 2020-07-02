import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/io_client.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'api_conf.dart';
import '../models/torrent.dart';


class ApiRequests{

  static Stream<List<Torrent>> initTorrentsData(BuildContext context,Api api,GeneralFeatures generalFeatures) async* {
    while (true) {
      HttpClient httpClient = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = new IOClient(httpClient);
      // Producing artificial delay of one second
      await Future.delayed(Duration(seconds: 1), () {});

        //Updating DiskSpace
        var diskSpaceResponse = await ioClient.get(
            Uri.parse(api.diskSpacePluginUrl),
            headers: api.getAuthHeader());
        var diskSpace = jsonDecode(diskSpaceResponse.body);

        generalFeatures.updateDiskSpace(diskSpace['total'], diskSpace['free']);

        List<Torrent> torrentsList = [];
        try {
          //Fetching torrents Info
          var response = await ioClient.post(Uri.parse(api.httprpcPluginUrl),
              headers: api.getAuthHeader(),
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
            torrent.completedChunks = int.parse(torrentObject[6]);
            torrent.totalChunks = int.parse(torrentObject[7]);
            torrent.sizeOfChunk = int.parse(torrentObject[13]);
            torrent.torrentAdded = int.parse(torrentObject[21]);
            torrent.torrentCreated = int.parse(torrentObject[26]);
            torrent.seedsActual = int.parse(torrentObject[18]);
            torrent.peersActual = int.parse(torrentObject[15]);
            torrent.ulSpeed = int.parse(torrentObject[11]);
            torrent.dlSpeed = int.parse(torrentObject[12]);
            torrent.isOpen = int.parse(torrentObject[0]);
            torrent.getState = int.parse(torrentObject[3]);
            torrent.msg = torrentObject[29];
            torrent.downloadedData = int.parse(torrentObject[8]);
            torrent.uploadedData = int.parse(torrentObject[9]);
            torrent.ratio = int.parse(torrentObject[10]);

            torrent.eta = torrent.getEta;
            torrent.percentageDownload = torrent.getPercentageDownload;
            torrent.status = torrent.getTorrentStatus;
            torrentsList.add(torrent);
          }
          yield torrentsList;
        }
        catch(e){
          print('Exception caught in Api Request ' + e.toString());
          /*returning null since the stream has to be active all times to return something
          this usually occurs when there is no torrent task available or when the connect
          to rTorrent is not established.*/
          yield null;
        }
    }
  }

  static stopTorrent(Api api, String hashValue) async{
    HttpClient httpClient = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(httpClient);
    await ioClient.post(Uri.parse(api.httprpcPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'mode': 'stop',
          'hash': hashValue,
        });
  }

  static removeTorrent(Api api, String hashValue) async{
    Fluttertoast.showToast(msg: 'Removing Torrent');
    HttpClient httpClient = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(httpClient);
    await ioClient.post(Uri.parse(api.httprpcPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'mode': 'remove',
          'hash': hashValue,
        });
  }

  static toggleTorrentStatus(Api api, String hashValue, int isOpen, int getState) async{

    const Map<Status,String> statusMap = {
      Status.downloading : 'start',
      Status.paused : 'pause',
      Status.stopped: 'stop',
    };

    Status toggleStatus = isOpen==0?
    Status.downloading:getState==0?(Status.downloading):Status.paused;

    HttpClient httpClient = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(httpClient);
    await ioClient.post(Uri.parse(api.httprpcPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'mode': statusMap[toggleStatus],
          'hash': hashValue,
        });
  }
}