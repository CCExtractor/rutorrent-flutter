import 'package:flutter_test/flutter_test.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/models/disk_file.dart';
import 'package:rutorrentflutter/models/disk_space.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/history_item.dart';
import 'package:rutorrentflutter/models/rss.dart';
import 'package:rutorrentflutter/models/rss_filter.dart';
import 'package:rutorrentflutter/models/torrent.dart';

import '../setup/test_data.dart';
import '../setup/test_helpers.dart';

void main() {
  group('ApiServiceTest -', () {
    group('Update History -', () {
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
        expect(general.historyItems[0], isA<HistoryItem>());

        //Set back to dynamic
        CustomizableDateTime.customTime = null;
      });
    });
    group('Update Disk Space -', () {
      test(
          'When update disk space call made, should return total and free space',
          () async {
        final api = getAndRegisterApiServiceMock();
        GeneralFeatures general = GeneralFeatures();

        await ApiRequests.updateDiskSpace(api, general, MockBuildContext());

        expect((general.diskSpace as DiskSpace).total, greaterThan(1));
        expect((general.diskSpace as DiskSpace).free, greaterThan(0));
      });
    });
    group('Parse Torrent Data -', () {
      test('When response body passed, should return list of torrents',
          () async {
        final api = getAndRegisterApiServiceMock();
        GeneralFeatures general = GeneralFeatures();

        final result = ApiRequests.parseTorrentsData(
            TestData.httpRpcPluginJSONResponse, general, api);

        expect(result[0], isA<Torrent>());
      });
    });
    group('Get Torrent List From All Accounts -', () {
      test('When called, should yeild list of torrents as a stream', () async {
        final api = getAndRegisterApiServiceMock();
        GeneralFeatures general = GeneralFeatures();

        final result = ApiRequests.getAllAccountsTorrentList([api], general);
        final stream = result?.asBroadcastStream();

        expectLater(stream, emits(isA<List<Torrent>>()));
        expectLater(stream, emits(isNotNull));
        // await result.;
      });
    });
    group('Get Torrent List From Single Account -', () {
      test('When called, should yeild list of torrents as a stream', () async {
        final api = getAndRegisterApiServiceMock();
        GeneralFeatures general = GeneralFeatures();

        final result = ApiRequests.getTorrentList(api, general);
        final stream = result?.asBroadcastStream();

        expectLater(stream, emits(isA<List<Torrent>>()));
        expectLater(stream, emits(isNotNull));
      });
    });
    group('Get RSS Details -', () {
      test(
          'When RSS network call made, should return boolean stating whether data is available',
          () async {
        final api = getAndRegisterApiServiceMock();
        RSSItem rssItem = TestData.rssItem;

        final result = await ApiRequests.getRSSDetails(
            api, rssItem, TestData.torrent.hash);

        expect(result, isNotNull);
        expect(result, isA<bool>());
      });
    });
    group('Get RSS Filters -', () {
      test('When RSS network call made, should return list of RSS filters',
          () async {
        final api = getAndRegisterApiServiceMock();
        final result = await ApiRequests.getRSSFilters(api);

        expect(result, isNotNull);
        expect(result, isNotEmpty);
        expect(result[0], isA<RSSFilter>());
      });
    });
    group('Get History -', () {
      test(
          'When History network call made, should return list of History Items',
          () async {
        final api = getAndRegisterApiServiceMock();
        // TestData.timestamp = TestData.getConstantTimeStamp();
        //Set static DateTime for test
        CustomizableDateTime.customTime = DateTime.parse("1969-07-20 20:18:04");

        final result = await ApiRequests.getHistory(api, lastHours: 3);

        expect(result, isNotNull);
        expect(result, isNotEmpty);
        expect(result[0], isA<HistoryItem>());

        //Set back to dynamic
        CustomizableDateTime.customTime = null;
      });
    });
    group('Get Disk Files -', () {
      test('When Disk File network call made, should return list of Disk Files',
          () async {
        final api = getAndRegisterApiServiceMock();

        final result = await ApiRequests.getDiskFiles(api, TestData.path);

        expect(result, isNotNull);
        expect(result, isNotEmpty);
        expect(result[0], isA<DiskFile>());
      });
    });
  });
}
