import 'package:fluttertoast/fluttertoast.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/models/rss.dart';
import 'package:rutorrentflutter/services/functional_services/api_service.dart';
import 'package:stacked/stacked.dart';

class RSSLabelTileViewModel extends BaseViewModel {
  ApiService _apiService = locator<ApiService>();

  bool isLongPressed = false;

  addTorrent(String url) {
    _apiService.addTorrent(url);
  }

  void removeRSS(RSSLabel rssLabel) async {
    Fluttertoast.showToast(msg: 'Removing');
    await _apiService.removeRSS(rssLabel.hash);
  }
}
