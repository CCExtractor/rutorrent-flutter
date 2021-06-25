import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rutorrentflutter/ui/shared/shared_styles.dart';
import 'package:rutorrentflutter/ui/views/Video%20Stream/video_stream_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:wakelock/wakelock.dart';

class VideoStreamView extends StatefulWidget {
  final String mediaUrl;
  final String mediaName;
  VideoStreamView({required this.mediaName,required this.mediaUrl});

  @override
  _VideoStreamViewState createState() => _VideoStreamViewState();
}

class _VideoStreamViewState extends State<VideoStreamView>  with WidgetsBindingObserver {

  // state of media player while playing
  bool isPlaying = true;
  bool isPausedDueToLifecycle = false;
  // controller of vlc player
  late VlcPlayerController _videoViewController;
  // slider value for media player seek slider
  double sliderValue = 0.0;
  // hide control buttons {play/pause and seek slider} while playing media
  bool showControls = true;

 @override
 Widget build(BuildContext context) {
   return ViewModelBuilder<VideoStreamViewModel>.reactive(
     builder: (context, model, child) => Scaffold(
      backgroundColor: kBackgroundDT,
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: VlcPlayer(
              aspectRatio: 16 / 9,
              controller: _videoViewController,
              placeholder: Center(
                child: Container(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).accentColor),
                  ),
                ),
              ),
            ),
          ),
          showControls
              ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() => showControls = !showControls);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
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
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.mediaName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: IconButton(
                              color: Colors.black,
                              iconSize: 40,
                              icon: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow),
                              onPressed: () => playOrPauseVideo(),
                            ),
                          ),
                          Slider(
                            inactiveColor: Colors.grey,
                            activeColor: Colors.white,
                            value: sliderValue,
                            min: 0.0,
                            max:_videoViewController.value.duration.inSeconds
                                    .toDouble(),
                            onChanged: (progress) {
                              if (this.mounted) {
                                setState(() {
                                  sliderValue = progress.floor().toDouble();
                                });
                              }
                              //convert to Milliseconds since VLC requires MS to set time
                              _videoViewController
                                  .setTime(sliderValue.toInt() * 1000);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() => showControls = !showControls);
                  },
                  child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ))
        ],
      ),
    ),
     viewModelBuilder: () => VideoStreamViewModel(),
   );
 }

 @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      //The app is either in bg or the phone has been turned off
      PlayingState state = _videoViewController.value.playingState;
      if (state == PlayingState.playing) {
        //Check if the video is playing and only then execute pause operation
        _videoViewController.pause();
        setState(() {
          //Keeping track if the video is paused due to lifecycle change
          isPausedDueToLifecycle = true;
          isPlaying = false;
        });
      }
    }
    //Only is the video was paused due to lifecycle changes
    if (state == AppLifecycleState.resumed && isPausedDueToLifecycle) {
      //The app is bought back into the view or the display is turned back on
      _videoViewController.play();
      setState(() {
        isPlaying = true;
      });
    }
    super.didChangeAppLifecycleState(state);
  }

   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _initVlcPlayer();
    SystemChrome.setEnabledSystemUIOverlays([]);
    Wakelock.enable();
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance?.removeObserver(this);
    Wakelock.disable();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    await _videoViewController.stop();
    await _videoViewController.stopRendererScanning();
    await _videoViewController.dispose();
    super.dispose();
  }

  _initVlcPlayer() async {
    _videoViewController = VlcPlayerController.network(widget.mediaUrl,
        hwAcc: HwAcc.FULL, autoPlay: false, options: VlcPlayerOptions());
    _videoViewController.addOnInitListener(() {
      _videoViewController.play();
    });
    _videoViewController.addListener(() {
      setState(() {});
    });

    int stopCounter = 0;
    bool checkForError = true;

    while (this.mounted) {
      PlayingState state = _videoViewController.value.playingState;
      if (state == PlayingState.playing &&
          sliderValue < _videoViewController.value.duration.inSeconds) {
        checkForError = false;
        sliderValue = _videoViewController.value.position.inSeconds.toDouble();
      } else if (state == PlayingState.stopped) {
        stopCounter++;
        if (checkForError && stopCounter > 2) {
          Fluttertoast.showToast(msg: 'Error in playing file');
          Navigator.pop(context);
        }
      }
      setState(() {});
      await Future.delayed(Duration(seconds: 1), () {});
    }
  }

  playOrPauseVideo() {
    PlayingState state = _videoViewController.value.playingState;

    if (state == PlayingState.playing) {
      _videoViewController.pause();
      setState(() {
        isPausedDueToLifecycle = false;
        isPlaying = false;
      });
    } else {
      _videoViewController.play();
      setState(() {
        isPlaying = true;
      });
    }
  }
}