import 'package:flutter_test/flutter_test.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/models/disk_space.dart';
import 'package:rutorrentflutter/models/general_features.dart';

import '../setup/test_data.dart';
import '../setup/test_helpers.dart';

void main() {
  group('ApiServiceTest -', () {
    group('Update history -', () {
      test(
          'When update history network call made, should populate history items',
          () async {
        final api = getAndRegisterApiServiceMock();
        GeneralFeatures general = GeneralFeatures();

        //Set static DateTime for test
        CustomizableDateTime.customTime = DateTime.parse("1969-07-20 20:18:04");

        //Mock Api Call
        await ApiRequests.updateHistory(api, general, MockBuildContext());

        //Expect [general.historyItems] to not be null
        expect(general.historyItems, isNotNull);

        //Expect [general.historyItems.runtimeType] to be same
        expect(general.historyItems[0].runtimeType,
            TestData.historyItems[0].runtimeType);

        //Set back to dynamic
        CustomizableDateTime.customTime = null;
      });
    });
    group('Update disk space -', () {
      test('Checks if update disk space responds correctly', () async {
        final api = getAndRegisterApiServiceMock();
        GeneralFeatures general = GeneralFeatures();

        await ApiRequests.updateDiskSpace(api, general, MockBuildContext());

        expect((general.diskSpace as DiskSpace).total, greaterThan(1));
        expect((general.diskSpace as DiskSpace).free, greaterThan(0));
      });
    });
  });
}
