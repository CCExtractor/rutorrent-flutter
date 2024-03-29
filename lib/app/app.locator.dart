// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:stacked_core/stacked_core.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/api/dev_api_service.dart';
import '../services/api/http_client_service.dart';
import '../services/api/i_api_service.dart';
import '../services/api/prod_api_service.dart';
import '../services/functional_services/authentication_service.dart';
import '../services/functional_services/disk_space_service.dart';
import '../services/functional_services/internet_service.dart';
import '../services/functional_services/notification_service.dart';
import '../services/functional_services/shared_preferences_service.dart';
import '../services/state_services/disk_file_service.dart';
import '../services/state_services/file_service.dart';
import '../services/state_services/history_service.dart';
import '../services/state_services/torrent_service.dart';
import '../services/state_services/user_preferences_service.dart';
import '../theme/app_state_notifier.dart';
import '../utils/file_picker_service.dart';
import '../utils/package_info_service.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator(
    {String? environment, EnvironmentFilter? environmentFilter}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => SharedPreferencesService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton<IApiService>(() => ProdApiService(),
      registerFor: {"prod"});
  locator.registerLazySingleton<IApiService>(() => DevApiService(),
      registerFor: {"dev"});
  locator.registerLazySingleton(() => HttpIOClient());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DiskSpaceService());
  locator.registerLazySingleton(() => NotificationService());
  locator.registerLazySingleton(() => UserPreferencesService());
  locator.registerLazySingleton(() => InternetService());
  locator.registerLazySingleton(() => HistoryService());
  locator.registerLazySingleton(() => AppStateNotifier());
  locator.registerLazySingleton(() => FileService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => FilePickerService());
  locator.registerLazySingleton(() => TorrentService());
  locator.registerLazySingleton(() => PackageInfoService());
  locator.registerLazySingleton(() => DiskFileService());
}
