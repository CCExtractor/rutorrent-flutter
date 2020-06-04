import 'package:flutter/material.dart';
import 'package:rutorrentflutter/models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;

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
                  icon: Icon(Icons.play_circle_filled),
                  onPressed: (){},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
