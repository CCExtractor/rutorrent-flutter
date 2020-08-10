class TorrentFile{

  String name;
  String chunksDownloaded;
  String chunksTotal;
  String size; //in bytes

  bool isComplete()=> chunksDownloaded==chunksTotal;

  TorrentFile(this.name,this.chunksDownloaded,this.chunksTotal,this.size);
}