import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'test_data.dart';
import 'test_helpers.mocks.dart';

Logger log = getLogger("MockIOClientExtention");

/// The [MockIOClientExtention] class helps in mocking API calls
/// and returning the proper response.
class MockIOClientExtention extends MockIOClient {
  post(Uri? url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    log.e(url.toString());
    log.e(TestData.historyPluginUrl);
    log.e(TestData.diskSpacePluginUrl);
    log.e(headers);
    log.e(body);

    switch (url.toString()) {
      case (TestData.historyPluginUrl):
        return Response(TestData.updateHistoryJSONReponse, 200);

      case (TestData.httpRpcPluginUrl):
        log.e(body, TestData.getAllAccountsTorrentListBody);
        log.e(body.toString() ==
            TestData.getAllAccountsTorrentListBody.toString());
        return body.toString() ==
                TestData.getAllAccountsTorrentListBody.toString()
            ? Response(TestData.getAllAccountsTorrentListResponse, 200)
            : Response("", 404);

      case "":
        return Response("", 200);

      default:
        return Response("URL not found", 404);
    }
  }

  @override
  Future<Response> get(Uri? url, {Map<String, String>? headers}) async {
    log.e(url.toString());
    log.e(TestData.historyPluginUrl);
    log.e(TestData.diskSpacePluginUrl);
    log.e(headers);

    switch (url.toString()) {
      case (TestData.diskSpacePluginUrl):
        return Response(TestData.updateDiskSpaceResponse, 200);

      case "":
        return Response("", 200);

      default:
        return Response("URL not found", 404);
    }
  }
}
