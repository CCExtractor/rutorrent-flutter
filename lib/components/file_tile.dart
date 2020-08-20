import 'dart:io';
import 'package:dio/dio.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final Function syncFiles;

  FileTile(this.file, this.torrent,this.syncFiles);

  static IconData getFileIcon(String filename) {
    String ext = filename.substring(filename.lastIndexOf('.'), filename.length);
    switch (ext) {
      case '.mp4':
        return Icons.ondemand_video;
      case '.mp3':
        return Icons.music_video;
      case '.jpg':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
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
      widget.syncFiles();
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
