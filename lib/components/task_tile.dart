import 'dart:convert';

import 'package:rutorrentflutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:rutorrentflutter/models/task.dart';
import 'package:rutorrentflutter/screens/home_screen.dart';
import 'package:http/http.dart' as http;

class TaskTile extends StatelessWidget {
  final Task task;

  _toggleTaskStatus() async{
    Status currentStatus = task.status;
    Status toggleStatus;
    switch(currentStatus){
      case Status.downloading:
        toggleStatus=Status.pausing;
        break;
      case Status.pausing:
        toggleStatus=Status.downloading;
        break;
      case Status.stopped:
        toggleStatus=Status.downloading;
        break;
    }
    var response = await http.post(Uri.parse(HomePage.url),
        body: {
          'mode': statusMap[toggleStatus],
          'hash': '${task.hash}',
        },
        encoding: Encoding.getByName("utf-8"));
    print(response.statusCode);
    print(response.body);
    print(task.hash);
  }

  TaskTile(this.task);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        color: Colors.grey[300],
        width: double.infinity,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                VerticalDivider(
                  thickness: 5,
                  color: Colors.red,
                ),
                SizedBox(width: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(task.name,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('${task.size} | 125 Min',style: TextStyle(fontSize: 12),),
                        Text('500 kb/s | 400 kb/s',style: TextStyle(fontSize: 12),),
                      ],
                    )
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('77%'),
                IconButton(
                  color: Colors.grey,
                  iconSize: 40,
                  icon: Icon(task.status==Status.downloading?Icons.pause_circle_filled:Icons.play_circle_filled),
                  onPressed: _toggleTaskStatus,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
