enum Status {
  downloading,
  paused,
  stopped,
  completed,
  errors,
}

class Task{

  Task(this.hash);

  String hash; // hash value is a unique value for a torrent task
  String name;
  Status status;
  int size; // size in bytes
  String savePath; // directory where task is saved
  String remainingContent;
  String eta;
  int percentageDownload;
  int totalChunks;
  int completedChunks;
  int sizeOfChunk; // in bytes
  int torrentAdded; // timestamp of torrent added
  int torrentCreated; // timestamp of torrent created
  int seedsActual;
  int peersActual;
  int dlSpeed; // bytes per second
  int ulSpeed;// bytes per second
  int isOpen;
  int getState;
  String msg;
  String downloadedData;// in bytes
  int ratio;

  Status get getTaskStatus {
    Status status;
    status = isOpen==0?Status.stopped:getState==0?(Status.paused):Status.downloading;
    if(msg.length>0 && msg!='Tracker: [Tried all trackers.]')
      status = Status.errors;
    if(getPercentageDownload==100)
      status = Status.completed;
    return status;
  }

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