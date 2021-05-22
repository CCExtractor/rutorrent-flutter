import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/models/rss_filter.dart';
import 'package:rutorrentflutter/services/functional_services/api_service.dart';
import 'package:stacked/stacked.dart';

class RSSFiltersViewModel extends FutureViewModel {

  ApiService _apiService = locator<ApiService>();

  List<RSSFilter> rssFilters = [];

  init() async {
    setBusy(true);
    rssFilters = await _apiService.getRSSFilters();
    setBusy(false);
  }

  @override
  Future futureToRun() => init();
}