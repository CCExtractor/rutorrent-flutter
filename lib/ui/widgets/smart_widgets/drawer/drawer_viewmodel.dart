import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/services/functional_services/disk_space_service.dart';
import 'package:stacked/stacked.dart';

class DrawerViewModel extends BaseViewModel {

  DiskSpaceService _diskSpaceService = locator<DiskSpaceService>();

  get diskSpace => _diskSpaceService.diskSpace;
}