// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.router.dart';
import 'package:rutorrentflutter/services/functional_services/notification_service.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';
import 'package:rutorrentflutter/theme/app_state_notifier.dart';
import 'package:rutorrentflutter/theme/app_theme.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/bottom_sheets/bottom_sheet_setup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

void main() async {
  //Zone guarded for Firebase Crashlytics to catch errors
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    //Setting up Hive DB
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init(appDir.path);
    await Hive.openBox('DB');
    //To work in development environment, simply change the environment to Environment.dev below
    await setupLocator(environment: Environment.dev);
    //Setting custom Bottom Sheet
    setUpBottomSheetUi();
    //Setting up Services
    await locator<NotificationService>().init();
    await locator<UserPreferencesService>().init();
    //Setting up Firebase
    // await dotenv.load(fileName: ".env");
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );

    // Make sure to comment out this line in development to see Errors
    // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    runApp(MyApp());
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppStateNotifier>.reactive(
      builder: (context, model, child) => MaterialApp(
        title: 'ruTorrent Mobile',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode:
            AppStateNotifier.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
        navigatorKey: StackedService.navigatorKey,
        onGenerateRoute: StackedRouter().onGenerateRoute,
      ),
      viewModelBuilder: () => locator<AppStateNotifier>(),
    );
  }
}
