import 'package:rutorrentflutter/api/api_conf.dart';

enum Status {
  downloading,
  paused,
  stopped,
  completed,
  errors,
}

class Torrent {
  Torrent(this.hash);

  Api api;
  String hash; // hash value is a unique value for a torrent
  String name;
  Status status;
  int size; // size in bytes
  String savePath; // directory where torrent is saved
  String eta;
  String label; // label of torrent
  int percentageDownload;
  int totalChunks;
  int completedChunks;
  int sizeOfChunk; // in bytes
  int torrentAdded; // timestamp of torrent added
  int torrentCreated; // timestamp of torrent created
  int seedsActual;
  int peersActual;
  int dlSpeed; // bytes per second
  int ulSpeed; // bytes per second
  int isOpen;
  int getState;
  String msg;
  int downloadedData; // in bytes
  int uploadedData; // in bytes
  int ratio;

  Status get getTorrentStatus {
    Status status;
    status = isOpen == 0
        ? Status.stopped
        : getState == 0
            ? (Status.paused)
            : Status.downloading;
    if (msg.isNotEmpty && msg != 'Tracker: [Tried all trackers.]') {
      status = Status.errors;
    }
    if (getPercentageDownload == 100) status = Status.completed;
    return status;
  }

  /// returns percentage torrent downloaded using file chunks
  int get getPercentageDownload =>
      (completedChunks / totalChunks * 100).round();

  /// returns expected time remaining of downloading torrent in hrs and min
  String get getEta {
    if (dlSpeed == 0) {
      return '';
    }
    var duration = Duration(
        seconds: ((totalChunks - completedChunks) * sizeOfChunk / dlSpeed)
            .round()); // in seconds
    var hrs = duration.inHours;
    var min = duration.inMinutes % 60;
    String eta;
    eta = hrs > 0 ? '$hrs hrs ' : '';
    eta = eta + '$min min';
    return eta;
  }
}
