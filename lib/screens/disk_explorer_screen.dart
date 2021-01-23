import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/components/disk_file_tile.dart';
import 'package:rutorrentflutter/components/loading_shimmer.dart';
import 'package:rutorrentflutter/models/disk_file.dart';

class DiskExplorer extends StatefulWidget {
  @override
  _DiskExplorerState createState() => _DiskExplorerState();
}

class _DiskExplorerState extends State<DiskExplorer> {
  List<DiskFile> diskFiles = [];
  String path = '/';
  bool isLoading = false;

  _getDiskFiles() async {
    setState(() {
      isLoading = true;
    });
    diskFiles = await ApiRequests.getDiskFiles(
        Provider.of<Api>(context, listen: false), path);
    setState(() {
      isLoading = false;
    });
  }

  goBackwards() {
    path = path.substring(0, path.length - 1);
    path = path.substring(0, path.lastIndexOf('/') + 1);
    _getDiskFiles();
  }

  goForwards(String fileName) {
    path += fileName + '/';
    _getDiskFiles();
  }

  Future<bool> _onBackPress() async {
    if (path == '/') {
      return true;
    }
    goBackwards();
    return false;
  }

  @override
  void initState() {
    super.initState();
    _getDiskFiles();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Explorer',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Files (${diskFiles.length})',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            isLoading
                ? Expanded(child: LoadingShimmer().loadingEffect(context))
                : Expanded(
                    child: ListView.builder(
                      itemCount: diskFiles.length,
                      itemBuilder: (context, index) {
                        return DiskFileTile(
                            diskFiles[index], path, goBackwards, goForwards);
                      },
                    ),
                  ),
          ],
        )),
      ),
    );
  }
}
