class TorrentFile{

  String name;
  String chunksDownloaded;
  String chunksTotal;
  String size; //in bytes
  bool isPresentLocally=false;

  bool isComplete()=> chunksDownloaded==chunksTotal;

  TorrentFile(this.name,this.chunksDownloaded,this.chunksTotal,this.size);
}