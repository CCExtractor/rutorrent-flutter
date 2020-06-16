import 'dart:async';

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:rutorrentflutter/components/task_tile.dart';
import 'dart:convert';
import 'package:rutorrentflutter/models/task.dart';
import '../constants.dart' as Constants;

class HomeScreen extends StatefulWidget {
  static String url = 'https://fremicro081.xirvik.com/rtorrent/plugins/httprpc/action.php';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Constants.Sort sortPreference;

  Stream<List<Task>> _initTasksData() async* {
    while(true) {
      await Future.delayed(Duration(seconds: 1),(){
      });
      List<Task> tasksList = [];
      var response = await http.post(Uri.parse(HomeScreen.url),
          headers: {
            'authorization':Constants.getBasicAuth(),
          },
          body: {
            'mode': 'list',
          },
          encoding: Encoding.getByName("utf-8"));

      var tasksPath = jsonDecode(response.body)['t'];
      for (var hashKey in tasksPath.keys) {
        var taskObject = tasksPath[hashKey];
        Task task = Task(hashKey); // new task created
        task.name = taskObject[4];
        task.size = int.parse(taskObject[5]);
        task.savePath = taskObject[25];
        task.remainingContent = filesize(taskObject[19]);
        task.completedChunks = int.parse(taskObject[6]);
        task.totalChunks = int.parse(taskObject[7]);
        task.sizeOfChunk = int.parse(taskObject[13]);
        task.torrentAdded = int.parse(taskObject[21]);
        task.torrentCreated = int.parse(taskObject[26]);
        task.seedsActual = int.parse(taskObject[18]);
        task.peersActual = int.parse(taskObject[15]);
        task.ulSpeed = int.parse(taskObject[11]);
        task.dlSpeed = int.parse(taskObject[12]);
        task.isOpen = int.parse(taskObject[0]);
        task.getState = int.parse(taskObject[3]);
        task.msg = taskObject[29];
        task.downloadedData = filesize(taskObject[8]);
        task.ratio = int.parse(taskObject[10]);

        task.eta = task.getEta;
        task.percentageDownload= task.getPercentageDownload;
        task.status = task.getTaskStatus;
        tasksList.add(task);
      }
      yield tasksList;
    }
  }

  @override
  void initState() {
    super.initState();
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
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(
                        Icons.search,
                        color: Constants.kDarkGrey,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                            hintText: 'Search your item by name'),
                      ),
                    ),
                    PopupMenuButton<Constants.Sort>(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.sort,color: Constants.kDarkGrey,),
                      ),
                      onSelected: (selectedChoice){
                        setState(() {
                          sortPreference = selectedChoice;
                        });
                      },
                      itemBuilder: (BuildContext context){
                        return Constants.Sort.values.map((Constants.Sort choice) {
                          return PopupMenuItem<Constants.Sort>(
                            enabled: !(sortPreference==choice),
                            value: choice,
                            child: Text(Constants.sortMap[choice]),
                          );
                        }).toList();
                      },
                    ),
                  ],
                ),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 1.5),
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: _initTasksData(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(!snapshot.hasData){
                    return Center(child: Text('No Tasks to Show'),);
                  }
                  List<Task> sortedList = _sortList(snapshot.data, sortPreference);
                  return ListView.builder(
                    itemCount: sortedList.length,
                    itemBuilder: (BuildContext context,int index){
                      return TaskTile(sortedList[index]);
                    },
                  );
                },
              ),
            ),
          ],
        )
      ),
    );
  }

  List<Task> _sortList(List<Task> tasksList, Constants.Sort sort,){
    switch(sort){
      case Constants.Sort.name:
        tasksList.sort((a,b)=>a.name.compareTo(b.name));
        return tasksList;
      case Constants.Sort.dateAdded:
        tasksList.sort((a,b)=>a.torrentAdded.compareTo(b.torrentAdded));
        return tasksList;
      case Constants.Sort.percentDownloaded:
        tasksList.sort((a,b)=>a.percentageDownload.compareTo(b.percentageDownload));
        return tasksList;
      case Constants.Sort.downloadSpeed:
        tasksList.sort((a,b)=>a.dlSpeed.compareTo(b.dlSpeed));
        return tasksList;
      case Constants.Sort.uploadSpeed:
        tasksList.sort((a,b)=>a.ulSpeed.compareTo(b.ulSpeed));
        return tasksList;
      case Constants.Sort.ratio:
        tasksList.sort((a,b)=>a.ratio.compareTo(b.ratio));
        return tasksList;
      case Constants.Sort.size:
        tasksList.sort((a,b)=>a.size.compareTo(b.size));
        return tasksList;
      default:
        return tasksList;
    }
  }

}

