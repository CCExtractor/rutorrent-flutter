import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/models/history_item.dart';
import 'package:rutorrentflutter/services/functional_services/api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HistoryViewModel extends FutureViewModel {

  ApiService _apiService = locator<ApiService>();
  NavigationService _navigationService = locator<NavigationService>();

  List<HistoryItem> items = [];

  init() async {
    setBusy(true);
    items = await _apiService.getHistory();
    setBusy(false);
  }

  @override
  Future futureToRun() => init();

  loadHistoryItems({int? lastHrs}) async {
    setBusy(true);
    items = await _apiService.getHistory();
    setBusy(false);
  }

  void removeHistoryItem(String hashValue) {
    _apiService.removeHistoryItem(hashValue);
    _navigationService.popRepeated(1);
  }

  List<String> choices = [
    'Show Last 24 Hours',
    'Show Last 36 Hours',
    'Show Last 48 Hours'
  ];


}