import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.router.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:rutorrentflutter/services/functional_services/authentication_service.dart';
import 'package:rutorrentflutter/services/functional_services/shared_preferences_service.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';
import 'package:rutorrentflutter/utils/package_info_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

Logger log = getLogger("SplashViewModel");

class SplashViewModel extends FutureViewModel {
  SharedPreferencesService? _sharedPreferencesService =
      locator<SharedPreferencesService>();
  NavigationService? _navigationService = locator<NavigationService>();
  AuthenticationService? _authenticationService =
      locator<AuthenticationService>();
  PackageInfoService? _packageInfoService =
      locator<PackageInfoService>();
  UserPreferencesService? _userPreferencesService =
      locator<UserPreferencesService>();

  handleStartUpLogic() async {
    _authenticationService!.accounts.value =
        await _sharedPreferencesService!.fetchSavedLogin();
    List<Account> accounts = _authenticationService?.accounts.value ?? [];

    //Get and Save PackageInfo 
    _userPreferencesService!.setPackageInfo(await _packageInfoService!.getPackageInfo());

    if (accounts.isNotEmpty) {
      log.v("User is logged in");
      _navigationService?.replaceWith(Routes.homeView);
    } else {
      log.v("User not logged in");
      _navigationService?.clearStackAndShow(Routes.loginView);
    }
  }

  @override
  Future futureToRun() => handleStartUpLogic();
}
