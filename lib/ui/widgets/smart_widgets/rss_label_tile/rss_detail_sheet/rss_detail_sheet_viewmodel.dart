// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/models/rss.dart';
import 'package:rutorrentflutter/services/api/i_api_service.dart';
import 'package:stacked/stacked.dart';

class RSSDetailSheetViewModel extends BaseViewModel {
  IApiService _apiService = locator<IApiService>();

  bool dataAvailable = false;

  addTorrent(String url) {
    _apiService.addTorrent(url);
  }

  init(RSSItem rssItem, String labelHash) async {
    setBusy(true);
    dataAvailable = await _apiService.getRSSDetails(rssItem, labelHash);
    setBusy(false);
  }
}
