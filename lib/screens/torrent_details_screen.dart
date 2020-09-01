import 'dart:async';
import "dart:ui";
import 'dart:io';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/components/file_tile.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/torrent_file.dart';
import 'package:rutorrentflutter/models/torrent.dart';

class TorrentDetailSheet extends StatefulWidget {
  final Torrent torrent;
  TorrentDetailSheet(this.torrent);

  @override
  _TorrentDetailSheetState createState() => _TorrentDetailSheetState();
}

class _TorrentDetailSheetState extends State<TorrentDetailSheet> {
  /// Torrent Download fields

  // torrent containing fields related to it
  Torrent torrent;

  // stores list of torrent files
  List<TorrentFile> files = [];

  // stores list of trackers
  List<String> trackers = [];

  // stores imageUrl (if present in files for downloading torrent) for background Image
  String displayImageUrl;

  // scroll controller for screen
  final ScrollController _scrollController = ScrollController();

  /// Media Player fields

  // when true shows [Media Player Stack]
  bool showMediaPlayer = false;

  // state of media player while playing
  bool isPlaying = false;

  // true if playing media is Audio
  bool isPlayingAudio = false;

  // playing media name
  String playingMediaName;

  // url of streaming video
  String mediaUrl;

  // controller of vlc player
  VlcPlayerController _videoViewController;

  // slider value for media player seek slider
  double sliderValue = 0.0;

  // hide control buttons {play/pause and seek slider} while playing media
  bool showControls = true;

  // for catching bad url which cannot be streamed
  bool checkForError = true;
  int stopCounter = 0;

  /// Initialise Vlc Media Player
  _initVlcPlayer() async {
    _videoViewController = new VlcPlayerController(onInit: () {
      _videoViewController.play();
    });
    _videoViewController.addListener(() {
      setState(() {});
    });

    while (this.mounted) {
      PlayingState state = _videoViewController.playingState;

      if (state == PlayingState.PLAYING &&
          sliderValue < _videoViewController.duration.inSeconds) {
        checkForError = false;
        sliderValue = _videoViewController.position.inSeconds.toDouble();
      } else if (state == PlayingState.ERROR ||
          (checkForError && stopCounter > 3)) {
        Fluttertoast.showToast(msg: 'Error in playing the media file',
            gravity: ToastGravity.CENTER);
        showMediaPlayer = false;
        checkForError = false;
      } else if (state == PlayingState.STOPPED) {
        stopCounter++;
      }
      setState(() {});
      await Future.delayed(Duration(seconds: 1), () {});
    }
  }

  playOrPauseVideo() {
    PlayingState state = _videoViewController.playingState;

    if (state == PlayingState.PLAYING) {
      _videoViewController.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      _videoViewController.play();
      setState(() {
        isPlaying = true;
      });
    }
  }

  IconData _getTorrentIconData(Torrent torrent) {
    return torrent.isOpen == 0
        ? Icons.play_arrow
        : torrent.getState == 0 ? (Icons.play_arrow) : Icons.pause;
  }

  /// Updates torrent in real time
  _updateTorrent() async {
    while (this.mounted) {
      List<Torrent> torrentsList =
          Provider.of<GeneralFeatures>(context, listen: false).torrentsList;

      Torrent updatedTorrent;
      for (var torrent in torrentsList) {
        if (torrent.hash == widget.torrent.hash) {
          updatedTorrent = torrent;
          break;
        }
      }

      setState(() => torrent = updatedTorrent);
      await Future.delayed(Duration(seconds: 1), () {});
    }
  }

  /// Syncs torrent files with locally downloaded files
  syncFiles() async {
    String localFilesPath = (await getExternalStorageDirectory()).path + '/';
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

    setState(() {});
  }

  /// Gets files for this torrent and syncs it with locally downloaded files
  _getFiles() async {
    files = await ApiRequests.getFiles(torrent.api, torrent.hash);
    syncFiles();
    setState(() {});
    checkDisplayImage();
  }

  /// Gets trackers for this torrent
  _getTrackers() async {
    trackers = await ApiRequests.getTrackers(torrent.api, torrent.hash);
    setState(() {});
  }

  /// Checks for image in files to display it as a background image
  checkDisplayImage() {
    for (TorrentFile file in files) {
      if (FileTile.isImage(file.name) && file.isComplete()) {
        setState(() {
          displayImageUrl = getFileUrl(file.name);
        });
        break;
      }
    }
  }

  String getFileUrl(String fileName) {
    Uri uri = Uri.parse(torrent.api.url);
    String url = uri.scheme +
        '://' +
        torrent.api.username +
        ':' +
        torrent.api.password +
        '@' +
        uri.host +
        torrent.savePath +
        '/' +
        fileName;

    print(torrent.savePath);

    url = Uri.encodeFull(url);
    return url;
  }

  playMediaFile(String fileName) {
    String url = getFileUrl(fileName);

    checkForError = true;

    stopCounter = 0;

    playingMediaName = fileName;

    if (FileTile.isAudio(fileName)) {
      isPlayingAudio = true;
    }

    if (!showMediaPlayer) {
      //Media Player is inactive that is nothing is streaming
      mediaUrl = url;
      showMediaPlayer = true;
      isPlaying = true;
    } else {
      //Media Player is playing a file so we have to change the url via controller
      _videoViewController.setStreamUrl(url);
      isPlaying = true;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    torrent = widget.torrent;
    _initVlcPlayer();
    _updateTorrent();
    _getFiles();
    _getTrackers();
  }

  Future<bool> _onBackPress() async{
    setState(() {
      showMediaPlayer=false;
    });
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var s = window.physicalSize/window.devicePixelRatio;
    bool landscape = s.width>s.height;
    if (landscape) {
      SystemChrome.setEnabledSystemUIOverlays([]);
    }else{
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    }
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 430,
                  color: Colors.black,
                  child: !showMediaPlayer
                      ?
                      /// Torrent Downloading Stack
                      Stack(
                          children: <Widget>[
                            Image(
                              width: double.infinity,
                              height: 500,
                              image: displayImageUrl != null
                                  ? NetworkImage(displayImageUrl)
                                  : AssetImage('assets/logo/sample.png'),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: Icon(Icons.keyboard_backspace,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 100,
                                  ),
                                  Text(torrent.name,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                            torrent.percentageDownload < 100
                                                ? '${filesize(torrent.size - torrent.downloadedData)} left of ${filesize(torrent.size)}'
                                                : 'Size: ${filesize(torrent.size)}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            )),
                                        Text('${torrent.percentageDownload}%',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: IconButton(
                                            color: Colors.black,
                                            iconSize: 20,
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              ApiRequests.removeTorrent(
                                                  torrent.api, torrent.hash);
                                              Navigator.pop(context);
                                            }),
                                      ),
                                      SizedBox(
                                        width: 35,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: IconButton(
                                          color: Colors.black,
                                          iconSize: 40,
                                          icon: Icon(_getTorrentIconData(torrent)),
                                          onPressed: () =>
                                              ApiRequests.toggleTorrentStatus(
                                                  torrent.api,
                                                  torrent.hash,
                                                  torrent.isOpen,
                                                  torrent.getState),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 35,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: IconButton(
                                            color: Colors.black,
                                            iconSize: 25,
                                            icon: Icon(Icons.stop),
                                            onPressed: () =>
                                                ApiRequests.stopTorrent(
                                                    torrent.api, torrent.hash)),
                                      ),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 16),
                                    child: LinearProgressIndicator(
                                      value: torrent.percentageDownload / 100,
                                      backgroundColor: Colors.grey,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      :
                      /// Vlc Media Player Stack
                      Stack(
                          children: <Widget>[
                            Image(
                              width: double.infinity,
                              height: 500,
                              image: displayImageUrl != null
                                  ? NetworkImage(displayImageUrl)
                                  : AssetImage('assets/logo/sample.png'),
                            ),
                            SizedBox(
                              height: isPlayingAudio
                                  ? 1
                                  : 430, //shrinks the player so that display image is visible
                              child: VlcPlayer(
                                aspectRatio: 16 / 9,
                                url: mediaUrl,
                                controller: _videoViewController,
                                placeholder: Container(
                                  height: 250.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).accentColor),
                                  ),
                                ),
                              ),
                            ),
                            showControls
                                ? Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: IconButton(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 8),
                                          icon: Icon(
                                            Icons.clear,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              showMediaPlayer = false;
                                            });
                                          },
                                        ),
                                      ),
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          setState(() {
                                            showControls = !showControls;
                                          });
                                        },
                                        child: SizedBox(
                                          height: 180,
                                          width: double.infinity,
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(playingMediaName,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: IconButton(
                                            color: Colors.black,
                                            iconSize: 40,
                                            icon: Icon(isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow),
                                            onPressed: () => playOrPauseVideo()),
                                      ),
                                      Slider(
                                        inactiveColor: Colors.grey,
                                        activeColor: Colors.white,
                                        value: sliderValue,
                                        min: 0.0,
                                        max: _videoViewController.duration == null
                                            ? 1.0
                                            : _videoViewController
                                                .duration.inSeconds
                                                .toDouble(),
                                        onChanged: (progress) {
                                          setState(() {
                                            sliderValue =
                                                progress.floor().toDouble();
                                          });
                                          //convert to Milliseconds since VLC requires MS to set time
                                          _videoViewController.setTime(
                                              sliderValue.toInt() * 1000);
                                        },
                                      ),
                                    ],
                                  )
                                : GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      setState(() {
                                        showControls = !showControls;
                                      });
                                    },
                                    child: SizedBox(
                                      height: 400,
                                      width: double.infinity,
                                    )),
                          ],
                        ),
                ),
                ExpansionTile(
                  initiallyExpanded: torrent.status==Status.downloading,
                  title: Text('More Info',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Column(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Seed',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              )),
                          Container(
                            height: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: Colors.grey)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'ETA : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          torrent.dlSpeed > 0 ? torrent.eta : '∞',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Seeds : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '${torrent.seedsActual}',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Ratio : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '${torrent.ratio / 1000}',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Peer : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '${torrent.peersActual}',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Data',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              )),
                          Container(
                            height: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: Colors.grey)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Downloaded : ',
                                      style:
                                          TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${filesize(torrent.downloadedData)}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('Uploaded : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                      '${filesize(torrent.uploadedData)}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Speed',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              )),
                          Container(
                            height: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: Colors.grey)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Download : ',
                                      style:
                                          TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${filesize(torrent.dlSpeed)}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('Upload : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                      '${filesize(torrent.ulSpeed)}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text('Files',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  children: <Widget>[
                    ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          return FileTile(
                              files[index], torrent, syncFiles, playMediaFile);
                        })
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    'Trackers',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  children: <Widget>[
                    ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: trackers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            dense: true,
                            title: Text(
                              trackers[index],
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ));
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }
}
