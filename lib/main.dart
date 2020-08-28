import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/utilities/constants.dart';
import 'package:rutorrentflutter/screens/loading_screen.dart';
import 'api/api_conf.dart';
import 'models/general_features.dart';
import 'models/mode.dart';
import 'models/settings.dart';

void main() {
  runApp(MultiProvider(providers: [

    /// Providing at the top of the widget tree to grant access to the whole app

    Provider<Api>(create: (context) => Api()),
    ChangeNotifierProvider<Mode>(create: (context) => Mode()),
    ChangeNotifierProvider<Settings>(create: (context) => Settings()),
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
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
            color: kSlightGrey
        ),
        primaryTextTheme: TextTheme(
          headline6: TextStyle(color: Colors.black)
        ),
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'SFUIDisplay',
        ),
        primaryColor: kBluePrimaryLT,
        accentColor: kIndigoSecondaryLT,
        primaryColorDark: kBluePrimaryLT,
        primaryColorLight: kIndigoSecondaryLT,
        disabledColor: kGreyLT,
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kBackgroundDT,
        appBarTheme: AppBarTheme(
          color: kGreyDT,
        ),
        canvasColor: kBackgroundDT,
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'SFUIDisplay',
        ),
        primaryColor: kPrimaryDT,
        accentColor: kSecondaryDT,
        primaryColorDark: kPrimaryDT,
        primaryColorLight: kSecondaryDT,
        disabledColor: kGreyDT,
      ),
      themeMode: Provider.of<Mode>(context).isLightMode
          ? ThemeMode.light
          : ThemeMode.dark,
      home: LoadingScreen(),
    );
  }
}
