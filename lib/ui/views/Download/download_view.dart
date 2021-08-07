import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rutorrentflutter/ui/views/download/download_viewmodel.dart';
import 'package:stacked/stacked.dart';

class DownloadView extends StatelessWidget {
  const DownloadView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DownloadViewModel>.reactive(
      builder: (context, model, child) => WillPopScope(
        onWillPop: model.onBackPress,
        child: Scaffold(
          body: Container(
              child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  'Files (${model.filesList.length})',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              (model.filesList.length != 0)
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: model.filesList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () => model.openFile(index),
                            leading: Icon(
                                model.filesList[index] is Directory
                                    ? Icons.folder
                                    : model.getFileIcon(
                                        model.filesList[index].path),
                                color: model.filesList[index] is Directory
                                    ? Colors.yellow[600]
                                    : null),
                            title: Text(
                              model.filesList[index].path.substring(
                                  model.filesList[index].path.lastIndexOf('/') +
                                      1),
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
      ),
      viewModelBuilder: () => DownloadViewModel(),
    );
  }
}
