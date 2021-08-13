import 'package:injectable/injectable.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class AppStateNotifier extends BaseViewModel {
  UserPreferencesService _userPreferencesService = locator<UserPreferencesService>();

  static bool isDarkModeOn = locator<UserPreferencesService>().isDarkModeOn;
  
  void updateTheme(bool isdarkmodeon) {
    isDarkModeOn = isdarkmodeon;
    _userPreferencesService.setDarkMode(isdarkmodeon);
    notifyListeners();
  }
}
