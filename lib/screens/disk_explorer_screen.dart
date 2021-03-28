import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  bool isLoading = true;
  bool isFeatureAvailable = false;

  _getDiskFiles() async {
    setState(() {
      isLoading = true;
    });
    diskFiles = await ApiRequests.getDiskFiles(
            Provider.of<Api>(context, listen: false), path) ??
        [];
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
    Future.delayed(Duration.zero)
        .then((_) => isFeatureAvailable =
            Provider.of<Api>(context, listen: false).isSeedboxAccount)
        .then((_) => isFeatureAvailable ? _getDiskFiles() : isLoading = false);
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
        body: isFeatureAvailable
            ? Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Files (${diskFiles.length})',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    isLoading
                        ? Expanded(
                            child: LoadingShimmer().loadingEffect(context))
                        : (diskFiles.length != 0)
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: diskFiles.length,
                                  itemBuilder: (context, index) {
                                    return DiskFileTile(diskFiles[index], path,
                                        goBackwards, goForwards);
                                  },
                                ),
                              )
                            : Expanded(
                                child: Center(
                                  child: SvgPicture.asset(
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? 'assets/logo/empty.svg'
                                        : 'assets/logo/empty_dark.svg',
                                    width: 120,
                                    height: 120,
                                  ),
                                ),
                              ),
                  ],
                ),
              )
            : Center(
                child: Text(
                  'Feature not available!',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
      ),
    );
  }
}
