import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/app/app.router.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:rutorrentflutter/services/functional_services/api_service.dart';
import 'package:rutorrentflutter/services/functional_services/authentication_service.dart';
import 'package:rutorrentflutter/services/functional_services/internet_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
Logger log = getLogger("LoginViewModel");

class LoginViewModel extends BaseViewModel {
  NavigationService? _navigationService = locator<NavigationService>();
  AuthenticationService? _authenticationService = locator<AuthenticationService>();
  InternetService? _internetService = locator<InternetService>();
  ApiService? _apiService = locator<ApiService>();

  Account? _account;

  login({String? url, required String username, String? password}) async {

    setBusy(true);
    if (username.contains(" ") || password!.contains(" ")) {
      Fluttertoast.showToast(msg: 'Invalid username or password');
    } else {
      _account = Account(url: url, username: username, password: password);
      _authenticationService!.tempAccount = _account;
      await _validateConfigurationDetails(_account);
    }
    _navigationService?.replaceWith(Routes.splashView);
    setBusy(false);

  }

  _validateConfigurationDetails(Account? account) async {

    final isConnected = await _internetService!.isUserConnectedToInternet() ?? false;

    if(!isConnected){
      log.e("Network Connection Error");
      Fluttertoast.showToast(msg: "Network Connection Error");
      return;
    }
    
    await _apiService!.testConnectionAndLogin(account);
    
  }
}
