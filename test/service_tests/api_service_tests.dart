import 'package:flutter_test/flutter_test.dart';
import 'package:rutorrentflutter/models/history_item.dart';
import 'package:rutorrentflutter/services/services_info.dart';
import 'package:rutorrentflutter/services/state_services/history_service.dart';

import '../helpers/test_helpers.dart';

void main() {
 group('ApiServiceTests -', (){
  setUp(() => registerServices());
  tearDown(() => unregisterServices());

  group('Update History -', () {
   test('When update history network call made, should populate history items', () async {
        final api = getAndRegisterProdApiServiceMock();
        final HistoryService history = getAndRegisterHistoryServiceMock();

        //Set static DateTime for test
        CustomizableDateTime.customTime = ServicesInfo.testDate;

        //Mock Api Call
        await api.updateHistory();

        //Expect [general.historyItems] to not be null
        expect(history.torrentsHistoryList.value, isNotNull);

        //Expect [general.historyItems.runtimeType] to be same
        expect(history.torrentsHistoryList.value[0], isA<HistoryItem>());

        //Set back to dynamic
        CustomizableDateTime.customTime = DateTime.now();
   });
  });

  

 });
}