import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:rutorrentflutter/models/torrent_file.dart';
import 'package:rutorrentflutter/services/functional_services/api_service.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/torrent_label_dialog.dart';
import 'package:stacked/stacked.dart';

class TorrentDetailViewModel extends BaseViewModel {
  TorrentService _torrentService = locator<TorrentService>();
  ApiService _apiService = locator<ApiService>();

  Torrent _torrent = Torrent("Dummy");
  List<TorrentFile> _files = [];
  List<String> _trackers = [];
  final TextEditingController labelController = TextEditingController();
  late TextEditingController scrollController;
  final GlobalKey<FormState> formKey = GlobalKey();

  init(torrent, _scrollController) async {
    this.scrollController = _scrollController;
    setBusy(true);
    _torrent = torrent;
    _updateTorrent();
    await _getFiles();
    await _getTrackers();
    labelController.text = torrent.label;
    setBusy(false);
  }

  get torrent => _torrent;

  get getScrollController => scrollController;

  List<String> get trackers => _trackers;

  List<TorrentFile> get files => _files;

  get syncFiles => _syncFiles;

  IconData? getTorrentIconData(torrent) {}

  showLabelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TorrentLabelDialog(
        formKey: formKey,
        labelController: labelController,
        removeLabelFunc: _removeLabel,
        setLabelFunc: _setLabel,
        torrent: _torrent,
      ),
    );
  }

  void removeTorrentWithData() async {
    await _apiService.removeTorrentWithData(_torrent.hash ?? "");
  }

  void removeTorrent() async {
    await _apiService.removeTorrent(_torrent.hash ?? "");
  }

  toggleTorrentCurrentStatus() async {
    await _apiService.toggleTorrentStatus(torrent);
  }

  stopTorrent() async {
    await _apiService.stopTorrent(_torrent.hash ?? "");
  }

  _updateTorrent() {
    _torrent = _torrentService.torrentsList.value
        .firstWhere((torrent) => _torrent.hash == torrent.hash);
    notifyListeners();
  }

  _getFiles() async {
    _files = await _apiService.getFiles(torrent.hash);
  }

  _syncFiles() async {
    String localFilesPath =
        ((await getExternalStorageDirectory())?.path) ?? "" + '/';
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

  _removeLabel() async {
    await _apiService.removeTorrentLabel(hashValue: _torrent.hash!);
    _torrentService.changeFilter(Filter.All);
  }

  _setLabel(String label) async {
    await _apiService.setTorrentLabel(hashValue: _torrent.hash!, label: label);
    _torrentService.changeLabel(label);
  }
}
