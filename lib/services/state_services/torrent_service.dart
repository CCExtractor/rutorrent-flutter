import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:rutorrentflutter/services/api/i_api_service.dart';
import 'package:rutorrentflutter/services/functional_services/shared_preferences_service.dart';
import 'package:rutorrentflutter/services/state_services/history_service.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';

Logger log = getLogger("TorrentService");

///[Service] for persisting torrent state
class TorrentService extends ChangeNotifier {
  UserPreferencesService? _userPreferencesService =
      locator<UserPreferencesService>();
  SharedPreferencesService? _sharedPreferencesService =
      locator<SharedPreferencesService>();
  HistoryService _historyService = locator<HistoryService>();

  ValueNotifier<List<String>> _listOfLabels =
      new ValueNotifier(new List<String>.empty());
  ValueNotifier<List<Torrent>> _activeDownloads =
      new ValueNotifier(new List<Torrent>.empty());
  ValueNotifier<List<Torrent>> _torrentsList =
      new ValueNotifier(new List<Torrent>.empty());
  ValueNotifier<List<Torrent>> _torrentsDisplayList =
      new ValueNotifier(new List<Torrent>.empty());

  String? _selectedLabel = "";
  bool _isLabelSelected = false;
  Filter _selectedFilter = Filter.All;
  Sort _sortPreference = Sort.none;

  get isLabelSelected => _isLabelSelected;
  get selectedLabel => _selectedLabel;
  get selectedFilter => _selectedFilter;
  get sortPreference => _sortPreference;

  ValueNotifier<List<String?>> get listOfLabels => _listOfLabels;
  ValueNotifier<List<Torrent>> get activeDownloads => _activeDownloads;
  ValueNotifier<List<Torrent>> get torrentsList => _torrentsList;
  ValueNotifier<List<Torrent>> get displayTorrentList => _torrentsDisplayList;

  setListOfLabels(List<String> labels) {
    if (_userPreferencesService!.showAllAccounts) {
      _listOfLabels.value = (_listOfLabels.value + labels).toSet().toList();
    } else {
      _torrentsList.value.isEmpty
          ? _listOfLabels.value = []
          : _listOfLabels.value = labels;
    }
  }

  changeLabel(String label) {
    // If already selected label tapped
    // Disable all label selection
    if (_selectedLabel == label) {
      _selectedLabel = "";
      _isLabelSelected = false;
      updateTorrentDisplayList();
      _selectedFilter = Filter.All;
      _listOfLabels.notifyListeners();
    } else {
      _selectedFilter = Filter.All;
      _isLabelSelected = true;
      _selectedLabel = label;
      _listOfLabels.notifyListeners();
      updateTorrentDisplayList();
    }
  }

  changeFilter(Filter filter) {
    _isLabelSelected = false;
    _selectedFilter = filter;
    updateTorrentDisplayList();
  }

  setActiveDownloads(List<Torrent> list) => _activeDownloads.value = list;
  setTorrentList(List<Torrent> list) {
    _torrentsList.value = list;
    updateTorrentDisplayList();
  }

  setSortPreference(Sort newPreference) {
    _sortPreference = newPreference;
    _sharedPreferencesService!.DB.put("sortPreference", newPreference.index);
  }

  /// Updates display list of [Torrent]s Display List
  updateTorrentDisplayList() {
    List<Torrent> displayList = torrentsList.value;
    //Sorting: sorting data on basis of sortPreference
    displayList = _sortList(displayList, sortPreference)!;

    //Filtering: filtering list on basis of selected filter
    displayList = _filterList(displayList, selectedFilter)!;

    //If Label is selected, filtering it using the label
    if (isLabelSelected) {
      displayList = _filterListUsingLabel(displayList, selectedLabel);
    }

    String? searchText = _userPreferencesService?.searchTextController.text;
    if (searchText != null || (searchText?.isNotEmpty ?? false)) {
      //Searching : showing list on basis of searched text
      displayList = displayList
          .where((element) =>
              element.name.toLowerCase().contains(searchText!.toLowerCase()))
          .toList();
    }
    _torrentsDisplayList.value = displayList;
    // ignore: invalid_use_of_visible_for_testing_member
    // ignore: invalid_use_of_protected_member
    _torrentsDisplayList.notifyListeners();
  }

  List<Torrent>? _sortList(List<Torrent>? torrentsList, Sort? sort) {
    switch (sort) {
      case Sort.name_ascending:
        torrentsList!.sort((a, b) => a.name.compareTo(b.name));
        return torrentsList;

      case Sort.name_descending:
        torrentsList!.sort((a, b) => a.name.compareTo(b.name));
        return torrentsList.reversed.toList();

      case Sort.dateAdded:
        torrentsList!.sort((a, b) => a.torrentAdded.compareTo(b.torrentAdded));
        return torrentsList;

      case Sort.ratio:
        torrentsList!.sort((a, b) => a.ratio.compareTo(b.ratio));
        return torrentsList;

      case Sort.size_ascending:
        torrentsList!.sort((a, b) => a.size.compareTo(b.size));
        return torrentsList;

      case Sort.size_descending:
        torrentsList!.sort((a, b) => a.size.compareTo(b.size));
        return torrentsList.reversed.toList();

      case Sort.none:
        torrentsList!.sort((a, b) => a.torrentAdded.compareTo(b.torrentAdded));
        return torrentsList.reversed.toList();

      default:
        return torrentsList;
    }
  }

  List<Torrent>? _filterList(List<Torrent>? torrentsList, Filter filter) {
    switch (filter) {
      case Filter.All:
        return torrentsList;

      case Filter.Downloading:
        return torrentsList!
            .where((torrent) =>
                torrent.status == Status.downloading ||
                (torrent.status == Status.paused &&
                    torrent.status != Status.completed))
            .toList();

      case Filter.Completed:
        return torrentsList!
            .where((torrent) => torrent.status == Status.completed)
            .toList();

      case Filter.Active:
        return torrentsList!
            .where((torrent) => torrent.ulSpeed! > 0 || torrent.dlSpeed! > 0)
            .toList();

      case Filter.Inactive:
        return torrentsList!
            .where((torrent) => torrent.ulSpeed == 0 && torrent.dlSpeed == 0)
            .toList();

      case Filter.Error:
        return torrentsList!
            .where((torrent) =>
                torrent.msg!.length > 0 &&
                torrent.msg != 'Tracker: [Tried all trackers.]')
            .toList();

      default:
        return torrentsList;
    }
  }

  List<Torrent> _filterListUsingLabel(
      List<Torrent> torrentsList, String? label) {
    return torrentsList.where((torrent) => torrent.label == label).toList();
  }

  /// Reloads list of [Torrent]s from seedbox
  refreshTorrentList() async {
    log.v("Torrent refresh function called");
    IApiService? _apiService = locator<IApiService>();
    _userPreferencesService!.showAllAccounts
        ? await _apiService
            .getAllAccountsTorrentList()
            .listen((event) {})
            .cancel()
        : await _apiService.getTorrentList().listen((event) {}).cancel();
    await _apiService.getHistory();
    await updateTorrentDisplayList();
    _historyService.notify();
  }

  ///Removes [Torrent] and updates torrents list
  removeTorrent(String hashValue) async {
    IApiService? _apiService = locator<IApiService>();
    await _apiService.removeTorrent(hashValue);
    await refreshTorrentList();
  }

  ///Removes [Torrent] *with Data* and updates torrents list
  removeTorrentWithData(String hashValue) async {
    IApiService? _apiService = locator<IApiService>();
    await _apiService.removeTorrentWithData(hashValue);
    await refreshTorrentList();
  }
}
