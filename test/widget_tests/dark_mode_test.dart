import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/models/settings.dart';
import 'package:rutorrentflutter/screens/main_screen.dart';

import '../setup/test_helpers.dart';

void main() {
  testWidgets('Dark mode tests', (WidgetTester tester) async {
    await tester.runAsync(() async {
      GeneralFeatures general = GeneralFeatures();
      Mode mode = Mode();
      final api = getAndRegisterApiServiceMock();

      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: general,
          ),
          ChangeNotifierProvider.value(
            value: mode,
          ),
          Provider<Api>(create: (context) => api),
          ChangeNotifierProvider<Settings>(create: (context) => Settings()),
        ],
        child: MaterialApp(
          home: MainScreen(),
        ),
      ));

      // Finds the theme toggle button.
      final toggleButton = find.byType(FaIcon);
      expect(toggleButton, findsOneWidget);

      // Light mode by default.
      expect(mode.isLightMode, true);

      // Taps on the button.
      await tester.tap(toggleButton);

      // Theme should be changed to dark mode.
      expect(mode.isDarkMode, true);

      // Taps on the button.
      await tester.tap(toggleButton);

      // Theme should be changed back to light mode.
      expect(mode.isLightMode, true);
    });
  });
}
