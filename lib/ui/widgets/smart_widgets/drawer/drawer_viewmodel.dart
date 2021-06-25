import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.router.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:rutorrentflutter/models/disk_space.dart';
import 'package:rutorrentflutter/services/functional_services/authentication_service.dart';
import 'package:rutorrentflutter/services/functional_services/disk_space_service.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/filter_tile_list_widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class DrawerViewModel extends BaseViewModel {

  DiskSpaceService? _diskSpaceService = locator<DiskSpaceService>();
  TorrentService? _torrentService = locator<TorrentService>();
  AuthenticationService _authenticationService = locator<AuthenticationService>();
  NavigationService _navigationService = locator<NavigationService>();
  UserPreferencesService _userPreferencesService = locator<UserPreferencesService>();

  DiskSpace get diskSpace => _diskSpaceService!.diskSpace;

  List<Account?> get accounts => (_authenticationService.accounts)!;

  List<Widget> filterTileList(model) {return _getFilterTileList(model);}

  get listOfLabels => _torrentService?.listOfLabels;

  Filter get selectedFilter => _torrentService?.selectedFilter;

  String get selectedLabel => _torrentService?.selectedLabel;

  bool get isLabelSelected => _torrentService?.isLabelSelected;

  changeLabel(String label){
    _torrentService?.changeLabel(label);
  }

  getAccountsList(context) {
    Account? currAccount = _authenticationService.accounts?[0];
    List<Account?> torrentAccounts = accounts;

    //Add all Accounts 
    List<Widget> accountsList = torrentAccounts.map((e) => Container(
              color: _authenticationService.matchAccount(e! , currAccount!) ? Theme.of(context).disabledColor : null,
              child: ListTile(
                dense: true,
                title: Text(
                  (e.url)!,
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () => _changeAccount(e, currAccount),
              ),
            ))
        .toList();

    // Add All Accounts mode option
    accountsList.insert(
      0, 
      _showAllAccountsWidget(_setAllAccounts,_userPreferencesService.showAllAccounts,context)
    );

    return accountsList;
  }

  changeFilter(Filter filter) {
    _torrentService?.changeFilter(filter);
  }

  _changeAccount(Account toBeChangedAccount,Account currAccount){
    if (!_authenticationService.matchAccount(toBeChangedAccount, currAccount)) {
      //Remove account from the list first
      accounts.removeAt(accounts.indexOf(toBeChangedAccount));
      //Add the account back at the first position
      accounts.insert(0, toBeChangedAccount);
      _authenticationService.saveLogin(toBeChangedAccount);
      _torrentService?.refreshTorrentList();
      _navigationService.navigateTo(Routes.splashView);
    }else{
      _navigationService.popRepeated(1);
      _userPreferencesService.setShowAllAccounts(false);
    }

  }

  _showAllAccountsWidget(Function onTap,bool showAllAccounts,BuildContext context) {
    return Container(
          child: ListTile(
            dense: true,
            leading: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: showAllAccounts
                    ? Theme.of(context).accentColor
                    : Theme.of(context).disabledColor,
              ),
            ),
            onTap: ()=>onTap(),
            title: Text(
              'All Accounts',
              style: TextStyle(fontSize: 12),
            ),
          ),
        );
  }

  _setAllAccounts() {
    _userPreferencesService.setShowAllAccounts(true);
    _torrentService?.refreshTorrentList();
  }

  List<Widget> _getFilterTileList(model) {
    // ignore: unnecessary_cast
    return filterTileIcons.asMap().map((index, icon) => MapEntry(index, _getFilterTile(index,icon,model))).values.toList() as List<Widget>;
  }


  FilterTile _getFilterTile(int index, icon, model) {
    return FilterTile(model: model, filter: Filter.values[index] , icon: icon);
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

}