import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/models/history_item.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/screens/history_screen.dart';
import 'package:rutorrentflutter/components/loading_shimmer.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../setup/test_helpers.dart';
import '../setup/test_data.dart';

void main() {
  group('History Screen Test -', () {
    NavigatorObserver mockObserver;
    ApiServiceMock mockValue;
    List<HistoryItem> _items;

    setUp(() async {
      mockObserver = NavigatorObserverMock();
      SharedPreferences.setMockInitialValues({});
      mockValue = ApiServiceMock();
      _items = TestData.historyItems;
    });

    Future<void> _pumpHistoryView(WidgetTester tester) async {
      await tester.pumpWidget(Provider<Api>.value(
          value: mockValue,
          child: MultiProvider(
              providers: [
                ChangeNotifierProvider<Mode>(create: (context) => Mode()),
              ],
              child: MaterialApp(
                home: HistoryScreen(items: _items),
                navigatorObservers: [mockObserver],
              ))));

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds History Widgets', (WidgetTester tester) async {
      await _pumpHistoryView(tester);
      await tester.pumpAndSettle();

      // expect(find.byType(ListTile), findsOneWidget);
    });
  });
}
