import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:rutorrentflutter/models/torrent_file.dart';
import 'package:rutorrentflutter/services/functional_services/api_service.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';
import 'package:stacked/stacked.dart';

class TorrentDetailViewModel extends BaseViewModel {

  TorrentService _torrentService = locator<TorrentService>();
  ApiService _apiService = locator<ApiService>();

  Torrent _torrent = Torrent("Dummy");
  List<TorrentFile> _files = [];
  List<String> _trackers = [];
  final TextEditingController labelController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  init(torrent) async {
    setBusy(true);
    _torrent = torrent;
    _updateTorrent();
    await _getFiles();
    await _getTrackers();
    labelController.text = torrent.label;
    setBusy(false);
  }

  get torrent => _torrent;

  get scrollController => null;

  List<String> get trackers => _trackers;

  List<TorrentFile> get files => _files;

  syncFiles() {}

  IconData? getTorrentIconData(torrent) {}

  showLabelDialog(BuildContext context) {}

  void removeTorrentWithData() async {
    await _apiService.removeTorrentWithData(_torrent.hash??"");
  }

  void removeTorrent() async {
    await _apiService.removeTorrent(_torrent.hash??"");
  }

  toggleTorrentCurrentStatus() async {
    await _apiService.toggleTorrentStatus(torrent);
  }

  stopTorrent() async {
    await _apiService.stopTorrent(_torrent.hash ?? "");
  }

  _updateTorrent() {
    _torrent = _torrentService.torrentsList.value.firstWhere((torrent) => _torrent.hash==torrent.hash);
    notifyListeners();
  }

  _getFiles() async {
    _files = await _apiService.getFiles(torrent.hash);
  }

  _syncFiles() async {
    String localFilesPath = ((await getExternalStorageDirectory())?.path)??"" + '/';
    var localItems = Directory(localFilesPath).listSync(recursive: true);

    List<String> localFiles = [];
    for (dynamic localItem in localItems) {
      if (localItem is File) {
        localFiles.add(localItem.path);
      }
    }

    /// Checking whether a file is downloaded locally
    for (var file in files) {
      String folderPath = torrent.name + '/' + file.name;
      for (var localFile in localFiles) {
        if (localFile.endsWith(folderPath)) {
          file.isPresentLocally = true;
          file.localFilePath = localFilesPath + folderPath;
        }
      }
    }
  }

  _getTrackers() async {
    _trackers = await _apiService.getTrackers(torrent.hash);
  }

  String getFileUrl(String fileName) {
    // String fileUrl = torrentUrl + '/' + fileName;
    String fileUrl = '/' + fileName;
    fileUrl = Uri.encodeFull(fileUrl);
    return fileUrl;
  }
}