import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:rutorrentflutter/models/torrent_file.dart';

class FileTile extends StatefulWidget {
  final TorrentFile file;
  final Torrent torrent;
  final Function syncFilesCallback;

  FileTile(this.file, this.torrent, this.syncFilesCallback);

  static String getFileExtension(String filename) {
    return filename.substring(filename.lastIndexOf('.'), filename.length);
  }

  static bool isImage(String filename) {
    String ext = getFileExtension(filename);
    if (ext == '.jpg' || ext == '.jpeg' || ext == 'png') return true;
    return false;
  }

  static bool isAudio(String filename) {
    String ext = getFileExtension(filename);
    if (ext == '.mp3' || ext == '.wav') return true;
    return false;
  }

  static bool isVideo(String filename) {
    String ext = getFileExtension(filename);
    if (ext == '.mp4' || ext == '.mkv') return true;
    return false;
  }

  static IconData getFileIcon(String filename) {
    if (isVideo(filename)) return Icons.ondemand_video;

    if (isAudio(filename)) return Icons.music_video;

    if (isImage(filename)) return Icons.image;

    return Icons.insert_drive_file;
  }

  @override
  _FileTileState createState() => _FileTileState();
}

class _FileTileState extends State<FileTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (widget.file.isPresentLocally) {
          OpenFile.open(widget.file.localFilePath);
        }
      },
      leading: Icon(FileTile.getFileIcon(widget.file.name)),
      title: Text(
        widget.file.name,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: Text(
          filesize(widget.file.size),
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ),
      trailing: widget.file.isPresentLocally
          ? IconButton(onPressed: () {}, icon: Icon(Icons.check_box))
          : null,
    );
  }
}
