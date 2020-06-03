import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:rutorrentflutter/app/locator.dart';
import 'package:rutorrentflutter/ui/shared/shared_styles.dart';
import 'package:stacked_services/stacked_services.dart';
// import 'package:rutorrentflutter/utilities/constants.dart';
// import 'package:rutorrentflutter/screens/loading_screen.dart';
// import 'api/api_conf.dart';
// import 'models/general_features.dart';
// import 'models/mode.dart';
// import 'models/settings.dart';


void main() {
  // setupLocator();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ruTorrent Mobile',
      theme: ThemeData.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'SFUIDisplay',
            ),
        primaryColor: kBluePrimaryLT,
        accentColor: kIndigoSecondaryLT,
        disabledColor: kGreyLT,
        toggleableActiveColor: kIndigoSecondaryLT,
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kBackgroundDT,
        canvasColor: kBackgroundDT,
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'SFUIDisplay',
            ),
        primaryColor: kPrimaryDT,
        accentColor: kSecondaryDT,
        disabledColor: kGreyDT,
        toggleableActiveColor: kSecondaryDT,
      ),
      // themeMode: Provider.of<Mode>(context).isLightMode
      //     ? ThemeMode.light
      //     : ThemeMode.dark,
      home: null,
      // navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}