import 'dart:io' as io;
import 'package:http/io_client.dart';

/// This class serves two purposes.
/// 1. Decoupling the HTTPClient from the API Service.
/// 2. Making it possible to mock API Calls in Unit Tests.
class HttpIOClient {
  getIOClient() {
    /// Url with some issue with their SSL certificates can be trusted explicitly with this
    bool trustSelfSigned = true;
    io.HttpClient httpClient = io.HttpClient()
      ..badCertificateCallback =
          ((io.X509Certificate cert, String host, int port) => trustSelfSigned);

    IOClient _ioClient = new IOClient(httpClient);
    return _ioClient;
  }
}
