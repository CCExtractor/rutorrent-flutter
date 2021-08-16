import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/app/app.router.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:rutorrentflutter/services/api/i_api_service.dart';
import 'package:rutorrentflutter/services/functional_services/shared_preferences_service.dart';
import 'package:stacked_services/stacked_services.dart';

Logger log = getLogger("AuthenticationService");

///[Service] used for all functionalities related to authentication and its state
class AuthenticationService extends ChangeNotifier {
  SharedPreferencesService? _sharedPreferencesService =
      locator<SharedPreferencesService>();
  NavigationService _navigationService = locator<NavigationService>();

  ///List of user accounts
  ValueNotifier<List<Account>> _accounts =
      new ValueNotifier(new List<Account>.empty());

  ///Temp account used to verify login credentials
  Account? _tempAccount;

  //Getters
  ValueNotifier<List<Account>> get accounts => _accounts;
  Account? get tempAccount => _tempAccount;

  //Setters
  set accounts(accounts) => _accounts = accounts;
  set tempAccount(account) => _tempAccount = account;

  Future<ValueNotifier<List<Account>>> getAccount() async {
    if (_accounts.value.isEmpty) {
      _accounts.value = await _sharedPreferencesService!.fetchSavedLogin();
      return _accounts;
    } else {
      return _accounts;
    }
  }

  Future<List<Account?>> saveLogin(Account? account) async {
    log.i("User being saved");
    if (account == null) return [];
    List<Account> accounts = await _sharedPreferencesService!.fetchSavedLogin();
    bool alreadyLoggedIn = false;

    for (int index = 0; index < accounts.length; index++) {
      if (matchAccount(accounts[index], account)) {
        log.i("User already exists");
        alreadyLoggedIn = true;

        // Swap to put active one on first position which will be active by default
        Account? account = accounts[0];
        accounts[0] = accounts[index];
        accounts[index] = account;
      }
    }

    if (!alreadyLoggedIn) {
      accounts.insert(0, account);
    }
    _accounts.value = accounts;
    _sharedPreferencesService!.saveLogin(accounts);
    _accounts.notifyListeners();
    return accounts;
  }

  bool matchAccount(Account api1, Account api2) {
    if (api1.url == api2.url &&
        api1.username == api2.username &&
        api1.password == api2.password)
      return true;
    else
      return false;
  }

  Future<bool> changePassword(int index, String password) async {
    IApiService _apiService = locator<IApiService>();
    log.e("Password being changed");
    if (password == accounts.value[index].password) {
      Fluttertoast.showToast(
          msg: 'New password cannot be same as old password');
      return false;
    }

    bool isValidPassword = await _apiService.changePassword(index, password);

    if (!isValidPassword) {
      Fluttertoast.showToast(msg: 'Invalid Password');
      return false;
    }

    accounts.value[index].setPassword(password);
    _sharedPreferencesService?.saveLogin(accounts.value);
    saveLogin(accounts.value[index]);
    Fluttertoast.showToast(msg: 'Password Changed Successfully');

    return true;
  }

  void deleteAccount(int index) {
    if (accounts.value.length == 1) {
      logoutAllAccounts();
    } else {
      removeAccount(index);
    }
  }

  void logoutAllAccounts() async {
    log.e("Logging out of all accounts");
    _accounts.value = [];
    _accounts.notifyListeners();
    await _sharedPreferencesService?.saveLogin(_accounts.value);
    _navigationService.navigateTo(Routes.splashView);
  }

  void removeAccount(int index) async {
    log.e("Account being removed");
    _accounts.value.removeAt(index);
    await _sharedPreferencesService?.saveLogin(_accounts.value);
    saveLogin(_accounts.value[0]);
    _accounts.notifyListeners();
    _navigationService.navigateTo(Routes.splashView);
  }
}
