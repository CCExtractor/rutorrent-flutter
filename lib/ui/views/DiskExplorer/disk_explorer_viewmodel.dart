import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/models/disk_file.dart';
import 'package:rutorrentflutter/services/functional_services/api_service.dart';
import 'package:rutorrentflutter/services/functional_services/authentication_service.dart';
import 'package:stacked/stacked.dart';

final log = getLogger("DiskExplorerViewModel");

class DiskExplorerViewModel extends FutureViewModel {
  ApiService _apiService = locator<ApiService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  String path = "/";
  bool isFeatureAvailable = false;
  List<DiskFile> _diskFiles = [];

  get diskFiles => _diskFiles;

  Future<bool> onBackPress() async {
    log.v("Path is now : " + path);
    if (path == '/') {
      return true;
    }
    goBackwards();
    return false;
  }

  goBackwards() {
    path = path.substring(0, path.length - 1);
    path = path.substring(0, path.lastIndexOf('/') + 1);
    notifyListeners();
    _getDiskFiles();
    log.v("Path changed to : " + path);
  }

  goForwards(String fileName) {
    path += fileName + '/';
    notifyListeners();
    _getDiskFiles();
    log.v("Path changed to : " + path);
  }

  _getDiskFiles() async {
    setBusy(true);
    _diskFiles = await _apiService.getDiskFiles(path);
    setBusy(false);
  }

  init() async {
    setBusy(true);
    isFeatureAvailable =
        _authenticationService.accounts?[0]?.isSeedboxAccount ?? false;
    await _getDiskFiles();
    setBusy(false);
  }

  @override
  Future futureToRun() => init();
}
