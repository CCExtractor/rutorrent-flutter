class TorrentFile {
  String name;
  String chunksDownloaded;
  String chunksTotal;
  String size; //in bytes

  bool isPresentLocally =
      false; // to check whether a file is downloaded locally
  String localFilePath; // path of locally downloaded file

  /// return true if is downloaded completely on the server
  bool isComplete() => chunksDownloaded == chunksTotal;

  TorrentFile(this.name, this.chunksDownloaded, this.chunksTotal, this.size);
}
