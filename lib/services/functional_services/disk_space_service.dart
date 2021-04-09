import 'package:injectable/injectable.dart';
import 'package:rutorrentflutter/models/disk_space.dart';

class DiskSpaceService{

  DiskSpace _diskSpace = DiskSpace();

  DiskSpace get diskSpace => _diskSpace;

  updateDiskSpace(int total, int free) {

    _diskSpace.update(total, free);

    // TODO add notification logic
    // if (_diskSpace.isLow() &&
    //     _diskSpace.alertUser &&
    //     Provider.of<Settings>(context, listen: false).diskSpaceNotification)
    //   _diskSpace.generateLowDiskSpaceAlert(notifications);

  }
}