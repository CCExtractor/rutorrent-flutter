import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/models/rss.dart';
import 'package:rutorrentflutter/services/functional_services/api_service.dart';
import 'package:stacked/stacked.dart';

class RSSDetailSheetViewModel extends BaseViewModel {

  ApiService _apiService = locator<ApiService>();

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