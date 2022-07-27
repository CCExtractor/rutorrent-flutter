// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/models/rss_filter.dart';
import 'package:rutorrentflutter/services/api/i_api_service.dart';
import 'package:stacked/stacked.dart';

class RSSFiltersViewModel extends FutureViewModel {
  IApiService _apiService = locator<IApiService>();

  List<RSSFilter> rssFilters = [];

  init() async {
    setBusy(true);
    rssFilters = await _apiService.getRSSFilters();
    setBusy(false);
  }

  @override
  Future futureToRun() => init();
}
