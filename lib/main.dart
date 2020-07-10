import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/constants.dart' as Constants;
import 'package:rutorrentflutter/screens/configurations_screen.dart';

import 'models/general_features.dart';
import 'models/mode.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<Mode>(create: (context) => Mode()),
    ChangeNotifierProvider<GeneralFeatures>(
      create: (context) => GeneralFeatures(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ruTorrent Mobile',
      theme: ThemeData.light().copyWith(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Constants.kIndigo,
        ),
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'SFUIDisplay',
            ),
        primaryColor: Colors.grey[300],
      ),
      darkTheme: ThemeData.dark().copyWith(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Constants.kIndigo,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'SFUIDisplay',
            ),
      ),
      themeMode: Provider.of<Mode>(context).isLightMode
          ? ThemeMode.light
          : ThemeMode.dark,
      home: ConfigurationsScreen(),
    );
  }
}
