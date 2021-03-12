import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'test_data.dart';

/// This file contains setup functions that are created to remove duplicate
/// code from tests and make them more readable

class ApiServiceMock extends Mock implements Api {}

class IOClientMock extends Mock implements http.IOClient {}

class MockBuildContext extends Mock implements BuildContext {}

IOClientMock getAndRegisterIOClientMock() {
  ApiServiceMock api = getAndRegisterApiServiceMock();
  IOClientMock client = IOClientMock();
  final updateHistoryTimeStamp = TestData.getUpdateHistoryConstantTimeStamp();
  final getHistoryConstantTimeStamp = TestData.getGetHistoryConstantTimeStamp();

  /// Simulating network call to obtain updated history
  when(client.post(Uri.parse(TestData.historyPluginUrl),
          headers: api.getAuthHeader(),
          body: {'cmd': 'get', 'mark': updateHistoryTimeStamp}))
      .thenAnswer(
          (_) async => Response(TestData.updateHistoryJSONReponse, 200));

  /// Simulating network call to obtain disk space
  when(client.get(Uri.parse(TestData.diskSpacePluginUrl),
          headers: api.getAuthHeader()))
      .thenAnswer(
          (_) async => Response(TestData.updateDiskSpaceJSONResponse, 200));

  /// Simulating network call to obtain torrents from all accounts
  when(client.post(
    Uri.parse(TestData.httpRpcPluginUrl),
    headers: api.getAuthHeader(),
    body: {'mode': 'list'},
  )).thenAnswer((_) async => Response(TestData.httpRpcPluginJSONResponse, 200));

  /// Simulating network call to obtain RSS Item Details
  when(client.post(Uri.parse(TestData.rssPluginUrl),
      headers: api.getAuthHeader(),
      body: {
        'mode': 'getdesc',
        'href': TestData.rssItem.url,
        'rss': TestData.torrent.hash,
      })).thenAnswer((_) async => Response(TestData.rssPluginXMLResponse, 200));

  /// Simulating network call to obtain RSS Filters
  when(client
      .post(Uri.parse(TestData.rssPluginUrl),
          headers: api.getAuthHeader(),
          body: {'mode': 'getfilters'})).thenAnswer(
      (_) async => Response(json.encode([TestData.rssFilter.toJson()]), 200));

  /// Simulating network call to obtain history first time
  when(client.post(Uri.parse(TestData.historyPluginUrl),
          headers: api.getAuthHeader(),
          body: {'cmd': 'get', 'mark': getHistoryConstantTimeStamp}))
      .thenAnswer(
          (_) async => Response(TestData.updateHistoryJSONReponse, 200));

  /// Simulating network call to obtain Disk Files
  when(client.post(Uri.parse(TestData.explorerPluginUrl),
      headers: api.getAuthHeader(),
      body: {
        'cmd': 'get',
        'src': TestData.path,
      })).thenAnswer(
      (_) async => Response(TestData.explorerPluginJSONResponse, 200));

  return client;
}

ApiServiceMock getAndRegisterApiServiceMock() {
  ApiServiceMock apiMock = ApiServiceMock();
  when(apiMock.httpRpcPluginUrl)
      .thenAnswer((realInvocation) => TestData.httpRpcPluginUrl);
  when(apiMock.historyPluginUrl)
      .thenAnswer((realInvocation) => TestData.historyPluginUrl);
  when(apiMock.diskSpacePluginUrl)
      .thenAnswer((realInvocation) => TestData.diskSpacePluginUrl);
  when(apiMock.addTorrentPluginUrl)
      .thenAnswer((realInvocation) => TestData.addTorrentPluginUrl);
  when(apiMock.rssPluginUrl)
      .thenAnswer((realInvocation) => TestData.rssPluginUrl);
  when(apiMock.explorerPluginUrl)
      .thenAnswer((realInvocation) => TestData.explorerPluginUrl);
  when(apiMock.ioClient)
      .thenAnswer((realInvocation) => getAndRegisterIOClientMock());
  return apiMock;
}
