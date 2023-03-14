/// This dart library contains constants which can be used anywhere other than the UI of the project
library app_constants;

import 'package:rutorrentflutter/enums/enums.dart';

Map<Sort, String> sortMapTorrentList = {
  Sort.name_ascending: 'Name - A to Z',
  Sort.name_descending: 'Name - Z to A',
  Sort.dateAdded: 'Date Added',
  Sort.ratio: 'Ratio',
  Sort.size_ascending: 'Size - Small to Large',
  Sort.size_descending: 'Size - Large to Small',
};

Map<Sort, String> sortMapDiskFileList = {
  Sort.name_ascending: 'Name - A to Z',
  Sort.name_descending: 'Name - Z to A',
};

Map<Sort, String> sortMapHistoryList = {
  Sort.name_ascending: 'Name - A to Z',
  Sort.name_descending: 'Name - Z to A',
  Sort.dateAdded: 'Date Added',
  Sort.size_ascending: 'Size - Small to Large',
  Sort.size_descending: 'Size - Large to Small',
};

/// Default Asset Paths for the project
class DefaultPaths {
  /// Default Labels icons path
  static const String defaultLabelIcons = 'assets/icons/';

  /// Default Logos path
  static const String defaultLogos = 'assets/logo/';

  /// Default Animations path
  static const String defaultAnimations = 'assets/animations/';
}

/// APP RELEASE INFO
const String BUILD_NUMBER = '2';
const String RELEASE_DATE = '28.02.20';
