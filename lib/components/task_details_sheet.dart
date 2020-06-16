import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:rutorrentflutter/models/task.dart';

class TaskDetailSheet extends StatefulWidget {
  final Task task;
  TaskDetailSheet(this.task);
  @override
  _TaskDetailSheetState createState() => _TaskDetailSheetState();
}

class _TaskDetailSheetState extends State<TaskDetailSheet> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(widget.task.name),
              SizedBox(width: 20,),
              Text(filesize(widget.task.size)),
            ],
          ),
          Text('Status: Downloading'),
          Text('Download Speed: ${filesize(widget.task.dlSpeed)}'),
          Text('Upload Speed: ${filesize(widget.task.dlSpeed)}'),
          Text('Downloaded Data: ${widget.task.downloadedData}'),
          Text('Uploaded Data: ${widget.task.downloadedData}'),
          Text('Ratio: 1.892'),
          Text('Data Added: 16.06.2020 06:28:20'),
          Text('Data Created: 16.06.2020 06:28:20'),
          Text('Uploaded Data: ${widget.task.downloadedData}'),
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
    );;
  }
}
