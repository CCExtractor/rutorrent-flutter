import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/components/file_tile.dart';
import 'package:rutorrentflutter/models/disk_file.dart';
import 'package:rutorrentflutter/screens/vlc_stream.dart';

class DiskFileTile extends StatefulWidget {
  final DiskFile diskFile;

  final String path;

  final Function goBackwards;

  final Function goForwards;

  DiskFileTile(this.diskFile, this.path, this.goBackwards, this.goForwards);

  @override
  _DiskFileTileState createState() => _DiskFileTileState();
}

class _DiskFileTileState extends State<DiskFileTile> {
  int progress = 0; // percentage local download
  CancelToken cancelToken = CancelToken();
  bool isDownloading = false;

  getDiskFileUrl(String filename) {
    Api api = Provider.of<Api>(context, listen: false);
    Uri uri = Uri.parse(api.url);
    String fileUrl = uri.scheme +
        '://' +
        api.username +
        ':' +
        api.password +
        '@' +
        uri.authority +
        '/downloads' +
        widget.path +
        filename;
    fileUrl = Uri.encodeFull(fileUrl);
    return fileUrl;
  }

  _streamFile(String filename) {
    String fileUrl = getDiskFileUrl(filename);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VlcStream(fileUrl, filename),
        ));
  }

  downloadFile(Api api, String fileUrl) async {
    // finding torrent or folder name
    String path = widget.path.substring(0, widget.path.length - 1);
    path = path.substring(path.lastIndexOf('/'));

    // finding directory in local to save the file
    Directory dir = await getExternalStorageDirectory();
    String savePath = '${dir.path}/$path/${widget.diskFile.name}';

    Dio dio = Dio();

    setState(() {
      isDownloading = true;
    });

    dio.download(
      fileUrl,
      savePath,
      onReceiveProgress: (rcv, total) {
        print(
            'Received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');
        setState(() {
          progress = ((rcv * 100 ~/ total));
        });
      },
      cancelToken: cancelToken,
    ).then((_) {
      setState(() {});
      Fluttertoast.showToast(msg: 'Download Successful');
      setState(() {
        isDownloading = false;
      });
    }).catchError((e) {
      print(e);
      Fluttertoast.showToast(msg: 'Error in downloading file');
      setState(() {
        isDownloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: () {
        if (widget.diskFile.isDirectory) {
          widget.diskFile.name == '..'
              ? widget.goBackwards()
              : widget.goForwards(widget.diskFile.name);
        } else {
          if (FileTile.isAudio(widget.diskFile.name) ||
              FileTile.isVideo(widget.diskFile.name)) {
            Fluttertoast.showToast(msg: 'Streaming File');
            _streamFile(widget.diskFile.name);
          } else {
            Fluttertoast.showToast(msg: 'Not a streamable file');
          }
        }
      },
      leading: Icon(
          widget.diskFile.isDirectory
              ? Icons.folder
              : FileTile.getFileIcon(widget.diskFile.name),
          color: widget.diskFile.isDirectory ? Colors.yellow[600] : null),
      title: Text(
        widget.diskFile.name,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: isDownloading
            ? LinearProgressIndicator(
                value: progress / 100,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).accentColor,
                ),
                backgroundColor: Theme.of(context).disabledColor)
            : Container(),
      ),
      trailing: !widget.diskFile.isDirectory
          ? isDownloading
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    cancelToken.cancel();
                    setState(() {
                      isDownloading = false;
                      cancelToken = CancelToken();
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.file_download),
                  onPressed: () {
                    downloadFile(Provider.of<Api>(context, listen: false),
                        getDiskFileUrl(widget.diskFile.name));
                  },
                )
          : null,
    );
  }
}
