import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/app/app.router.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:rutorrentflutter/models/disk_space.dart';
import 'package:rutorrentflutter/services/api/i_api_service.dart';
import 'package:rutorrentflutter/services/functional_services/authentication_service.dart';
import 'package:rutorrentflutter/services/functional_services/disk_space_service.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/add_another_account_widget.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/filter_tile_list_widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

Logger log = getLogger("DrawerViewModel");

class DrawerViewModel extends BaseViewModel {
  DiskSpaceService? _diskSpaceService = locator<DiskSpaceService>();
  TorrentService? _torrentService = locator<TorrentService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  NavigationService _navigationService = locator<NavigationService>();
  UserPreferencesService _userPreferencesService =
      locator<UserPreferencesService>();
  IApiService _apiService = locator<IApiService>();

  get packageInfo => _userPreferencesService.packageInfo;

  void init() async {
    setBusy(true);
    await _apiService.updateDiskSpace();
    setBusy(false);
  }

  DiskSpace get diskSpace => _diskSpaceService!.diskSpace;

  ValueNotifier<List<Account>> get getAccountValueListenable =>
      _authenticationService.accounts;

  List<Widget> filterTileList(model) {
    return _getFilterTileList(model);
  }

  get listOfLabels => _torrentService?.listOfLabels;

  Filter get selectedFilter => _torrentService?.selectedFilter;

  String get selectedLabel => _torrentService?.selectedLabel;

  bool get isLabelSelected => _torrentService?.isLabelSelected;

  bool get shouldShowAllAccounts => _userPreferencesService.showAllAccounts;

  changeLabel(String label) {
    _torrentService?.changeLabel(label);
  }

  getAccountsList(context) {
    Account currAccount = _authenticationService.accounts.value[0];
    List<Account> torrentAccounts = getAccountValueListenable.value;

    //Add all Accounts
    List<Widget> accountsList = torrentAccounts
        .map((e) => Container(
              color: _authenticationService.matchAccount(e, currAccount) ||
                      shouldShowAllAccounts
                  ? Theme.of(context).disabledColor
                  : null,
              child: ListTile(
                dense: true,
                title: Text(
                  (e.url)!,
                  style: TextStyle(fontSize: 12),
                ),
                subtitle: Text(
                  (e.username)!,
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () => _changeAccount(e, currAccount),
              ),
            ))
        .toList();

    // Add All Accounts mode option
    accountsList.insert(0, _showAllAccountsWidget(context));

    // Add the "Add Account Option"
    accountsList.add(AddAnotherAccountWidget(onTap: _addAccount));

    return accountsList;
  }

  changeFilter(Filter filter) {
    _torrentService?.changeFilter(filter);
  }

  _changeAccount(Account toBeChangedAccount, Account currAccount) async {
    if (!_authenticationService.matchAccount(toBeChangedAccount, currAccount)) {
      log.i(
          "Account being changed to username : ${toBeChangedAccount.username}");
      await _authenticationService.saveLogin(toBeChangedAccount);
      await _torrentService?.refreshTorrentList();
      _navigationService.navigateTo(Routes.splashView);
      notifyListeners();
    } else {
      _navigationService.popRepeated(1);
      _userPreferencesService.setShowAllAccounts(false);
    }
  }

  _showAllAccountsWidget(BuildContext context) {
    return Container(
      child: ListTile(
        dense: true,
        leading: Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: shouldShowAllAccounts
                ? Theme.of(context).accentColor
                : Theme.of(context).disabledColor,
          ),
        ),
        onTap: () => _setAllAccounts(),
        title: Text(
          'All Accounts',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  _setAllAccounts() {
    _userPreferencesService.toggleShowAllAccounts();
    _torrentService?.refreshTorrentList();
    notifyListeners();
  }

  List<Widget> _getFilterTileList(model) {
    // ignore: unnecessary_cast
    return filterTileIcons
        .asMap()
        .map((index, icon) =>
            MapEntry(index, _getFilterTile(index, icon, model)))
        .values
        .toList() as List<Widget>;
  }

  FilterTile _getFilterTile(int index, icon, model) {
    return FilterTile(model: model, filter: Filter.values[index], icon: icon);
  }

  navigateToHistoryScreen() {
    _navigationService.popRepeated(1);
    _navigationService.navigateTo(Routes.historyView);
  }

  navigateToDiskExplorerScreen() {
    _navigationService.popRepeated(1);
    _navigationService.navigateTo(Routes.diskExplorerView);
  }

  navigateToSettingsScreen() {
    _navigationService.popRepeated(1);
    _navigationService.navigateTo(Routes.settingsView);
  }

  _addAccount() {
    _navigationService.navigateTo(Routes.loginView);
  }
}
