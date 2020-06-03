import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasksList = [];
  bool loadingTasks;

  String url = 'http://192.168.43.176/rutorrent/plugins/httprpc/action.php';

  _initTasksData() async{
    var response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Connection": "keep-alive",
          "Accept-Encoding": "gzip, deflate, br",
          "Accept" : "*/*",
          "Accept-Language" : "en-GB,en-US;q=0.9,en;q=0.8",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: {
          'mode': 'list',
        },
        encoding: Encoding.getByName("utf-8"));
    print(response.statusCode);
    print(response.body);

    var tasksPath = jsonDecode(response.body)['t'];
    for(var hashKey in tasksPath.keys){
      var taskObject = tasksPath[hashKey];
      Task task = Task(hashKey); // new task created
      task.name = taskObject[4];
      task.size = filesize(taskObject[5]);
      task.savePath = taskObject[25];
      print(task.savePath);

      tasksList.add(task);
    }

    setState(() {
      loadingTasks=false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadingTasks=true;
    _initTasksData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.solidMoon),
            onPressed: (){
              Fluttertoast.showToast(msg: "Night mode currently unavailable");
              _initTasksData();
            },
          ),
        ],
      ),
      drawer: Drawer(),
      body: Container(
        child: loadingTasks?
        Center(child: CircularProgressIndicator()):
            ListView.builder(
              itemCount: tasksList.length,
              itemBuilder: (BuildContext context,int index){
                return TaskTile(tasksList[index]);
              },
            )
      ),
    );
  }
}

enum Status {
  downloading,
  pausing,
  stopped,
}


class Task{

  Task(this.hash);

  String hash; // hash value is a unique value for a torrent task
  String name;
  Status status;
  String size; // size in appropriate unit
  String savePath; // directory where task is saved
}

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
