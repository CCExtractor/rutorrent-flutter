import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rutorrentflutter/screens/configurations_screen.dart';
import 'package:rutorrentflutter/services/preferences.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Container(
                child: Text('More options (preferences) to be available here soon'),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              leading: FaIcon(FontAwesomeIcons.signOutAlt),
              title: Text('Logout',style: TextStyle(fontWeight: FontWeight.w600),),
              subtitle: Text('Logout from all saved accounts',style: TextStyle(fontSize: 12),),
              onTap: () async{
                await Preferences.clearLogin();
                Navigator.pushReplacement(context,MaterialPageRoute(
                    builder: (context)=> ConfigurationsScreen(),
                ));
              },
            ),
          )
        ],
      ),
    );
  }
}
