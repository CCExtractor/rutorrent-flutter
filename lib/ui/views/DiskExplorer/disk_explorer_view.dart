import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rutorrentflutter/theme/AppStateNotifier.dart';
import 'package:rutorrentflutter/ui/views/DiskExplorer/disk_explorer_viewmodel.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/loading_shimmer.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/Disk%20File%20Tile/disk_file_tile_view.dart';
import 'package:stacked/stacked.dart';

class DiskExplorerView extends StatelessWidget {
  const DiskExplorerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DiskExplorerViewModel>.reactive(
      builder: (context, model, child) => WillPopScope(
        onWillPop: model.onBackPress,
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
          body: model.isFeatureAvailable
              ? Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          'Files (${model.diskFiles.length})',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      model.isBusy
                          ? Expanded(
                              child: LoadingShimmer().loadingEffect(context))
                          : (model.diskFiles.length != 0)
                              ? Expanded(
                                  child: ListView.builder(
                                    itemCount: model.diskFiles.length,
                                    itemBuilder: (context, index) {
                                      return DiskFileTileView(
                                          model.diskFiles[index],
                                          model.path,
                                          model.goBackwards,
                                          model.goForwards);
                                    },
                                  ),
                                )
                              : Expanded(
                                  child: Center(
                                    child: SvgPicture.asset(
                                      !AppStateNotifier.isDarkModeOn
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
                    'Feature available only for SeedBoxes',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ),
        ),
      ),
      viewModelBuilder: () => DiskExplorerViewModel(),
    );
  }
}
