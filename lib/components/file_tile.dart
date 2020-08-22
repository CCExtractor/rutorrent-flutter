import 'dart:io';
import 'package:dio/dio.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:rutorrentflutter/utilities/constants.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/models/torrent_file.dart';

class FileTile extends StatefulWidget {
  final TorrentFile file;
  final Torrent torrent;
  final Function syncFilesCallback;
  final Function playMediaFileCallback;

  FileTile(this.file, this.torrent,this.syncFilesCallback,this.playMediaFileCallback);

  static String getFileExtension(String filename){
    return filename.substring(filename.lastIndexOf('.'), filename.length);
  }

  static bool isImage(String filename){
    String ext  = getFileExtension(filename);
    if(ext=='.jpg'||ext=='.jpeg'||ext=='png')
      return true;
    return false;
  }

  static bool isAudio(String filename){
    String ext  = getFileExtension(filename);
    if(ext=='.mp3'||ext=='.wav')
      return true;
    return false;
  }

  static bool isVideo(String filename){
    String ext  = getFileExtension(filename);
    if(ext=='.mp4' || ext=='.mkv')
      return true;
    return false;
  }

  static IconData getFileIcon(String filename) {
    if(isVideo(filename))
      return Icons.ondemand_video;

    if(isAudio(filename))
      return Icons.music_video;

    if(isImage(filename))
      return Icons.image;

    return Icons.insert_drive_file;
  }

  @override
  _FileTileState createState() => _FileTileState();
}

class _FileTileState extends State<FileTile> {
  int progress = 0; // percentage local download
  CancelToken cancelToken = CancelToken();
  bool isDownloading = false;

  downloadFile(Api api) async {
    String uri = Uri.parse(api.url).origin +
        widget.torrent.savePath +
        '/' +
        widget.file.name;

    Directory dir = await getExternalStorageDirectory();
    String savePath = '${dir.path}/${widget.torrent.name}/${widget.file.name}';

    Dio dio = Dio();
    dio.options.headers = api.getAuthHeader();

    setState(() {
      isDownloading = true;
    });

    dio.download(
      uri,
      savePath,
      onReceiveProgress: (rcv, total) {
        print('Received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');
        setState(() {
          progress = ((rcv * 100 ~/ total));
        });
      },
      cancelToken: cancelToken,
    ).then((_) {
      widget.syncFilesCallback();
      Fluttertoast.showToast(msg: 'Download Successful');
      setState(() {
        isDownloading = false;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if(widget.file.isPresentLocally)
          OpenFile.open(widget.file.localFilePath);
        else if(FileTile.isAudio(widget.file.name) || FileTile.isVideo(widget.file.name))
          widget.playMediaFileCallback(widget.file.name);
        else
          Fluttertoast.showToast(msg: 'File cannot be streamed');
      },
      leading: Icon(FileTile.getFileIcon(widget.file.name)),
      title: Text(
        widget.file.name,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: isDownloading
            ? LinearProgressIndicator(
                value: progress / 100,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Provider.of<Mode>(context).isDarkMode ? kIndigo : kBlue,
                ),
                backgroundColor: Provider.of<Mode>(context).isLightMode
                    ? kLightGrey
                    : kDarkGrey)
            : Text(
                filesize(widget.file.size),
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
      ),
      trailing: widget.file.isPresentLocally?
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.check_box)
          ):
      (isDownloading
          ? IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                if (isDownloading) {
                  cancelToken.cancel();
                  setState(() {
                    isDownloading = false;
                  });
                }
              },
            )
          : IconButton(
              onPressed: () {
                if (widget.file.isComplete())
                  downloadFile(widget.torrent.api);
                else
                  Fluttertoast.showToast(
                      msg: 'File is still downloading on the server');
              },
              icon: Icon(Icons.file_download),
            )),
    );
  }
}
