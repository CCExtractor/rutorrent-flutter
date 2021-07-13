import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.logger.dart';

Logger log = getLogger("FileService");

///[Service] for exposing file utils throughout the application as well as persisting state
class FileService {
  String getFileExtension(String filename) {
    try {
      return filename.substring(filename.lastIndexOf('.'), filename.length);
    } catch (e) {
      return "";
    }
  }

  bool isImage(String filename) {
    String ext = getFileExtension(filename);
    if (ext == '.jpg' || ext == '.jpeg' || ext == 'png') return true;
    return false;
  }

  bool isAudio(String filename) {
    String ext = getFileExtension(filename);
    if (ext == '.mp3' || ext == '.wav') return true;
    return false;
  }

  bool isVideo(String filename) {
    String ext = getFileExtension(filename);
    if (ext == '.mp4' || ext == '.mkv') return true;
    return false;
  }

  IconData getFileIcon(String filename) {
    if (isVideo(filename)) return Icons.ondemand_video;

    if (isAudio(filename)) return Icons.music_video;

    if (isImage(filename)) return Icons.image;

    return Icons.insert_drive_file;
  }
}
