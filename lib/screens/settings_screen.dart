import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/models/settings.dart';
import 'package:rutorrentflutter/screens/configurations_screen.dart';
import 'package:rutorrentflutter/utilities/preferences.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context,Settings settings,child) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(),
            title: Text(
              'Settings', style: TextStyle(fontWeight: FontWeight.w400),),
          ),
          body: Column(
            children: <Widget>[
              ListTile(
                title: Text('Notifications',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: Checkbox(
                  activeColor: Theme.of(context).primaryColorLight,
                  onChanged: (val) {
                    settings.toggleAllNotificationsEnabled();
                    Preferences.saveSettings(settings);
                  },
                  value: settings.allNotificationEnabled,
                ),
              ),
              ListTile(
                enabled: settings.allNotificationEnabled,
                dense: true,
                leading: Icon(Icons.disc_full),
                title: Text('Disk Space Notification',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('When disk space is lower than 10%'
                  , style: TextStyle(fontSize: 12),),
                trailing: Checkbox(
                  activeColor: Theme.of(context).primaryColorLight,
                  value: settings.diskSpaceNotification,
                  onChanged: (val) {
                    if(settings.allNotificationEnabled) {
                      settings.toggleDiskSpaceNotification();
                      Preferences.saveSettings(settings);
                    }
                  },
                ),
              ),
              ListTile(
                enabled: settings.allNotificationEnabled,
                dense: true,
                leading: Icon(Icons.add_alert),
                title: Text('Torrent Add Notification',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('When a new torrent is added'
                  , style: TextStyle(fontSize: 12),),
                trailing: Checkbox(
                  activeColor: Theme.of(context).primaryColorLight,
                  value: settings.addTorrentNotification,
                  onChanged: (val) {
                    if(settings.allNotificationEnabled) {
                      settings.toggleAddTorrentNotification();
                      Preferences.saveSettings(settings);
                    }
                  },
                ),
              ),
              ListTile(
                enabled: settings.allNotificationEnabled,
                dense: true,
                leading: Icon(Icons.notifications),
                title: Text('Download Notification',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('When a torrent download is completed'
                  , style: TextStyle(fontSize: 12),),
                trailing: Checkbox(
                  activeColor: Theme.of(context).primaryColorLight,
                  value: settings.downloadCompleteNotification,
                  onChanged: (val) {
                    if(settings.allNotificationEnabled) {
                      settings.toggleDownloadCompleteNotification();
                      Preferences.saveSettings(settings);
                    }
                  },
                ),
              ),
              Divider(),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.signOutAlt),
                title: Text(
                  'Logout', style: TextStyle(fontWeight: FontWeight.w600),),
                subtitle: Text('Logout from all saved accounts',
                  style: TextStyle(fontSize: 12),),
                onTap: () async {
                  await Preferences.clearLogin();
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => ConfigurationsScreen(),
                  ));
                },
              )
            ],
          ),
        );
      }
    );
  }
}
