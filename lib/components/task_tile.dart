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
    var response = await http.post(Uri.parse(HomeScreen.url),
        body: {
          'mode': Constants().statusMap[toggleStatus],
          'hash': '${task.hash}',
        },
        encoding: Encoding.getByName("utf-8"));
    print(response.statusCode);
    print(response.body);
    print(task.hash);
  }

  Color _getStatusColor(Status status){
    switch(status){
      case Status.downloading:
        return Constants().kBlue;
      case Status.pausing:
        return Constants().kDarkGrey;
      case Status.stopped:
        return Constants().kRed;
      default:
        return Constants().kGreen;
    }
  }
  TaskTile(this.task);
  @override
  Widget build(BuildContext context) {
    Color statusColor = _getStatusColor(task.status);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        color: Colors.grey[200],
        width: double.infinity,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                VerticalDivider(
                  thickness: 5,
                  color: statusColor,
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
                        SizedBox(width: 100,),
                        Text('500 kb/s | 400 kb/s',style: TextStyle(fontSize: 10),),
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
                  color: statusColor,
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
