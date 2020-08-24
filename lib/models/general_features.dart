import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/components/filter_tile.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/models/settings.dart';
import 'package:rutorrentflutter/utilities/constants.dart';
import 'package:rutorrentflutter/models/history_item.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:rutorrentflutter/services/notifications.dart';
import 'disk_space.dart';

enum Sort {
  name,
  dateAdded,
  percentDownloaded,
  downloadSpeed,
  uploadSpeed,
  ratio,
  size,
}

enum Filter {
  All,
  Downloading,
  Completed,
  Active,
  Inactive,
  Error,
}

class GeneralFeatures extends ChangeNotifier {

  List<Api> apis = [];// Containing information of all saved accounts
  bool _allAccounts=false;

  get allAccounts => _allAccounts;

  showAllAccounts(){
    _allAccounts=true;
    notifyListeners();
  }

  doNotShowAllAccounts(){
    _allAccounts=false;
    notifyListeners();
  }

  GlobalKey<ScaffoldState> scaffoldKey;

  /// Generating notifications
  Notifications notifications = Notifications();

  /// Page Controller for Home Page
  final PageController _pageController = PageController();
  get pageController => _pageController;

  /// Torrent List
  List<Torrent> _torrentsList = [];
  get torrentsList => _torrentsList;
  updateTorrentsList(List<Torrent> newList) => _torrentsList = newList;

  /// Torrent Sorting
  Sort _sortPreference;
  get sortPreference => _sortPreference;

  setSortPreference(Sort newPreference) {
    _sortPreference = newPreference;
    notifyListeners();
  }

  List<Torrent> sortList(List<Torrent> torrentsList, Sort sort) {
    switch (sort) {
      case Sort.name:
        torrentsList.sort((a, b) => a.name.compareTo(b.name));
        return torrentsList;
      case Sort.dateAdded:
        torrentsList.sort((a, b) => a.torrentAdded.compareTo(b.torrentAdded));
        return torrentsList;
      case Sort.percentDownloaded:
        torrentsList.sort(
            (a, b) => a.percentageDownload.compareTo(b.percentageDownload));
        return torrentsList;
      case Sort.downloadSpeed:
        torrentsList.sort((a, b) => a.dlSpeed.compareTo(b.dlSpeed));
        return torrentsList;
      case Sort.uploadSpeed:
        torrentsList.sort((a, b) => a.ulSpeed.compareTo(b.ulSpeed));
        return torrentsList;
      case Sort.ratio:
        torrentsList.sort((a, b) => a.ratio.compareTo(b.ratio));
        return torrentsList;
      case Sort.size:
        torrentsList.sort((a, b) => a.size.compareTo(b.size));
        return torrentsList;
      default:
        return torrentsList;
    }
  }

  /// Torrent Searching
  TextEditingController _searchTextController = TextEditingController();
  bool _isSearching = false;
  FocusNode _searchBarFocus = FocusNode();

  get searchTextController => _searchTextController;
  get isSearching => _isSearching;
  get searchBarFocus => _searchBarFocus;

  setSearchingState(bool newState) {
    _isSearching = newState;
    notifyListeners();
  }

  /// Disk Space
  DiskSpace _diskSpace = DiskSpace();
  get diskSpace => _diskSpace;

  updateDiskSpace(int total, int free, BuildContext context) {
    //check if there is any change in freeSpace of disk
    if (free == _diskSpace.free)
      return; // returning since there is no change and UI does not need to update

    _diskSpace.update(total, free);
    notifyListeners();

    if (_diskSpace.isLow() && _diskSpace.alertUser && Provider.of<Settings>(context,listen: false).diskSpaceNotification)
      _diskSpace.generateLowDiskSpaceAlert(notifications);
  }

  /// Torrent Filtering
  Filter _selectedFilter = Filter.All;
  List<FilterTile> _filterTileList = [
    FilterTile(
      icon: Icons.filter_tilt_shift,
      filter: Filter.All,
    ),
    FilterTile(
      icon: FontAwesomeIcons.arrowAltCircleDown,
      filter: Filter.Downloading,
    ),
    FilterTile(
      icon: Icons.done_outline,
      filter: Filter.Completed,
    ),
    FilterTile(
      icon: Icons.open_with,
      filter: Filter.Active,
    ),
    FilterTile(
      icon: Icons.not_interested,
      filter: Filter.Inactive,
    ),
    FilterTile(
      icon: Icons.error,
      filter: Filter.Error,
    ),
  ];

  get selectedFilter => _selectedFilter;
  get filterTileList => _filterTileList;

  changeFilter(Filter newFilter) {
    _selectedFilter = newFilter;
    _pageController.jumpToPage(0); // Show the torrents listing page
    notifyListeners();
  }

  List<Torrent> filterList(List<Torrent> torrentsList, Filter filter) {
    switch (filter) {
      case Filter.All:
        return torrentsList;
      case Filter.Downloading:
        return torrentsList
            .where((torrent) => torrent.status == Status.downloading)
            .toList();
      case Filter.Completed:
        return torrentsList
            .where((torrent) => torrent.status == Status.completed)
            .toList();
      case Filter.Active:
        return torrentsList
            .where((torrent) => torrent.ulSpeed > 0 || torrent.dlSpeed > 0)
            .toList();
      case Filter.Inactive:
        return torrentsList
            .where((torrent) => torrent.ulSpeed == 0 && torrent.dlSpeed == 0)
            .toList();
      case Filter.Error:
        return torrentsList
            .where((torrent) =>
                torrent.msg.length > 0 &&
                torrent.msg != 'Tracker: [Tried all trackers.]')
            .toList();
      default:
        return torrentsList;
    }
  }

  /// Active Torrents
  // Those torrents which are currently active and not fully downloaded
  List<Torrent> _activeDownloads = [];
  get activeDownloads {
    return _activeDownloads;
  }

  setActiveDownloads(List<Torrent> list) => _activeDownloads = list;

  /// History Check
  List<HistoryItem> _historyItems = [];
  get historyItems => _historyItems;

  updateHistoryItems(List<HistoryItem> updatedList, BuildContext context) {
    _historyItems = updatedList;
    for (var item in updatedList) {
      switch (item.action) {

        case 1: // Added
          if (DateTime.now().millisecondsSinceEpoch ~/ 1000 - item.actionTime == 1) {
            if(Provider.of<Settings>(context,listen: false).addTorrentNotification) {
              notifications.generate('New Torrent Added', item.name);
            }
            scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('${item.name} Added'),
              duration: Duration(seconds: 1),
              backgroundColor: Provider.of<Mode>(context).isLightMode
                              ?kGreenActiveLT:kGreenActiveDT,
            ));
          }
          break;

        case 2: // Finished
          if (DateTime.now().millisecondsSinceEpoch ~/ 1000 - item.actionTime ==1) {
            if(Provider.of<Settings>(context,listen: false).downloadCompleteNotification) {
              notifications.generate('Download Completed', item.name);
            }
          }
          break;

        case 3: // Deleted
          if (DateTime.now().millisecondsSinceEpoch ~/ 1000 - item.actionTime == 1) {
            scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('${item.name} Removed'),
              duration: Duration(seconds: 1),
              backgroundColor: Provider.of<Mode>(context).isLightMode
                  ?kRedErrorLT:kRedErrorDT,
            ));
          }
          break;
      }
    }
  }
}
