import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/screens/loading_screen.dart';
import 'api/api_conf.dart';
import 'models/general_features.dart';
import 'models/mode.dart';
import 'models/settings.dart';
import 'utilities/themes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        /// Providing at the top of the widget tree to grant access to the whole app
        Provider<Api>(create: (context) => Api()),
        ChangeNotifierProvider<Mode>(create: (context) => Mode()),
        ChangeNotifierProvider<Settings>(create: (context) => Settings()),
        ChangeNotifierProvider<GeneralFeatures>(
          create: (context) => GeneralFeatures(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ruTorrent Mobile',
      theme: Themes.lightTheme(context),
      darkTheme: Themes.darkTheme(context),
      themeMode: Provider.of<Mode>(context).isLightMode
          ? ThemeMode.light
          : ThemeMode.dark,
      home: LoadingScreen(),
    );
  }
}
