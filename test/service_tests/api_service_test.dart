import 'package:flutter_test/flutter_test.dart';
import 'package:rutorrentflutter/services/api/prod_api_service.dart';
import 'package:rutorrentflutter/services/state_services/history_service.dart';

import '../helpers/test_data.dart';
import '../helpers/test_helpers.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('ApiServiceTests -', () {
    group('StartUp -', () {
      setUp(() => registerServices());
      tearDown(() => unregisterServices());

      group('Update History -', () {
        test(
            'When update history network call made, should populate history items',
            () async {
          HistoryService historyservice =
              getAndRegisterHistoryService(mock: false);
          ProdApiService api = ProdApiService();

          //Mock Api Call
          await api.updateHistory();

          expect(historyservice.historyList, isNotNull);

          //Expect [historyservice.historyList.runtimeType] to be same
          expect(historyservice.historyList[0].runtimeType,
              TestData.historyItems[0].runtimeType);
        });
      });
    });
  });
}
