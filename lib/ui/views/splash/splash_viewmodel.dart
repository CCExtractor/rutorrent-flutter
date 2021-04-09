import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.router.dart';
import 'package:rutorrentflutter/app/logger.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:rutorrentflutter/services/functional_services/authentication_service.dart';
import 'package:rutorrentflutter/services/functional_services/shared_preferences_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

Logger log = getLogger("SplashViewModel");

class SplashViewModel extends FutureViewModel {
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  NavigationService _navigationService = locator<NavigationService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  handleStartUpLogic() async {
    _authenticationService.accounts =
        await _sharedPreferencesService.fetchSavedLogin();
    List<Account> accounts = _authenticationService.accounts;

    if (accounts != null && accounts.isNotEmpty) {
      log.i("handleStartUpLogic - User is logged in");
      _navigationService.replaceWith(Routes.homeView);
    } else {
      log.e("handleStartUpLogic - User not logged in");
      _navigationService.replaceWith(Routes.loginView);
    }
  }

  @override
  Future futureToRun() => handleStartUpLogic();
}
