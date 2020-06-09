import 'dart:convert';

import 'package:filesize/filesize.dart';
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
        headers: {
          'authorization':Constants().getBasicAuth(),
        },
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
            Expanded(
              flex: 5,
              child: Row(
                children: <Widget>[
                  VerticalDivider(
                    thickness: 5,
                    color: statusColor,
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(child: Text(task.name,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),)),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('${task.size}${task.dlSpeed==0?'':' | '+task.getEta}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,color: Colors.grey[800]),),
                              Text('↓ ${filesize(task.dlSpeed.toString())+'/s'} | ↑ ${filesize(task.ulSpeed.toString())+'/s'}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 10,color: Colors.grey[700]),),
                            ],
                          ),
                        ),
                        Flexible(
                          child: LinearProgressIndicator(
                            value: 0.77,
                            backgroundColor: Constants().kLightGrey
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(task.getPercentageDownload.toString()+'%',style: TextStyle(color: statusColor,fontWeight: FontWeight.w600),),
                  IconButton(
                    color: statusColor,
                    iconSize: 40,
                    icon: Icon(task.status==Status.downloading?Icons.pause_circle_filled:Icons.play_circle_filled),
                    onPressed: _toggleTaskStatus,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
