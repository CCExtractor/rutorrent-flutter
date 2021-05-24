
import 'package:rutorrentflutter/AppTheme/AppStateNotifier.dart';
import 'package:rutorrentflutter/services/functional_services/api_service.dart';
import 'package:rutorrentflutter/services/functional_services/authentication_service.dart';
import 'package:rutorrentflutter/services/functional_services/disk_space_service.dart';
import 'package:rutorrentflutter/services/functional_services/internet_service.dart';
import 'package:rutorrentflutter/services/functional_services/shared_preferences_service.dart';
import 'package:rutorrentflutter/services/state_services/file_service.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';
import 'package:rutorrentflutter/ui/views/Disk%20Explorer/disk_explorer_view.dart';
import 'package:rutorrentflutter/ui/views/History/history_view.dart';
import 'package:rutorrentflutter/ui/views/Settings/settings_view.dart';
import 'package:rutorrentflutter/ui/views/Video%20Stream/video_stream_view.dart';
import 'package:rutorrentflutter/utils/file_picker_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../ui/views/home/home_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/splash/splash_view.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: SplashView,initial:true),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: HistoryView),
    MaterialRoute(page: SettingsView),
    MaterialRoute(page: DiskExplorerView), 
    MaterialRoute(page: VideoStreamView), 
  ],
  dependencies: [
    LazySingleton(classType:SharedPreferencesService),
    LazySingleton(classType:AuthenticationService),
    LazySingleton(classType:ApiService),
    LazySingleton(classType:NavigationService),
    LazySingleton(classType:DialogService),
    LazySingleton(classType:SnackbarService),
    LazySingleton(classType:BottomSheetService),
    LazySingleton(classType:DiskSpaceService),
    LazySingleton(classType:InternetService),
    LazySingleton(classType:AppStateNotifier),
    LazySingleton(classType:FilePickerService),
    LazySingleton(classType:UserPreferencesService),
    LazySingleton(classType:TorrentService),
    LazySingleton(classType:FileService),
  ],
  logger: StackedLogger(),
)
class AppSetup{

}