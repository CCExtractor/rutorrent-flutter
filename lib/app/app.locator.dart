// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../AppTheme/AppStateNotifier.dart';
import '../services/functional_services/api_service.dart';
import '../services/functional_services/authentication_service.dart';
import '../services/functional_services/disk_space_service.dart';
import '../services/functional_services/internet_service.dart';
import '../services/functional_services/shared_preferences_service.dart';
import '../services/state_services/torrent_service.dart';
import '../services/state_services/user_preferences_service.dart';
import '../utils/file_picker_service.dart';

final locator = StackedLocator.instance;

void setupLocator({String? environment, EnvironmentFilter? environmentFilter}) {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => ApiService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => SharedPreferencesService());
  locator.registerLazySingleton(() => DiskSpaceService());
  locator.registerLazySingleton(() => InternetService());
  locator.registerLazySingleton(() => AppStateNotifier());
  locator.registerLazySingleton(() => FilePickerService());
  locator.registerLazySingleton(() => UserPreferencesService());
  locator.registerLazySingleton(() => TorrentService());
}
