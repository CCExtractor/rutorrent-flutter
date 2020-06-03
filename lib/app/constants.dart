/// This dart library contains constants which can be used anywhere other than the UI of the project
library app_constants;


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

/// APP RELEASE INFO
const String BUILD_NUMBER = '2';
const String RELEASE_DATE = '28.02.20';