import 'package:flutter_test/flutter_test.dart';
import 'package:rutorrentflutter/models/disk_file.dart';
import 'package:rutorrentflutter/models/rss.dart';
import 'package:rutorrentflutter/models/torrent_file.dart';
import 'package:rutorrentflutter/services/api/prod_api_service.dart';
import 'package:rutorrentflutter/services/functional_services/disk_space_service.dart';
import 'package:rutorrentflutter/services/state_services/disk_file_service.dart';
import 'package:rutorrentflutter/services/state_services/history_service.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';

import '../helpers/test_data.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('ApiServiceTests -', () {
    group('StartUp -', () {
      setUp(() => registerServices());
      tearDown(() => unregisterServices());

      group('Get History -', () {
        test(
            'When get history network call made, should populate history items',
            () async {
          HistoryService historyservice =
              getAndRegisterHistoryService(mock: false);
          ProdApiService api = ProdApiService();

          //Mock Api Call
          await api.getHistory();

          expect(historyservice.historyList, isNotNull);

          //Expect [historyservice.historyList.runtimeType] to be same
          expect(historyservice.historyList[0].runtimeType,
              TestData.historyItems[0].runtimeType);
        });
      });

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

      group('Update Disk Space -', () {
        test(
            'When update diskspace call made, should populate diskspace object',
            () async {
          DiskSpaceService _diskSpaceService =
              getAndRegisterDiskSpaceService(mock: false);
          ProdApiService api = ProdApiService();

          //Mock Api Call
          await api.updateDiskSpace();

          expect(_diskSpaceService.diskSpace, isNotNull);

          bool isTotalUpdated = _diskSpaceService.diskSpace.total != -1;
          expect(isTotalUpdated, true);
        });
      });
      group('Get All Accounts Torrent List -', () {
        test(
            'When update all accounts torrent list call made, should populate torrent list',
            () async {
          TorrentService _torrentService =
              getAndRegisterTorrentService(mock: false);
          ProdApiService api = ProdApiService();

          //Mock Api Call
          await api.getAllAccountsTorrentList().listen((event) {}).cancel();

          expect(_torrentService.torrentsList.value, isNotEmpty);
          expect(_torrentService.torrentsList.value[0].runtimeType,
              TestData.torrent.runtimeType);
        });
      });
      group('Get Disk Files -', () {
        test('When get disk files call made, should populate disk file list',
            () async {
          DiskFileService _diskFileService =
              getAndRegisterDiskFileService(mock: false);
          ProdApiService api = ProdApiService();

          //Mock Api Call
          await api.getDiskFiles("/");

          expect(_diskFileService.diskFileList.value, isNotEmpty);
          expect(_diskFileService.diskFileList.value[0].runtimeType,
              DiskFile().runtimeType);
        });
      });
      group('Get Files -', () {
        test(
            'When files from Torrent call made, should return torrent file list',
            () async {
          ProdApiService api = ProdApiService();

          //Mock Api Call
          var response = await api.getFiles(TestData.hash);

          expect(response, isNotEmpty);
          expect(
              response.runtimeType, [TorrentFile("", "", "", "")].runtimeType);
        });
      });
      group('Get Trackers -', () {
        test('When getTrackers call made, should return trackers list',
            () async {
          ProdApiService api = ProdApiService();

          //Mock Api Call
          var response = await api.getTrackers(TestData.hash);

          expect(response, isNotEmpty);
          expect(response.runtimeType, [""].runtimeType);
        });
      });
      group('Load RSS -', () {
        test('When loadRSS call made, should return RSS Label list', () async {
          ProdApiService api = ProdApiService();

          //Mock Api Call
          var response = await api.loadRSS();

          expect(response, isNotEmpty);
          expect(
              response.runtimeType, [RSSLabel(TestData.hash, "")].runtimeType);
        });
      });
      group('Get RSS Filters -', () {
        test('When loadRSS call made, should return RSS Label list', () async {
          ProdApiService api = ProdApiService();

          //Mock Api Call
          var response = await api.getRSSFilters();

          expect(response, isNotEmpty);
          expect(response.runtimeType, [TestData.rssFilter].runtimeType);
        });
      });
    });
  });
}
