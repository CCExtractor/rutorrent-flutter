// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/models/rss.dart';
import 'package:rutorrentflutter/services/api/i_api_service.dart';
import 'package:stacked/stacked.dart';

final log = getLogger("RSSFeedViewModel");

class RSSFeedViewModel extends FutureViewModel {
  IApiService _apiService = locator<IApiService>();

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
