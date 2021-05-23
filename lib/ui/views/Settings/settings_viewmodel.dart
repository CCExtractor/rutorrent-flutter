import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.router.dart';
import 'package:rutorrentflutter/enums/bottom_sheet_type.dart';
import 'package:rutorrentflutter/services/functional_services/authentication_service.dart';
import 'package:rutorrentflutter/services/functional_services/shared_preferences_service.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/delete_account_widget.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/password_change_dialog_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SettingsViewModel extends BaseViewModel {

  AuthenticationService _authenticationService = locator<AuthenticationService>();
  UserPreferencesService _userPreferencesService = locator<UserPreferencesService>();
  SharedPreferencesService _sharedPreferencesService = locator<SharedPreferencesService>();
  NavigationService _navigationService = locator<NavigationService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  TextEditingController passwordFieldController = TextEditingController();

  get accounts => _authenticationService.accounts;

  get allNotificationEnabled => _userPreferencesService.allNotificationEnabled;

  get diskSpaceNotification => _userPreferencesService.diskSpaceNotification;

  get addTorrentNotification => _userPreferencesService.addTorrentNotification;

  get downloadCompleteNotification => _userPreferencesService.downloadCompleteNotification;

  showPasswordChangeDialog(context,index) {
    showDialog(context: context, builder: (context)=>PasswordChangeDialog(onTap: changePassword, fieldController: passwordFieldController,index:index));
  }

  showDeleteAccountDialog(context,int index) {
    showDialog(context: context, builder: (context)=>
    DeleteAccountDialog(
      length: _authenticationService.accounts?.length,
      leftFunc: ()=>_navigationService.popRepeated(1),
      rightFunc: deleteAccount,
      index: index,
    ));
  }

  changePassword(int index) async {
    setBusy(true);
    await _authenticationService.changePassword(index,passwordFieldController.text);
    _navigationService.popRepeated(1);
    _navigationService.navigateTo(Routes.splashView);
    setBusy(false);
  }

  deleteAccount(int index) {
    _authenticationService.deleteAccount(index);
    _navigationService.popRepeated(1);
    _navigationService.navigateTo(Routes.splashView);
  }

  logoutAllAccounts() async {
    SheetResponse? sheetReponse = await  _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.confirmBottomSheet,
      title: "Are you sure you want to logout from all saved accounts?",
      description: "This will log you out from all accounts",
      mainButtonTitle: "Yes",
      secondaryButtonTitle: "No",
    ); 
    _navigationService.popRepeated(1);
    if(sheetReponse?.confirmed ?? false){
      _authenticationService.logoutAllAccounts();
      await _sharedPreferencesService.clearLogin();
      _navigationService.navigateTo(Routes.splashView);
    }
  }

  toggleAllNotificationsEnabled() {_userPreferencesService.toggleAllNotificationsEnabled();notifyListeners();}
  toggleDiskSpaceNotification() {_userPreferencesService.toggleDiskSpaceNotification();notifyListeners();}
  toggleAddTorrentNotification() {_userPreferencesService.toggleAddTorrentNotification();notifyListeners();}
  toggleDownloadCompleteNotification() {_userPreferencesService.toggleDownloadCompleteNotification();notifyListeners();}
}