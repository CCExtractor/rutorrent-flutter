import 'package:flutter/foundation.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/models/history_item.dart';
import 'package:rutorrentflutter/services/api/i_api_service.dart';
import 'package:rutorrentflutter/services/state_services/history_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HistoryViewModel extends FutureViewModel {
  IApiService _apiService = locator<IApiService>();
  NavigationService _navigationService = locator<NavigationService>();
  HistoryService _historyService = locator<HistoryService>();

  List<HistoryItem> items = [];
  String selectedChoice = 'All';

  ValueNotifier<List<HistoryItem>> get torrentHistoryDisplayList =>
      _historyService.displayTorrentHistoryList;

  init() async {
    setBusy(true);
    _apiService.updateHistory();
    setBusy(false);
  }

  @override
  Future futureToRun() => init();

  loadHistoryItems({int? lastHrs}) async {
    setBusy(true);
    await _historyService.refreshTorrentHistoryList(lastHours: lastHrs);
    setBusy(false);
  }

  void removeHistoryItem(String hashValue) async {
    _apiService.removeHistoryItem(hashValue);
    _navigationService.popRepeated(1);
    // Giving time for server to update list
    await Future.delayed(Duration(milliseconds: 500));
    refreshHistoryList();
  }

  final List<String> choices = [
    'All',
    'Show Last 24 Hours',
    'Show Last 36 Hours',
    'Show Last 48 Hours',
  ];

  refreshHistoryList() async {
    setBusy(true);
    selectedChoice == 'All'
        ? loadHistoryItems()
        : loadHistoryItems(lastHrs: int.parse(selectedChoice.split(' ')[2]));
    setBusy(false);
  }
}
