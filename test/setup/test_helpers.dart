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
  final timestamp = TestData.getConstantTimeStamp();

  when(client.post(
    Uri.parse(TestData.httpRpcPluginUrl),
    headers: api.getAuthHeader(),
    body: {'mode': 'list'},
  )).thenAnswer((_) async => Response(TestData.httpRpcPluginJSONResponse, 200));

  when(client.post(Uri.parse(TestData.historyPluginUrl),
          headers: api.getAuthHeader(),
          body: {'cmd': 'get', 'mark': timestamp}))
      .thenAnswer(
          (_) async => Response(TestData.updateHistoryJSONReponse, 200));

  when(client.get(Uri.parse(TestData.diskSpacePluginUrl),
          headers: api.getAuthHeader()))
      .thenAnswer(
          (_) async => Response(TestData.updateDiskSpaceJSONResponse, 200));

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

  when(apiMock.ioClient)
      .thenAnswer((realInvocation) => getAndRegisterIOClientMock());
  return apiMock;
}
