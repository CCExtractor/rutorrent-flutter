import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:rutorrentflutter/models/disk_file.dart';
import 'package:rutorrentflutter/services/api/i_api_service.dart';
import 'package:rutorrentflutter/services/state_services/file_service.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MediaStreamViewModel extends BaseViewModel {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  late final String _mediaUrl;
  late String _path;
  // ignore: unused_field
  String _subtitleUrl = "";
  List<DiskFile> _diskFiles = [];
  IApiService _apiService = locator<IApiService>();
  FileService _fileService = locator<FileService>();
  bool _isAndroid = false;

  get chewieController => _chewieController;

  get videoPlayerController => _videoPlayerController;

  get isAndroid => _isAndroid;

  void init(String mediaUrl, String path) async {
    setBusy(true);
    _mediaUrl = mediaUrl;
    // Check if platform is Android
    if (Platform.isAndroid) {
      _isAndroid = true;
      WebView.platform = SurfaceAndroidWebView();
      setBusy(false);
      return;
    }
    _path = path;
    _diskFiles = await _apiService.getDiskFiles(_path);
    // below is the subtitle url of the video which can be used in future updates for adding subtitles feature
    _subtitleUrl = _getDiskFileUrl(
      _diskFiles.firstWhere(
        (file) => _fileService.getFileExtension(file.name ?? "") == ".srt",
      ),
    );
    await initializePlayer();
    setBusy(false);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(_mediaUrl);
    await Future.wait([
      _videoPlayerController.initialize(),
    ]);
    _createChewieController();
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,

      // Some of the other options in this player:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  String _getDiskFileUrl(DiskFile diskFile) {
    Account account = _apiService.account ?? Account();
    Uri uri = Uri.parse(account.url!);
    String fileUrl = uri.scheme +
        '://' +
        (account.username)! +
        ':' +
        (account.password)! +
        '@' +
        uri.authority +
        '/downloads' +
        _path +
        (diskFile.name)!;
    fileUrl = Uri.encodeFull(fileUrl);
    return fileUrl;
  }
}
