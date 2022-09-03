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

  @override
  post(Uri? url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {

    switch (url.toString()) {
      case (TestData.historyPluginUrl):
        return Response(TestData.updateHistoryJSONReponse, 200);

      case (TestData.httpRpcPluginUrl):
        if (body.toString() == TestData.getAllAccountsTorrentListBody.toString())
            return Response(TestData.getAllAccountsTorrentListResponse, 200);
            
        else if (body.toString() == TestData.getFilesBody.toString())
          return Response(jsonEncode(TestData.getFilesResponse), 200);

        else if (body.toString() == TestData.getTrackersBody.toString())
          return Response(jsonEncode(TestData.getTrackersResponse), 200);

        return Response("", 404);

      case (TestData.explorerPluginUrl):
        if(body.toString() == TestData.getDiskFilesBody.toString())
          return Response(TestData.getDiskFilesResponse.toString(), 200);
          
        return Response("", 404);

      case (TestData.rssPluginUrl):
        if(body == null)
          return Response(jsonEncode(TestData.loadRSSResponse), 200);

        else if(body.toString() == TestData.getRSSFiltersBody.toString())
          return Response(jsonEncode(TestData.getRSSFiltersResponse), 200);

        return Response("",404);

      case "":
        return Response("", 200);

      default:
        return Response("URL not found", 404);
    }
  }

  @override
  Future<Response> get(Uri? url, {Map<String, String>? headers}) async {

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
