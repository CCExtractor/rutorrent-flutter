import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:rutorrentflutter/models/torrent.dart';

class TorrentDetailSheet extends StatefulWidget {
  final Torrent torrent;
  TorrentDetailSheet(this.torrent);
  @override
  _TorrentDetailSheetState createState() => _TorrentDetailSheetState();
}

class _TorrentDetailSheetState extends State<TorrentDetailSheet> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(widget.torrent.name),
              SizedBox(width: 20,),
              Text(filesize(widget.torrent.size)),
            ],
          ),
          Text('Status: Downloading'),
          Text('Download Speed: ${filesize(widget.torrent.dlSpeed)}'),
          Text('Upload Speed: ${filesize(widget.torrent.dlSpeed)}'),
          Text('Downloaded Data: ${widget.torrent.downloadedData}'),
          Text('Uploaded Data: ${widget.torrent.downloadedData}'),
          Text('Ratio: 1.892'),
          Text('Data Added: 16.06.2020 06:28:20'),
          Text('Data Created: 16.06.2020 06:28:20'),
          Text('Uploaded Data: ${widget.torrent.downloadedData}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Trackers List'),
              Icon(Icons.arrow_drop_down),

              Text('Files List'),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ],
      ),
    );
  }
}
