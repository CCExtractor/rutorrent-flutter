import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rutorrentflutter/theme/app_state_notifier.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:rutorrentflutter/ui/views/home/home_viewmodel.dart';

@override
// ignore: non_constant_identifier_names
AppBar HomeViewAppBar(Account account, HomeViewModel model) {
  return AppBar(
    title: Text(
      'Hey, ${account.username}',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    ),
    elevation: 0.0,
    leading: Builder(builder: (context) {
      return IconButton(
          icon: Icon(
            Icons.subject,
            size: 34,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          });
    }),
    actions: <Widget>[
      IconButton(
          icon: FaIcon(
            AppStateNotifier.isDarkModeOn
                ? FontAwesomeIcons.solidMoon
                : FontAwesomeIcons.solidSun,
          ),
          onPressed: () async {
            await model.toggleTheme(!AppStateNotifier.isDarkModeOn);
          }),
    ],
  );
}
