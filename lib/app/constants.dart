/// This dart library contains constants which can be used anywhere other than the UI of the project
library app_constants;

import 'package:rutorrentflutter/enums/enums.dart';

///Notification Channel Names and Descriptions
///
///[Key] : Enum index of corresponding notification channel ID
///
///[Value] : List
///        First element being Notification Channel Name,
///        Second element being Notification Channel Description
Map<int, List<String>> notificationInfo = {
  0: [
    "Torrent Added Channel",
    "This Channel is for notifying when a new Torrent is added"
  ],
  1: [
    "Download Completed Channel",
    "This Channel is for notifying when a download is completed"
  ],
  2: [
    "Low Disk Space Channel",
    "This Channel is for notifying when there is Low Disk Space"
  ],
};

Map<Sort, String> sortMap = {
  Sort.name_ascending: 'Name - A to Z',
  Sort.name_descending: 'Name - Z to A',
  Sort.dateAdded: 'Date Added',
  Sort.ratio: 'Ratio',
  Sort.size_ascending: 'Size - Small to Large',
  Sort.size_descending: 'Size - Large to Small',
};

/// APP RELEASE INFO
const String BUILD_NUMBER = '2';
const String RELEASE_DATE = '28.02.20';
