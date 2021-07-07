import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/models/history_item.dart';
import 'package:rutorrentflutter/services/api/i_api_service.dart';
import 'package:rutorrentflutter/services/functional_services/notification_service.dart';
import 'package:rutorrentflutter/services/services_info.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';

Logger log = getLogger("HistoryService");

///Class to handle [Torrent History] State accross the application
class HistoryService extends ChangeNotifier {
  UserPreferencesService _userPreferencesService =
      locator<UserPreferencesService>();
  NotificationService _notificationService = locator<NotificationService>();

  ValueNotifier<List<HistoryItem>> _torrentsHistoryList =
      new ValueNotifier(new List<HistoryItem>.empty());
  ValueNotifier<List<HistoryItem>> _torrentsHistoryDisplayList =
      new ValueNotifier(new List<HistoryItem>.empty());

  ValueNotifier<List<HistoryItem>> get torrentsHistoryList =>
      _torrentsHistoryList;
  ValueNotifier<List<HistoryItem>> get displayTorrentHistoryList =>
      _torrentsHistoryDisplayList;

  setTorrentHistoryList(List<HistoryItem> list) {
    _torrentsHistoryList.value = list;
    _torrentsHistoryDisplayList.value = list;
    updateTorrentHistoryDisplayList();
  }

  refreshTorrentHistoryList({int? lastHours}) async {
    log.v("Torrent History refresh function called");
    IApiService? _apiService = locator<IApiService>();
    lastHours == null
        ? await _apiService.getHistory()
        : await _apiService.getHistory(lastHours: lastHours);
  }

  updateTorrentHistoryDisplayList() {
    _torrentsHistoryList.notifyListeners();
    _torrentsHistoryDisplayList.notifyListeners();
  }

  notify() {
    bool happenedNow(HistoryItem item) {
      if (DateTime.now().millisecondsSinceEpoch ~/ 1000 - item.actionTime == 1)
        return true;
      return false;
    }

    List<HistoryItem> _historyItems = _torrentsHistoryList.value;
    List<HistoryItem> updatedList = _historyItems;

    for (var item in updatedList) {
      switch (item.action) {
        case 1: // Torrent Added
          if (happenedNow(item)) {
            // Generate Notification
            if (_userPreferencesService.addTorrentNotification) {
              _notificationService.dispatchLocalNotification(
                  key: NotificationService.new_torrent_added_notify,
                  customData: {
                    'title': ServicesInfo.new_torrent_added_notification_title,
                    'body': ServicesInfo.new_torrent_added_notification_body,
                  });
            }
          }
          break;

        case 2: // Torrent Finished
          if (happenedNow(item)) {
            // Generate Notification
            if (_userPreferencesService.downloadCompleteNotification) {
              _notificationService.dispatchLocalNotification(
                  key: NotificationService.download_completed_notify,
                  customData: {
                    'title': ServicesInfo.download_completed_notification_title,
                    'body': ServicesInfo.download_completed_notification_body,
                  });
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
