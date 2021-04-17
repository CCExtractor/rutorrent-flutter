import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/components/custom_dialog.dart';
import 'package:rutorrentflutter/components/password_input.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/models/settings.dart';
import 'package:rutorrentflutter/screens/configurations_screen.dart';
import 'package:rutorrentflutter/screens/main_screen.dart';
import 'package:rutorrentflutter/utilities/constants.dart';
import 'package:rutorrentflutter/utilities/preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _logoutAllAccounts(BuildContext context) {
    showDialog<CustomDialog>(
        context: context,
        builder: (dialogContext) => CustomDialog(
              title: 'Are you sure you want to logout from all saved accounts?',
              optionLeftText: 'No',
              optionRightText: 'Yes',
              optionLeftOnPressed: () => Navigator.pop(dialogContext),
              optionRightOnPressed: () {
                // Closes dialog box.
                Navigator.pop(dialogContext);

                Preferences.clearLogin();
                Navigator.pop(dialogContext);
                Navigator.pushReplacement(
                    dialogContext,
                    MaterialPageRoute<ConfigurationsScreen>(
                      builder: (dialogContext) => ConfigurationsScreen(),
                    ));
              },
            ));
  }

  void _deleteAccount(
      BuildContext context, GeneralFeatures general, int index) {
    showDialog<CustomDialog>(
        context: context,
        builder: (context) => CustomDialog(
              title: 'Are you sure you want to delete this account?'
                  '${general.apis.length == 1 ? '\n\nYou will be logged out!' : ''}',
              optionLeftText: 'No',
              optionRightText: 'Yes',
              optionLeftOnPressed: () {
                Navigator.pop(context);
              },
              optionRightOnPressed: () {
                // closes dialog
                Navigator.pop(context);

                if (general.apis.length == 1) {
                  // If only one account was added then log out user
                  _logoutAllAccounts(context);
                } else {
                  if (index == 0) {
                    // If active account is being deleted
                    general.apis.removeAt(index);
                    Preferences.saveLogin(general.apis);

                    // Change the active account
                    var api = Provider.of<Api>(context, listen: false);
                    api.setUrl(general.apis[0].url);
                    api.setUsername(general.apis[0].username);
                    api.setPassword(general.apis[0].password);
                  } else {
                    general.apis.removeAt(index);
                    Preferences.saveLogin(general.apis);
                  }

                  //closes SettingsScreen
                  Navigator.pop(context);
                  // Refresh to MainScreen
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<MainScreen>(
                          builder: (context) => MainScreen()));
                }
              },
            ));
  }

  void _changePassword(
      BuildContext context, GeneralFeatures general, int index) {
    StateSetter _setState;

    var fieldController = TextEditingController();
    var isValidating = false;

    Future<void> _validatePassword(String newPassword) async {
      if (newPassword == general.apis[index].password) {
        await Fluttertoast.showToast(
            msg: 'New password cannot be same as old password');
        return;
      }

      _setState(() {
        isValidating = true;
      });

      Response response;
      int total;
      try {
        response = await general.apis[index].ioClient
            .get(Uri.parse(general.apis[index].diskSpacePluginUrl), headers: {
          'authorization': 'Basic ' +
              base64Encode(
                  utf8.encode('${general.apis[index].username}:$newPassword')),
        });
        total = (jsonDecode(response.body)['total'] as int);
      } catch (e) {
        await Fluttertoast.showToast(msg: 'Invalid Password');
      }
      _setState(() {
        isValidating = false;
      });

      if (response != null && total != null && response.statusCode == 200) {
        general.apis[index].setPassword(newPassword);
        await Preferences.saveLogin(general.apis);

        await Fluttertoast.showToast(msg: 'Password Changed Successfully');
        Navigator.pop(context);

        if (index == 0) {
          // If active account password was changed

          // closes Settings Screen
          Navigator.pop(context);

          // change password of active account
          Provider.of<Api>(context, listen: false).setPassword(newPassword);

          // refresh main screen
          await Navigator.pushReplacement(
              context,
              MaterialPageRoute<MainScreen>(
                  builder: (context) => MainScreen()));
        }
      }
    }

    showDialog<AlertDialog>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: StatefulBuilder(builder: (context, setState) {
              _setState = setState;
              return Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'New Password',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PasswordInput(
                      textEditingController: fieldController,
                      autoFocus: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isValidating
                        ? CircularProgressIndicator()
                        : Container(
                            height: 40,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Provider.of<Mode>(context).isLightMode
                                    ? Colors.white
                                    : kGreyDT,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                              onPressed: () {
                                _validatePassword(fieldController.text);
                              },
                              child: Text(
                                'VALIDATE',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                  )
                ],
              );
            }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<Settings, GeneralFeatures>(
        builder: (context, settings, general, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ExpansionTile(
                title: Text('Manage Accounts',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                children: <Widget>[
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: general.apis.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // CHANGE PASSWORD
                            _changePassword(context, general, index);
                          },
                          child: ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.supervisor_account,
                              color: Provider.of<Mode>(context).isLightMode
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            title: Text(Uri.parse(general.apis[index].url).host,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            subtitle: Text(
                              'Change Password',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                            trailing: IconButton(
                                icon: Icon(
                                  Icons.delete_forever,
                                  color: Theme.of(context).primaryColor,
                                  size: 28,
                                ),
                                onPressed: () {
                                  // DELETE ACCOUNT
                                  _deleteAccount(context, general, index);
                                }),
                          ),
                        );
                      })
                ],
              ),
              ListTile(
                title: Text('Notifications',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: Checkbox(
                  activeColor: Theme.of(context).primaryColor,
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
                leading: Icon(
                  Icons.disc_full,
                  color: Provider.of<Mode>(context).isLightMode
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
                  value: settings.diskSpaceNotification,
                  onChanged: (val) {
                    if (settings.allNotificationEnabled) {
                      settings.toggleDiskSpaceNotification();
                      Preferences.saveSettings(settings);
                    }
                  },
                ),
              ),
              ListTile(
                enabled: settings.allNotificationEnabled,
                dense: true,
                leading: Icon(
                  Icons.add_alert,
                  color: Provider.of<Mode>(context).isLightMode
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
                  value: settings.addTorrentNotification,
                  onChanged: (val) {
                    if (settings.allNotificationEnabled) {
                      settings.toggleAddTorrentNotification();
                      Preferences.saveSettings(settings);
                    }
                  },
                ),
              ),
              ListTile(
                enabled: settings.allNotificationEnabled,
                dense: true,
                leading: Icon(
                  Icons.notifications,
                  color: Provider.of<Mode>(context).isLightMode
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
                  value: settings.downloadCompleteNotification,
                  onChanged: (val) {
                    if (settings.allNotificationEnabled) {
                      settings.toggleDownloadCompleteNotification();
                      Preferences.saveSettings(settings);
                    }
                  },
                ),
              ),
              Divider(),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.signOutAlt,
                  color: Provider.of<Mode>(context).isLightMode
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
                onTap: () => _logoutAllAccounts(context),
              )
            ],
          ),
        ),
      );
    });
  }
}
