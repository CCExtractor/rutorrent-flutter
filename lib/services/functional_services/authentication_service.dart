import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:rutorrentflutter/services/api/i_api_service.dart';
import 'package:rutorrentflutter/services/functional_services/shared_preferences_service.dart';

Logger log = getLogger("AuthenticationService");

///[Service] used for all functionalities related to authentication and its state
class AuthenticationService {
  SharedPreferencesService? _sharedPreferencesService =
      locator<SharedPreferencesService>();

  ///List of user accounts
  List<Account?>? _accounts;

  ///Temp account used to verify login credentials
  Account? _tempAccount;

  //Getters
  List<Account?>? get accounts => _accounts;
  Account? get tempAccount => _tempAccount;

  //Setters
  set accounts(accounts) => _accounts = accounts;
  set tempAccount(account) => _tempAccount = account;

  Future<List<Account?>?> getAccount() async {
    if (_accounts == null) {
      _accounts = await _sharedPreferencesService!.fetchSavedLogin();
      return _accounts;
    } else {
      return _accounts;
    }
  }

  Future<List<Account?>> saveLogin(Account? account) async {
    if (account == null) return [];
    List<Account?> accounts =
        await _sharedPreferencesService!.fetchSavedLogin();
    bool alreadyLoggedIn = false;

    for (int index = 0; index < accounts.length; index++) {
      if (matchAccount(accounts[index]!, account)) {
        Fluttertoast.showToast(msg: 'Account already saved');
        alreadyLoggedIn = true;

        // Swap to put active one on first position which will be active by default
        Account? account = accounts[0];
        accounts[0] = accounts[index];
        accounts[index] = account;
      }
    }

    if (!alreadyLoggedIn) {
      accounts.insert(0, account);
      _sharedPreferencesService!.saveLogin(accounts);
    }

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

    if (password == accounts?[index]?.password) {
      Fluttertoast.showToast(
          msg: 'New password cannot be same as old password');
      return false;
    }

    bool isValidPassword = await _apiService.changePassword(index, password);

    if (!isValidPassword) {
      Fluttertoast.showToast(msg: 'Invalid Password');
      return false;
    }

    accounts?[index]?.setPassword(password);
    saveLogin(accounts?[index]);
    Fluttertoast.showToast(msg: 'Password Changed Successfully');

    return true;
  }

  void deleteAccount(int index) {
    if (accounts?.length == 1) {
      logoutAllAccounts();
    } else {
      removeAccount(index);
    }
  }

  void logoutAllAccounts() async {}

  void removeAccount(int index) {
    _accounts?.removeAt(index);
    saveLogin(_accounts?[0]);
  }
}
