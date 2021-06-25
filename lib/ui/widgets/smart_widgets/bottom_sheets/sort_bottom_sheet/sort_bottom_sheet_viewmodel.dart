import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';
import 'package:stacked/stacked.dart';
final log = getLogger("SortBottomSheetViewModel");
class SortBottomSheetViewModel extends BaseViewModel {

  TorrentService _torrentService = locator<TorrentService>();

  Sort get sortPreference => _torrentService.sortPreference;

  setSortPreference(Function func,Sort newPreference) {
    log.e(newPreference);
    _torrentService.setSortPreference(newPreference);
    _torrentService.updateTorrentDisplayList();
    notifyListeners();
  }
}