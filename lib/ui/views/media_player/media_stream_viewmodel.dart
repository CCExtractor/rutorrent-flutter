import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:rutorrentflutter/models/disk_file.dart';
import 'package:rutorrentflutter/services/api/i_api_service.dart';
import 'package:rutorrentflutter/services/state_services/file_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MediaStreamViewModel extends BaseViewModel {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  late final String _mediaUrl;
  late String _path;
  bool _isAndroid = false;
  // ignore: unused_field
  String _subtitleUrl = "";
  // ignore: unused_field
  bool _hasSubtitles = false;
  List<DiskFile> _diskFiles = [];
  IApiService _apiService = locator<IApiService>();
  FileService _fileService = locator<FileService>();
  NavigationService _navigationService = locator<NavigationService>();

  get chewieController => _chewieController;

  get videoPlayerController => _videoPlayerController;

  get isAndroid => _isAndroid;

  void init(String mediaUrl, String path) async {
    setBusy(true);
    _mediaUrl = mediaUrl;
    print("Media URL - " + mediaUrl);
    // Using WebView if platform is Android
    if (Platform.isAndroid) {
      _isAndroid = true;
      WebView.platform = SurfaceAndroidWebView();
      setBusy(false);
      return;
    }
    _path = path;
    _diskFiles = await _apiService.getDiskFiles(_path);
    // below is the subtitle url of the video which can be used in future updates for adding subtitles feature
    _subtitleUrl = getSubtitleUrl();
    try {
      await initializePlayer();
    } on PlatformException catch (err) {
      Fluttertoast.showToast(msg: "Unable to Stream File");
      _navigationService.popRepeated(1);
      print(err);
    }
    setBusy(false);
  }

  String getSubtitleUrl() {
    for (DiskFile file in _diskFiles) {
      if (_fileService.getFileExtension(file.name ?? "") == ".srt") {
        _hasSubtitles = true;
        return _getDiskFileUrl(file);
      }
    }
    return "";
  }

  @override
  void dispose() {
    try {
      _videoPlayerController.dispose();
      _chewieController?.dispose();
    } catch (e) {
      print("Error disposing controllers");
    }
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
