import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:rutorrentflutter/models/torrent_file.dart';
import 'package:rutorrentflutter/services/state_services/file_service.dart';
FileService _fileService = locator<FileService>();

class FileTileWidget extends StatelessWidget {
 final TorrentFile file;
 final Torrent torrent;
 final Function syncFilesCallback;

 FileTileWidget(this.file, this.torrent, this.syncFilesCallback);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (file.isPresentLocally) {
          OpenFile.open(file.localFilePath);
        }
      },
      leading: Icon(getFileIcon(file.name)),
      title: Text(
        file.name,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: Text(
          filesize(file.size),
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ),
      trailing: file.isPresentLocally
          ? IconButton(onPressed: () {}, icon: Icon(Icons.check_box))
          : null,
    );
  }
  IconData getFileIcon(String filename) {
    if (_fileService.isVideo(filename)) return Icons.ondemand_video;

    if (_fileService.isAudio(filename)) return Icons.music_video;

    if (_fileService.isImage(filename)) return Icons.image;

    return Icons.insert_drive_file;
  }
}