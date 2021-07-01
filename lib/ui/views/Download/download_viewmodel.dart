import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/services/state_services/file_service.dart';
import 'package:stacked/stacked.dart';

class DownloadViewModel extends FutureViewModel {
  FileService _fileService = locator<FileService>();

  List<FileSystemEntity> filesList = [];
  String? _homeDirectory;
  String? _directory;

  get homeDirectory => _homeDirectory;
  get directory => _directory;

  Future<bool> onBackPress() {
    return Future.value(true);
  }

  init() async {
    if (Platform.isAndroid) {
      _homeDirectory = (await getExternalStorageDirectory())!.path + '/';
    } else {
      _homeDirectory = (await getApplicationDocumentsDirectory()).path + '/';
    }
    _directory = _homeDirectory;
    _syncFiles();
  }

  _syncFiles() {
    filesList = Directory(_directory!).listSync();
    notifyListeners();
  }

  @override
  Future futureToRun() => init();

  openFile(int index) {
    if (filesList[index] is Directory) {
      _directory = filesList[index].path + '/';
      _syncFiles();
    } else if (filesList[index] is File) {
      OpenFile.open(filesList[index].path);
    }
  }

  getFileIcon(String path) {
    return _fileService.getFileIcon(path);
  }
}
