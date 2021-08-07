import 'package:flutter/material.dart';
import 'package:rutorrentflutter/models/disk_file.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/disk_file_tile/disk_file_tile_viewmodel.dart';
import 'package:stacked/stacked.dart';

class DiskFileTileView extends StatelessWidget {
  final DiskFile diskFile;
  final String path;
  final Function backwards;
  final Function forwards;
  DiskFileTileView(this.diskFile, this.path, this.backwards, this.forwards);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DiskFileTileViewModel>.reactive(
      onModelReady: (model) => model.init(diskFile, path),
      builder: (context, model, child) => ListTile(
        dense: true,
        onTap: () => model.onTap(diskFile, backwards, forwards),
        leading: Icon(
            diskFile.isDirectory!
                ? Icons.folder
                : model.getFileIcon(diskFile.name),
            color: diskFile.isDirectory! ? Colors.yellow[600] : null),
        title: Text(
          diskFile.name!,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: model.isBusy
              ? LinearProgressIndicator(
                  value: model.progress / 100,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).accentColor,
                  ),
                  backgroundColor: Theme.of(context).disabledColor)
              : Container(),
        ),
        trailing: !(diskFile.isDirectory)!
            ? model.isBusy
                ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () => model.clearButtonOnTap(),
                  )
                : IconButton(
                    icon: Icon(Icons.file_download),
                    onPressed: () => model.downloadFile(),
                  )
            : null,
      ),
      viewModelBuilder: () => DiskFileTileViewModel(),
    );
  }
}
