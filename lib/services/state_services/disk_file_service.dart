import 'package:flutter/foundation.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/models/disk_file.dart';
import 'package:rutorrentflutter/services/functional_services/shared_preferences_service.dart';

///Service to handle state of [DiskFile] objects in the application
class DiskFileService extends ChangeNotifier{

  SharedPreferencesService _sharedPreferencesService = locator<SharedPreferencesService>();

  ValueNotifier<List<DiskFile>> _diskFileList =
      new ValueNotifier(new List<DiskFile>.empty());
  ValueNotifier<List<DiskFile>> _diskFileDisplayList =
      new ValueNotifier(new List<DiskFile>.empty());
      
  Sort _sortPreference = Sort.none;

  get sortPreference => _sortPreference;

  ValueNotifier<List<DiskFile>> get diskFileList => _diskFileList;
  ValueNotifier<List<DiskFile>> get diskFileDisplayList => _diskFileDisplayList;

  setDiskFileList(List<DiskFile> list) {
    _diskFileList.value = list;
    _diskFileDisplayList.value = list;
  }

  setSortPreference(Sort newPreference) {
    _sortPreference = newPreference;
    _sharedPreferencesService.DB.put("sortPreference_diskFiles", newPreference.index);
  }

  /// Updates display list of [Torrent]s
  updateDiskFileDisplayList({String? searchText}) {
    log.v("Disk File Items being updated");
    List<DiskFile> displayList = diskFileList.value;
    //Sorting: sorting data on basis of sortPreference
    displayList = _sortList(displayList, sortPreference)!;

    if (searchText != null) {
      //Searching : showing list on basis of searched text
      displayList = displayList
          .where((element) =>
              element.name!.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
    diskFileDisplayList.value = displayList;
    // ignore: invalid_use_of_visible_for_testing_member
    // ignore: invalid_use_of_protected_member
    diskFileDisplayList.notifyListeners();
  }

  List<DiskFile>? _sortList(List<DiskFile>? diskFileList, Sort? sort) {
    switch (sort) {
      case Sort.name_ascending:
        diskFileList!.sort((a, b) => a.name!.compareTo(b.name!));
        return diskFileList;

      case Sort.name_descending:
        diskFileList!.sort((a, b) => a.name!.compareTo(b.name!));
        return diskFileList.reversed.toList();

      case Sort.dateAdded:
      case Sort.ratio:
      case Sort.size_ascending:
      case Sort.size_descending:
      case Sort.none:
      default:
        return diskFileList;
    }
  }

}