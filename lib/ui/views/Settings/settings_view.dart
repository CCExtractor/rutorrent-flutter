import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:rutorrentflutter/theme/app_state_notifier.dart';
import 'package:rutorrentflutter/ui/views/Settings/settings_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ValueListenableBuilder(
                  valueListenable: model.accounts,
                  builder: (context, List<Account> accounts, snapshot) {
                    return ExpansionTile(
                      title: Text('Manage Accounts',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      children: <Widget>[
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: accounts.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  // CHANGE PASSWORD
                                  model.showPasswordChangeDialog(
                                      context, index);
                                },
                                child: ListTile(
                                  dense: true,
                                  leading: Icon(
                                    Icons.supervisor_account,
                                    color: !AppStateNotifier.isDarkModeOn
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  title: Text(
                                      Uri.parse(accounts[index].url ?? "").host,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        accounts[index].username ?? "",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        'Change Password',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                      icon: Icon(
                                        Icons.delete_forever,
                                        color: Theme.of(context).primaryColor,
                                        size: 28,
                                      ),
                                      onPressed: () {
                                        // DELETE ACCOUNT
                                        model.showDeleteAccountDialog(
                                            context, index);
                                      }),
                                ),
                              );
                            })
                      ],
                    );
                  }),
              ListTile(
                title: Text('Notifications',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: Checkbox(
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (val) => model.toggleAllNotificationsEnabled(),
                  // settings.toggleAllNotificationsEnabled();
                  // Preferences.saveSettings(settings);,
                  value: model.allNotificationEnabled,
                ),
              ),
              ListTile(
                enabled: model.allNotificationEnabled,
                dense: true,
                leading: Icon(
                  Icons.disc_full,
                  color: !AppStateNotifier.isDarkModeOn
                      ? Colors.black
                      : Colors.white,
                ),
                title: Text('Disk Space Notification',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  'When disk space is lower than 10%',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Checkbox(
                  activeColor: Theme.of(context).primaryColor,
                  value: model.diskSpaceNotification,
                  onChanged: (val) => model.toggleDiskSpaceNotification(),
                  // if (settings.allNotificationEnabled) {
                  //   settings.toggleDiskSpaceNotification();
                  //   Preferences.saveSettings(settings);
                  // }
                ),
              ),
              ListTile(
                enabled: model.allNotificationEnabled,
                dense: true,
                leading: Icon(
                  Icons.add_alert,
                  color: !AppStateNotifier.isDarkModeOn
                      ? Colors.black
                      : Colors.white,
                ),
                title: Text('Torrent Add Notification',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  'When a new torrent is added',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Checkbox(
                  activeColor: Theme.of(context).primaryColor,
                  value: model.addTorrentNotification,
                  onChanged: (val) => model.toggleAddTorrentNotification(),
                  // if (settings.allNotificationEnabled) {
                  //   settings.toggleAddTorrentNotification();
                  //   Preferences.saveSettings(settings);
                  // }
                ),
              ),
              ListTile(
                enabled: model.allNotificationEnabled,
                dense: true,
                leading: Icon(
                  Icons.notifications,
                  color: !AppStateNotifier.isDarkModeOn
                      ? Colors.black
                      : Colors.white,
                ),
                title: Text('Download Notification',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  'When a torrent download is completed',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Checkbox(
                  activeColor: Theme.of(context).primaryColor,
                  value: model.downloadCompleteNotification,
                  onChanged: (val) =>
                      model.toggleDownloadCompleteNotification(),
                  // if (settings.allNotificationEnabled) {
                  //   settings.toggleDownloadCompleteNotification();
                  //   Preferences.saveSettings(settings);
                  // }
                ),
              ),
              Divider(),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.signOutAlt,
                  color: !AppStateNotifier.isDarkModeOn
                      ? Colors.black
                      : Colors.white,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Logout from all saved accounts',
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () => model.logoutAllAccounts(),
              )
            ],
          ),
        ),
      ),
      viewModelBuilder: () => SettingsViewModel(),
    );
  }
}
