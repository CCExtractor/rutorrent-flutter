import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/utilities/constants.dart';
import 'package:rutorrentflutter/screens/loading_screen.dart';
import 'api/api_conf.dart';
import 'models/general_features.dart';
import 'models/mode.dart';

void main() {
  runApp(MultiProvider(providers: [
    Provider<Api>(create: (context) => Api()),
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
        primaryColor: kSlightGrey,
        accentColor: kBlue,
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'SFUIDisplay',
            ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        accentColor: kIndigo,
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'SFUIDisplay',
            ),
      ),
      themeMode: Provider.of<Mode>(context).isLightMode
          ? ThemeMode.light
          : ThemeMode.dark,
      home: LoadingScreen(),
    );
  }
}
