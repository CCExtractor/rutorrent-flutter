import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rutorrentflutter/components/file_tile.dart';

class DownloadsPage extends StatefulWidget {
  @override
  _DownloadsPageState createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  List<FileSystemEntity> filesList = [];
  String _homeDirectory;
  String _directory;

  @override
  void initState() {
    super.initState();
    _initFiles();
  }

  Future<void> _initFiles() async {
    if (Platform.isAndroid) {
      _homeDirectory = (await getExternalStorageDirectory()).path + '/';
    } else {
      _homeDirectory = (await getApplicationDocumentsDirectory()).path + '/';
    }
    _directory = _homeDirectory;
    _syncFiles();
  }

  void _syncFiles() {
    setState(() {
      filesList = Directory(_directory).listSync();
    });
  }

  Future<bool> _onBackPress() async {
    if (_directory != _homeDirectory) {
      var temp = _directory.substring(0, _directory.lastIndexOf('/'));
      _directory = temp.substring(0, temp.lastIndexOf('/') + 1);
      _syncFiles();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        body: Container(
            child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Files (${filesList.length})',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            (filesList.isNotEmpty)
                ? Expanded(
                    child: ListView.builder(
                      itemCount: filesList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            if (filesList[index] is Directory) {
                              _directory = filesList[index].path + '/';
                              _syncFiles();
                            } else if (filesList[index] is File) {
                              OpenFile.open(filesList[index].path);
                            }
                          },
                          leading: Icon(
                              filesList[index] is Directory
                                  ? Icons.folder
                                  : FileTile.getFileIcon(filesList[index].path),
                              color: filesList[index] is Directory
                                  ? Colors.yellow[600]
                                  : null),
                          title: Text(
                            filesList[index].path.substring(
                                filesList[index].path.lastIndexOf('/') + 1),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: Center(
                      child: SvgPicture.asset(
                        Theme.of(context).brightness == Brightness.light
                            ? 'assets/logo/empty.svg'
                            : 'assets/logo/empty_dark.svg',
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
          ],
        )),
      ),
    );
  }
}
