import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:rutorrentflutter/AppTheme/AppStateNotifier.dart';
import 'package:rutorrentflutter/app/constants.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/label_tile_widget.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/show_disk_space_widget.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/Drawer/drawer_viewmodel.dart';
import 'package:stacked/stacked.dart';

class DrawerView extends StatelessWidget {
 PackageInfo? packageInfo;
 DrawerView({this.packageInfo});

 @override
 Widget build(BuildContext context) {
   return ViewModelBuilder<DrawerViewModel>.reactive(
     builder: (context, model, child) => Drawer(
          child: Column(
            children: [
              DrawerHeader(
                margin: EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image(
                      image: !AppStateNotifier.isDarkModeOn
                          ? AssetImage('assets/logo/light_mode.png')
                          : AssetImage('assets/logo/dark_mode.png'),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Application version: ${packageInfo?.version ?? ""}',
                      style:
                          TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ShowDiskSpace(model.diskSpace),
                      ExpansionTile(
                        leading: Icon(Icons.supervisor_account,
                            color:
                                !AppStateNotifier.isDarkModeOn ? Colors.black : Colors.white),
                        title: Text('Accounts'),
                        children: model.getAccountsList(context),
                      ),
                      ExpansionTile(
                        initiallyExpanded: true,
                        leading: Icon(Icons.sort,
                            color:
                                !AppStateNotifier.isDarkModeOn ? Colors.black : Colors.white),
                        title: Text(
                          'Filters',
                        ),
                        children: model.filterTileList,
                      ),
                      ExpansionTile(
                        initiallyExpanded: true,
                        leading: Icon(Icons.sort,
                            color:
                                !AppStateNotifier.isDarkModeOn ? Colors.black : Colors.white),
                        title: Text(
                          'Labels',
                        ),
                        children: ((model.listOfLabels.value as List<String>)
                            .map((e) => LabelTile(label: e,model: model,))
                            .toList()),
                      ),
                      ListTile(
                        leading: Icon(Icons.history,
                            color:
                                !AppStateNotifier.isDarkModeOn ? Colors.black : Colors.white),
                        onTap: () => model.navigateToHistoryScreen(),
                        title: Text('History'),
                      ),
                      ListTile(
                        leading: Icon(Icons.folder_open,
                            color:
                                !AppStateNotifier.isDarkModeOn ? Colors.black : Colors.white),
                        onTap: () => model.navigateToDiskExplorerScreen(),
                        title: Text('Explorer'),
                      ),
                      ListTile(
                        leading: Icon(Icons.settings,
                            color:
                                !AppStateNotifier.isDarkModeOn ? Colors.black : Colors.white),
                        onTap: () => model.navigateToSettingsScreen(),
                        title: Text('Settings'),
                      ),
                      ListTile(
                        leading: Icon(Icons.info_outline,
                            color:
                                !AppStateNotifier.isDarkModeOn ? Colors.black : Colors.white),
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationVersion: packageInfo?.version ?? "",
                            applicationIcon: Image(
                              height: 75,
                              image: !AppStateNotifier.isDarkModeOn
                                  ? AssetImage(
                                      'assets/logo/light_mode_icon.png')
                                  : AssetImage(
                                      'assets/logo/dark_mode_icon.png'),
                            ),
                            children: [
                              Text(
                                'Build Number : $BUILD_NUMBER',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Release Date : $RELEASE_DATE',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Package Name : ${packageInfo?.packageName ?? ""}',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ],
                          );
                        },
                        title: Text('About'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
     viewModelBuilder: () => DrawerViewModel(),
   );
 }
}