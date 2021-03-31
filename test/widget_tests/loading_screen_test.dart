import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rutorrentflutter/main.dart';

void main() {
  testWidgets('Loading Screen Tests', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Finds the splash screen
    final splashScreenFinder = find.byType(SplashScreen);

    // Expects the splashscreen should be rendered.
    expect(splashScreenFinder, findsOneWidget);
  });
}
