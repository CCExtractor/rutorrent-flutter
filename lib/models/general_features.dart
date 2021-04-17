import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/components/filter_tile.dart';
import 'package:rutorrentflutter/models/settings.dart';
import 'package:rutorrentflutter/models/history_item.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:rutorrentflutter/services/notifications.dart';
import 'disk_space.dart';

enum Sort {
  nameAscending,
  nameDescending,
  dateAdded,
  ratio,
  sizeAscending,
  sizeDescending,
  none,
}

enum Filter {
  all,
  downloading,
  completed,
  active,
  inactive,
  error,
}

enum NotificationChannelID {
  newTorrentAdded,
  downloadCompleted,
  lowDiskSpace,
}

class GeneralFeatures extends ChangeNotifier {
  /// List of all saved accounts [Apis]
  List<Api> apis = [];
  bool _allAccounts = false;

  bool get allAccounts => _allAccounts;

  /// show torrents from all saved accounts
  void showAllAccounts() {
    _allAccounts = !_allAccounts;
    notifyListeners();
  }

  /// show torrents from only selected account
  void doNotShowAllAccounts() {
    _allAccounts = false;
    notifyListeners();
  }

  /// Generating notifications
  Notifications notifications = Notifications();

  /// Page Controller for Home Page
  final PageController _pageController = PageController();
  PageController get pageController => _pageController;

  /// Torrent List
  List<Torrent> _torrentsList = [];
  List<Torrent> get torrentsList => _torrentsList;
  List<Torrent> updateTorrentsList(List<Torrent> newList) =>
      _torrentsList = newList;

  /// Torrent Sorting
  Sort _sortPreference;
  Sort get sortPreference => _sortPreference;

  void setSortPreference(Sort newPreference) {
    _sortPreference = newPreference;
    notifyListeners();
  }

  List<Torrent> sortList(List<Torrent> torrentsList, Sort sort) {
    switch (sort) {
      case Sort.nameAscending:
        torrentsList.sort((a, b) => a.name.compareTo(b.name));
        return torrentsList;

      case Sort.nameDescending:
        torrentsList.sort((a, b) => a.name.compareTo(b.name));
        return torrentsList.reversed.toList();

      case Sort.dateAdded:
        torrentsList.sort((a, b) => a.torrentAdded.compareTo(b.torrentAdded));
        return torrentsList;

      case Sort.ratio:
        torrentsList.sort((a, b) => a.ratio.compareTo(b.ratio));
        return torrentsList;

      case Sort.sizeAscending:
        torrentsList.sort((a, b) => a.size.compareTo(b.size));
        return torrentsList;

      case Sort.sizeDescending:
        torrentsList.sort((a, b) => a.size.compareTo(b.size));
        return torrentsList.reversed.toList();

      case Sort.none:
        torrentsList.sort((a, b) => a.torrentAdded.compareTo(b.torrentAdded));
        return torrentsList.reversed.toList();

      default:
        return torrentsList;
    }
  }

  /// Torrent Searching
  final TextEditingController _searchTextController = TextEditingController();
  bool _isSearching = false;
  final FocusNode _searchBarFocus = FocusNode();

  TextEditingController get searchTextController => _searchTextController;
  bool get isSearching => _isSearching;
  FocusNode get searchBarFocus => _searchBarFocus;

  void setSearchingState(bool newState) {
    _isSearching = newState;
    notifyListeners();
  }

  /// Disk Space
  final DiskSpace _diskSpace = DiskSpace();
  DiskSpace get diskSpace => _diskSpace;

  void updateDiskSpace(int total, int free, BuildContext context) {
    //check if there is any change in freeSpace of disk
    if (free == _diskSpace.free) {
      return;
    } // returning since there is no change and UI does not need to update

    _diskSpace.update(total, free);
    notifyListeners();

    if (_diskSpace.isLow() &&
        _diskSpace.alertUser &&
        Provider.of<Settings>(context, listen: false).diskSpaceNotification) {
      _diskSpace.generateLowDiskSpaceAlert(notifications);
    }
  }

  /// Torrent Filtering
  Filter _selectedFilter = Filter.all;
  final List<FilterTile> _filterTileList = [
    FilterTile(
      icon: Icons.filter_tilt_shift,
      filter: Filter.all,
    ),
    FilterTile(
      icon: FontAwesomeIcons.arrowAltCircleDown,
      filter: Filter.downloading,
    ),
    FilterTile(
      icon: Icons.done_outline,
      filter: Filter.completed,
    ),
    FilterTile(
      icon: Icons.open_with,
      filter: Filter.active,
    ),
    FilterTile(
      icon: Icons.not_interested,
      filter: Filter.inactive,
    ),
    FilterTile(
      icon: Icons.error,
      filter: Filter.error,
    ),
  ];

  Filter get selectedFilter => _selectedFilter;
  List<FilterTile> get filterTileList => _filterTileList;

  void changeFilter(Filter newFilter) {
    _isLabelSelected = false;
    _selectedFilter = newFilter;
    _pageController.jumpToPage(0); // Show the torrents listing page
    notifyListeners();
  }

  List<Torrent> filterList(List<Torrent> torrentsList, Filter filter) {
    switch (filter) {
      case Filter.all:
        return torrentsList;

      case Filter.downloading:
        return torrentsList
            .where((torrent) =>
                torrent.status == Status.downloading ||
                (torrent.status == Status.paused &&
                    torrent.status != Status.completed))
            .toList();

      case Filter.completed:
        return torrentsList
            .where((torrent) => torrent.status == Status.completed)
            .toList();

      case Filter.active:
        return torrentsList
            .where((torrent) => torrent.ulSpeed > 0 || torrent.dlSpeed > 0)
            .toList();

      case Filter.inactive:
        return torrentsList
            .where((torrent) => torrent.ulSpeed == 0 && torrent.dlSpeed == 0)
            .toList();

      case Filter.error:
        return torrentsList
            .where((torrent) =>
                torrent.msg.isNotEmpty &&
                torrent.msg != 'Tracker: [Tried all trackers.]')
            .toList();

      default:
        return torrentsList;
    }
  }

  /// Active Torrents
  // Those torrents which are currently active and not fully downloaded
  List<Torrent> _activeDownloads = [];
  List<Torrent> get activeDownloads {
    return _activeDownloads;
  }

  List<Torrent> setActiveDownloads(List<Torrent> list) =>
      _activeDownloads = list;

  /// Active Labels
  // List of names of all the labels
  List<String> _listOfLabels = [];
  List<String> get listOfLabels {
    return _listOfLabels;
  }

  void setListOfLabels(List<String> listOfLabels) {
    if (_allAccounts) {
      _listOfLabels = (_listOfLabels + listOfLabels).toSet().toList();
    } else {
      _torrentsList.isEmpty ? _listOfLabels = [] : _listOfLabels = listOfLabels;
    }
    notifyListeners();
  }

  //Selected Label
  String _selectedLabel;

  //Flag, used to know if a label is selected or not
  bool _isLabelSelected = false;

  bool get isLabelSelected => _isLabelSelected;
  String get selectedLabel => _selectedLabel;
  void changeLabel(String label) {
    _selectedFilter = Filter.all;
    _isLabelSelected = true;
    _selectedLabel = label;
    _pageController.jumpToPage(0); // Show the torrents listing page
    notifyListeners();
  }

  List<Torrent> filterListUsingLabel(List<Torrent> torrentsList, String label) {
    return torrentsList.where((torrent) => torrent.label == label).toList();
  }

  /// History Check
  List<HistoryItem> _historyItems = [];
  List<HistoryItem> get historyItems => _historyItems;

  void updateHistoryItems(List<HistoryItem> updatedList, BuildContext context) {
    bool happenedNow(HistoryItem item) {
      if (DateTime.now().millisecondsSinceEpoch ~/ 1000 - item.actionTime ==
          1) {
        return true;
      }
      return false;
    }

    _historyItems = updatedList;
    for (var item in updatedList) {
      switch (item.action) {
        case 1: // Torrent Added
          if (happenedNow(item)) {
            // Generate Notification
            if (Provider.of<Settings>(context, listen: false)
                .addTorrentNotification) {
              notifications.generate('New Torrent Added', item.name,
                  NotificationChannelID.newTorrentAdded);
            }
          }
          break;

        case 2: // Torrent Finished
          if (happenedNow(item)) {
            // Generate Notification
            if (Provider.of<Settings>(context, listen: false)
                .downloadCompleteNotification) {
              notifications.generate('Download Completed', item.name,
                  NotificationChannelID.downloadCompleted);
            }
          }
          break;

        case 3: // Torrent Deleted
          if (happenedNow(item)) {
            // Do Something
          }
          break;
      }
    }
  }
}

extension CustomizableDateTime on DateTime {
  static DateTime _customTime;
  static DateTime get current {
    return _customTime ?? DateTime.now();
  }

  static set customTime(DateTime customTime) {
    _customTime = customTime;
  }
}
