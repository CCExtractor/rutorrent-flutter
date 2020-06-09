enum Status {
  downloading,
  pausing,
  stopped,
}

class Task{

  Task(this.hash);

  String hash; // hash value is a unique value for a torrent task
  String name;
  Status status;
  String size; // size in appropriate unit
  String savePath; // directory where task is saved
  String remainingContent;
  int totalChunks;
  int completedChunks;
  int sizeOfChunk; // in bytes
  int torrentAdded; // timestamp of torrent added
  int torrentCreated; // timestamp of torrent created
  int seedsActual;
  int peersActual;
  int dlSpeed; // bytes per second
  int ulSpeed; // bytes per second

  /// returns percentage task downloaded using file chunks
  int get getPercentageDownload => (completedChunks/totalChunks*100).round();

  /// returns expected time remaining of downloading task in hrs and min
  String get getEta {
    if(dlSpeed==0) //check download speed to prevent "Infinity or div by 0"
      return '';
    Duration duration = Duration(seconds:((totalChunks-completedChunks)*sizeOfChunk/dlSpeed).round()); // in seconds
    int hrs = duration.inHours;
    int min = duration.inMinutes%60;
    String eta;
    eta = hrs>0? '$hrs hrs ':'';
    eta = eta + '$min min';
    return eta;
  }
}