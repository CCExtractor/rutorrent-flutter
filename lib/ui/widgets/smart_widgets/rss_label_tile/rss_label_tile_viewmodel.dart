// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:fluttertoast/fluttertoast.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/models/rss.dart';
import 'package:rutorrentflutter/services/api/i_api_service.dart';
import 'package:stacked/stacked.dart';

class RSSLabelTileViewModel extends BaseViewModel {
  IApiService _apiService = locator<IApiService>();

  bool isLongPressed = false;

  addTorrent(String url) {
    _apiService.addTorrent(url);
  }

  void removeRSS(RSSLabel rssLabel) async {
    Fluttertoast.showToast(msg: 'Removing');
    await _apiService.removeRSS(rssLabel.hash);
  }
}
