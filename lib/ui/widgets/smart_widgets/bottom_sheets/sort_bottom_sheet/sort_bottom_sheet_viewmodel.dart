// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/app/constants.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/services/state_services/disk_file_service.dart';
import 'package:rutorrentflutter/services/state_services/history_service.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';
import 'package:stacked/stacked.dart';

final log = getLogger("SortBottomSheetViewModel");

class SortBottomSheetViewModel extends BaseViewModel {
  TorrentService _torrentService = locator<TorrentService>();
  DiskFileService _diskFileService = locator<DiskFileService>();
  HistoryService _historyService = locator<HistoryService>();

  late Screens screen;

  init(Screens screen) {
    this.screen = screen;
  }

  Sort get sortPreference {
    switch (screen) {
      case Screens.TorrentListViewScreen:
        return _torrentService.sortPreference;
      case Screens.DiskExplorerViewScreen:
        return _diskFileService.sortPreference;
      case Screens.TorrentHistoryViewScreen:
        return _historyService.sortPreference;
    }
  }

  setSortPreference(Function func, Sort newPreference) {
    log.e(newPreference);
    switch (screen) {
      case Screens.TorrentListViewScreen:
        _torrentService.setSortPreference(newPreference);
        _torrentService.updateTorrentDisplayList();
        break;
      case Screens.DiskExplorerViewScreen:
        _diskFileService.setSortPreference(newPreference);
        _diskFileService.updateDiskFileDisplayList();
        break;
      case Screens.TorrentHistoryViewScreen:
        _historyService.setSortPreference(newPreference);
        _historyService.updateTorrentHistoryDisplayList();
        break;
    }
    notifyListeners();
  }

  Map<Sort, String> getSortMap() {
    switch (screen) {
      case Screens.TorrentListViewScreen:
        return sortMapTorrentList;
      case Screens.DiskExplorerViewScreen:
        return sortMapDiskFileList;
      case Screens.TorrentHistoryViewScreen:
        return sortMapHistoryList;
    }
  }
}
