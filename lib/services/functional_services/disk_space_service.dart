import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/models/disk_space.dart';
import 'package:rutorrentflutter/services/functional_services/notification_service.dart';
import 'package:rutorrentflutter/services/services_info.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';

class DiskSpaceService {
  UserPreferencesService _userPreferencesService =
      locator<UserPreferencesService>();
  NotificationService _notificationService = locator<NotificationService>();

  DiskSpace _diskSpace = DiskSpace();

  DiskSpace get diskSpace => _diskSpace;

  updateDiskSpace(int? total, int? free) {
    _diskSpace.update(total, free);

    bool shouldShowNotification = _diskSpace.isLow() &&
        _diskSpace.alertUser &&
        _userPreferencesService.diskSpaceNotification;

    if (shouldShowNotification)
      _notificationService.dispatchLocalNotification(
          key: NotificationService.low_disk_space_notify,
          customData: {
            "title": ServicesInfo.low_disk_space_notification_title,
            "body": ServicesInfo.low_disk_space_notification_body,
          });
  }
}
