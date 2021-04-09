import 'package:fluttertoast/fluttertoast.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/logger.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:rutorrentflutter/services/functional_services/shared_preferences_service.dart';

Logger log = getLogger("AuthenticationService");

///[Service] used for all functionalities related to authentication and its state
class AuthenticationService{

  SharedPreferencesService _sharedPreferencesService = locator<SharedPreferencesService>();

  ///List of user accounts
  List<Account> _accounts;

  ///Temp account used to verify login credentials
  Account _tempAccount;

  //Getters
  List<Account> get accounts => _accounts;
  Account get tempAccount => _tempAccount;

  //Setters
  set accounts(accounts) => _accounts = accounts;
  set tempAccount(account) => _tempAccount = account;
  
  Future<List<Account>> getAccount() async {
    if (_accounts == null) {
      _accounts = await _sharedPreferencesService.fetchSavedLogin();
      return _accounts;
    } else {
      return _accounts;
    }
  }

  Future<List<Account>> saveLogin(Account account) async {
    List<Account> accounts = await _sharedPreferencesService.fetchSavedLogin();
    bool alreadyLoggedIn = false;

    for (int index = 0; index < accounts.length; index++) {
      if (_matchApi(accounts[index], account)) {
        Fluttertoast.showToast(msg: 'Account already saved');
        alreadyLoggedIn = true;

        // Swap to put active one on first position which will be active by default
        Account account = accounts[0];
        accounts[0] = accounts[index];
        accounts[index] = account;
      }
    }

    if (!alreadyLoggedIn) {
      accounts.insert(0, account);
      _sharedPreferencesService.saveLogin(accounts);
    }

    return accounts;

  }

  bool _matchApi(Account api1, Account api2) {
    if (api1.url == api2.url &&
        api1.username == api2.username &&
        api1.password == api2.password)
      return true;
    else
      return false;
  }
}