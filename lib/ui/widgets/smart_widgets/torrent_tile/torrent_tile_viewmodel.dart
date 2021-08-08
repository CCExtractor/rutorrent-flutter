import 'package:rutorrentflutter/services/api/i_api_service.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/app/app.router.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

final log = getLogger("TorrentTileViewModel");

class TorrentTileViewModel extends BaseViewModel {
  IApiService? _apiService = locator<IApiService>();
  UserPreferencesService? _userPreferencesService =
      locator<UserPreferencesService>();
  TorrentService? _torrentService = locator<TorrentService>();
  NavigationService _navigationService = locator<NavigationService>();

  Torrent? torrent = Torrent("dummy");

  get showAllAccounts => _userPreferencesService!.showAllAccounts;

  init(Torrent? torrentReceived, context) {
    torrent = torrentReceived;
  }

  removeTorrentWithData(String hashValue) {
    _torrentService!.removeTorrentWithData(hashValue);
  }

  removeTorrent(String hashValue) {
    _torrentService!.removeTorrent(hashValue);
  }

  toggleTorrentStatus(Torrent torrent) async {
    await _apiService!.toggleTorrentStatus(torrent);
    //Refresh torrent list
    await _torrentService?.refreshTorrentList();
  }

  navigateToTorrentDetail(Torrent torrent) {
    _navigationService.navigateTo(Routes.torrentDetailView,
        arguments: TorrentDetailViewArguments(torrent: torrent));
  }
}
