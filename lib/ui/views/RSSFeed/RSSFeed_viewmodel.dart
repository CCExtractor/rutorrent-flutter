import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/models/rss.dart';
import 'package:rutorrentflutter/services/functional_services/api_service.dart';
import 'package:stacked/stacked.dart';

final log = getLogger("RSSFeedViewModel");

class RSSFeedViewModel extends FutureViewModel {
  ApiService _apiService = locator<ApiService>();

  List<RSSLabel> rssLabelsList = [];

  init() async {
    setBusy(true);
    rssLabelsList = await _apiService.loadRSS();
    setBusy(false);
  }

  @override
  Future futureToRun() => init();

  getTotalFeeds() {
    int feeds = 0;
    for (var rss in rssLabelsList) feeds += rss.items.length;
    return feeds;
  }
}
