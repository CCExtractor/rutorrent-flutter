import 'package:rutorrentflutter/services/api/dev_api_service.dart';
import 'package:rutorrentflutter/services/api/i_api_service.dart';
import 'package:rutorrentflutter/services/api/prod_api_service.dart';
import 'package:rutorrentflutter/services/functional_services/authentication_service.dart';
import 'package:rutorrentflutter/services/functional_services/disk_space_service.dart';
import 'package:rutorrentflutter/services/functional_services/internet_service.dart';
import 'package:rutorrentflutter/services/functional_services/notification_service.dart';
import 'package:rutorrentflutter/services/functional_services/shared_preferences_service.dart';
import 'package:rutorrentflutter/services/state_services/disk_file_service.dart';
import 'package:rutorrentflutter/services/state_services/file_service.dart';
import 'package:rutorrentflutter/services/state_services/history_service.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';
import 'package:rutorrentflutter/theme/app_state_notifier.dart';
import 'package:rutorrentflutter/ui/views/History/history_view.dart';
import 'package:rutorrentflutter/ui/views/Settings/settings_view.dart';
import 'package:rutorrentflutter/ui/views/disk_explorer/disk_explorer_view.dart';
import 'package:rutorrentflutter/ui/views/media_player/media_stream_view.dart';
import 'package:rutorrentflutter/ui/views/torrent_detail/torrent_detail_view.dart';
import 'package:rutorrentflutter/utils/file_picker_service.dart';
import 'package:rutorrentflutter/utils/package_info_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../ui/views/home/home_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/splash/splash_view.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: SplashView, initial: true),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: HistoryView),
    MaterialRoute(page: SettingsView),
    MaterialRoute(page: DiskExplorerView),
    MaterialRoute(page: MediaStreamView),
    MaterialRoute(page: TorrentDetailView),
  ],
  dependencies: [
    LazySingleton(classType: SharedPreferencesService),
    LazySingleton(classType: AuthenticationService),
    LazySingleton(
      classType: ProdApiService,
      asType: IApiService,
      environments: {Environment.prod},
    ),
    LazySingleton(
      classType: DevApiService,
      asType: IApiService,
      environments: {Environment.dev},
    ),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DiskSpaceService),
    LazySingleton(classType: NotificationService),
    LazySingleton(classType: UserPreferencesService),
    LazySingleton(classType: InternetService),
    LazySingleton(classType: HistoryService),
    LazySingleton(classType: AppStateNotifier),
    LazySingleton(classType: FileService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: FilePickerService),
    LazySingleton(classType: TorrentService),
    LazySingleton(classType: PackageInfoService),
    LazySingleton(classType: DiskFileService),
  ],
  logger: StackedLogger(),
)
class AppSetup {}
