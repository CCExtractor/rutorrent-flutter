// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/app/app.router.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:rutorrentflutter/services/api/i_api_service.dart';
import 'package:rutorrentflutter/services/functional_services/authentication_service.dart';
import 'package:rutorrentflutter/services/functional_services/internet_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

Logger log = getLogger("LoginViewModel");

class LoginViewModel extends BaseViewModel {
  NavigationService? _navigationService = locator<NavigationService>();
  AuthenticationService? _authenticationService =
      locator<AuthenticationService>();
  InternetService? _internetService = locator<InternetService>();
  IApiService? _apiService = locator<IApiService>();

  Account? _account;

  // validating url through regex
  bool isValidUrl(String input) {
    var urlRegex = r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+';
    if (RegExp(urlRegex).hasMatch(input)) {
      return true;
    } else {
      return false;
    }
  }

  // output a invalid error message if url is invalid
  String? urlValidator(String? input) {
    if (!isValidUrl(input!)) {
      return 'Please enter a valid url';
    }
    return null;
  }

  login({String? url, required String? username, String? password}) async {
    setBusy(true);

    if (username!.isEmpty) {
      Fluttertoast.showToast(msg: 'Username cannot be empty!');
      setBusy(false);
      return;
    }

    if (password!.isEmpty) {
      Fluttertoast.showToast(msg: 'Password cannot be empty!');
      setBusy(false);
      return;
    }

    _account = Account(url: url, username: username, password: password);
    _authenticationService!.tempAccount = _account;
    bool isValidConfiguration = await _validateConfigurationDetails(_account);
    if (isValidConfiguration)
      _navigationService?.replaceWith(Routes.splashView);

    setBusy(false);
  }

  Future<bool> _validateConfigurationDetails(Account? account) async {
    final isConnected =
        await _internetService!.isUserConnectedToInternet() ?? false;

    if (!isConnected) {
      log.e("Network Connection Error");
      Fluttertoast.showToast(msg: "Network Connection Error");
      return false;
    }
    bool serverResponse = await _apiService!.testConnectionAndLogin(account);
    return serverResponse;
  }
}
