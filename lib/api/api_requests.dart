import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'api_conf.dart';
import '../models/torrent.dart';

class ApiRequests{

  /// This class will be responsible for making all API Calls

  static Stream<List<Torrent>> initTorrentsData(BuildContext context,Api api,GeneralFeatures general) async* {
    while (true) {
      // Producing artificial delay of one second
      await Future.delayed(Duration(seconds: 1), () {});

        //Updating DiskSpace
        var diskSpaceResponse = await api.ioClient.get(
            Uri.parse(api.diskSpacePluginUrl),
            headers: api.getAuthHeader());
        var diskSpace = jsonDecode(diskSpaceResponse.body);

        general.updateDiskSpace(diskSpace['total'], diskSpace['free']);

        List<Torrent> torrentsList = [];
        try {
          //Fetching torrents Info
          var response = await api.ioClient.post(Uri.parse(api.httprpcPluginUrl),
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
    await api.ioClient.post(Uri.parse(api.httprpcPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'mode': 'stop',
          'hash': hashValue,
        });
  }

  static removeTorrent(Api api, String hashValue) async{
    Fluttertoast.showToast(msg: 'Removing Torrent');
    await api.ioClient.post(Uri.parse(api.httprpcPluginUrl),
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

    await api.ioClient.post(Uri.parse(api.httprpcPluginUrl),
        headers: api.getAuthHeader(),
        body: {
          'mode': statusMap[toggleStatus],
          'hash': hashValue,
        });
  }

  static addTorrentUrl(Api api,String url) async {
    await api.ioClient.post(Uri.parse(api.addTorrentUrl),
        headers: api.getAuthHeader(),
        body: {
          'url': url,
        });
  }

  static Future<List<String>> getTrackers(Api api, String hashValue) async{
    List<String> trackersList = [];

    var trKResponse = await api.ioClient.post(Uri.parse(api.httprpcPluginUrl),
        headers: api.getAuthHeader(),
        body: {'mode': 'trk', 'hash': hashValue});

    var trackers = jsonDecode(trKResponse.body);
    for (var tracker in trackers) {
      trackersList.add(tracker[0]);
    }
    return trackersList;
  }

  static Future<List<String>> getFiles(Api api, String hashValue) async{
    List<String> filesList = [];

    var flsResponse = await api.ioClient.post(Uri.parse(api.httprpcPluginUrl),
        headers: api.getAuthHeader(),
        body: {'mode': 'fls', 'hash': hashValue});

    var files = jsonDecode(flsResponse.body);
    for (var file in files) {
      filesList.add(file[0]);
    }
    return filesList;
  }

  static Stream<Torrent> updateSheetData(Api api, Torrent torrent) async* {
    try {
      while (true) {
        await Future.delayed(Duration(seconds: 1), () {});

        var response = await api.ioClient.post(Uri.parse(api.httprpcPluginUrl),
            headers: api.getAuthHeader(),
            body: {
              'mode': 'list',
            });

        var torrentObject = jsonDecode(response.body)['t'][torrent.hash];
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
        updatedTorrent.percentageDownload =
            updatedTorrent.getPercentageDownload;
        updatedTorrent.status = updatedTorrent.getTorrentStatus;

        yield updatedTorrent;
      }
    } catch (e) {
      print('Exception Caught in Torrent Details ' + e.toString());
      /* Exception may arise when you are constantly updating the torrent details and
      that torrent task might have been removed either from
      web interface or through any other device.*/
    }
  }
}