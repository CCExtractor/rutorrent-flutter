import 'dart:convert';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:rutorrentflutter/constants.dart' as Constants;
import 'package:rutorrentflutter/models/task.dart';
import 'package:rutorrentflutter/screens/home_screen.dart';
import 'package:http/http.dart' as http;

class TaskTile extends StatelessWidget {

  final Task task;
  TaskTile(this.task);

  _stopTask() async{
    await http.post(Uri.parse(HomeScreen.url),
        headers: {
          'authorization':Constants.getBasicAuth(),
        },
        body: {
          'mode': Status.stopped,
          'hash': '${task.hash}',
        },
        encoding: Encoding.getByName("utf-8"));
  }

  _toggleTaskStatus() async{
    Status toggleStatus = task.isOpen==0?
        Status.downloading:task.getState==0?(Status.downloading):Status.paused;

    var response = await http.post(Uri.parse(HomeScreen.url),
        headers: {
          'authorization':Constants.getBasicAuth(),
        },
        body: {
          'mode': Constants.statusMap[toggleStatus],
          'hash': '${task.hash}',
        },
        encoding: Encoding.getByName("utf-8"));
  }

  Color _getStatusColor(){
    switch(task.status){
      case Status.downloading:
        return Constants.kBlue;
      case Status.paused:
        return Constants.kDarkGrey;
      case Status.errors:
        return Constants.kRed;
      case Status.completed:
        return Constants.kGreen;
      default:
        return Constants.kDarkGrey;
    }
  }

  IconData _getTaskIconData(){
      return task.isOpen==0?Icons.play_circle_filled:task.getState==0?
          (Icons.play_circle_filled):Icons.pause_circle_filled;
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = _getStatusColor();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
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
                              Text(task.size,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,),),
                              Text('R: 1.083',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,color: Colors.grey[700]),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('${task.downloadedData}${task.dlSpeed==0?'':' | '+task.getEta}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 10,color: Colors.grey[800]),),
                                  Text('↓ ${filesize(task.dlSpeed.toString())+'/s'} | ↑ ${filesize(task.ulSpeed.toString())+'/s'}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 10,color: Colors.grey[700]),),
                                ],
                              ),
                              SizedBox(height: 4,),
                              LinearProgressIndicator(
                                value: task.percentageDownload/100,
                                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                                backgroundColor: Constants.kLightGrey
                              ),
                            ],
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
                    icon: Icon(_getTaskIconData()),
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
