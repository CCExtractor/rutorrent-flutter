import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';
import 'package:stacked/stacked.dart';

class SortBottomSheetViewModel extends BaseViewModel {

  UserPreferencesService _userPreferencesService = locator<UserPreferencesService>();

  Sort get sortPreference => _userPreferencesService.sortPreference;

  setSortPreference(Function func,Sort newPreference) {
    _userPreferencesService.setSortPreference(newPreference);
    notifyListeners();
  }
}