
import 'package:rutorrentflutter/models/account.dart';

enum Status {
  downloading,
  paused,
  stopped,
  completed,
  errors,
}

class Torrent {
  Torrent(this.hash);

  late Account account;
  String? hash; // hash value is a unique value for a torrent
  late String name;
  Status? status;
  late int size; // size in bytes
  String? savePath; // directory where torrent is saved
  String? eta;
  String? label; // label of torrent
  late int percentageDownload;
  late int totalChunks;
  late int completedChunks;
  late int sizeOfChunk; // in bytes
  late int torrentAdded; // timestamp of torrent added
  int? torrentCreated; // timestamp of torrent created
  int? seedsActual;
  int? peersActual;
  int? dlSpeed; // bytes per second
  int? ulSpeed; // bytes per second
  int? isOpen;
  int? getState;
  String? msg;
  int? downloadedData; // in bytes
  int? uploadedData; // in bytes
  late int ratio;

  Status get getTorrentStatus {
    Status status;
    status = isOpen == 0
        ? Status.stopped
        : getState == 0
            ? (Status.paused)
            : Status.downloading;
    if (msg!.length > 0 && msg != 'Tracker: [Tried all trackers.]')
      status = Status.errors;
    if (getPercentageDownload == 100) status = Status.completed;
    return status;
  }

  /// returns percentage torrent downloaded using file chunks
  int get getPercentageDownload =>
      (completedChunks / totalChunks * 100).round();

  /// returns expected time remaining of downloading torrent in hrs and min
  String get getEta {
    if (dlSpeed == 0) //check download speed to prevent "Infinity or div by 0"
      return '';
    Duration duration = Duration(
        seconds: ((totalChunks - completedChunks) * sizeOfChunk / dlSpeed!)
            .round()); // in seconds
    int hrs = duration.inHours;
    int min = duration.inMinutes % 60;
    String eta;
    eta = hrs > 0 ? '$hrs hrs ' : '';
    eta = eta + '$min min';
    return eta;
  }

  Torrent.fromObject({required List torrentObject, Account? account, String? hashKey}){
    hash = hashKey;
    name = torrentObject[4];
    size = int.parse(torrentObject[5]);
    savePath = torrentObject[25];
    label = torrentObject[14].toString().replaceAll("%20", " ");
    completedChunks = int.parse(torrentObject[6]);
    totalChunks = int.parse(torrentObject[7]);
    sizeOfChunk = int.parse(torrentObject[13]);
    torrentAdded = int.parse(torrentObject[21]);
    torrentCreated = int.parse(torrentObject[26]);
    seedsActual = int.parse(torrentObject[18]);
    peersActual = int.parse(torrentObject[15]);
    ulSpeed = int.parse(torrentObject[11]);
    dlSpeed = int.parse(torrentObject[12]);
    isOpen = int.parse(torrentObject[0]);
    getState = int.parse(torrentObject[3]);
    msg = torrentObject[29];
    downloadedData = int.parse(torrentObject[8]);
    uploadedData = int.parse(torrentObject[9]);
    ratio = int.parse(torrentObject[10]);

    account = account;
    eta = getEta;
    percentageDownload = getPercentageDownload;
    status = getTorrentStatus;
  }
}
