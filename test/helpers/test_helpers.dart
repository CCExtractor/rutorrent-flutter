import 'package:http/io_client.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/services/api/http_client_service.dart';
import 'package:rutorrentflutter/services/api/prod_api_service.dart';
import 'package:rutorrentflutter/services/functional_services/authentication_service.dart';
import 'package:rutorrentflutter/services/functional_services/disk_space_service.dart';
import 'package:rutorrentflutter/services/functional_services/notification_service.dart';
import 'package:rutorrentflutter/services/functional_services/shared_preferences_service.dart';
import 'package:rutorrentflutter/services/state_services/disk_file_service.dart';
import 'package:rutorrentflutter/services/state_services/history_service.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';

import 'mock_ioclient.dart';
import 'test_data.dart';
import 'test_helpers.mocks.dart';

Logger log = getLogger("test_helpers.dart");

@GenerateMocks([], customMocks: [
  MockSpec<HistoryService>(returnNullOnMissingStub: true),
  MockSpec<AuthenticationService>(returnNullOnMissingStub: true),
  MockSpec<DiskSpaceService>(returnNullOnMissingStub: true),
  MockSpec<TorrentService>(returnNullOnMissingStub: true),
  MockSpec<DiskFileService>(returnNullOnMissingStub: true),
  MockSpec<UserPreferencesService>(returnNullOnMissingStub: true),
  MockSpec<SharedPreferencesService>(returnNullOnMissingStub: true),
  MockSpec<NotificationService>(returnNullOnMissingStub: true),
  MockSpec<IOClient>(returnNullOnMissingStub: true),
  MockSpec<HttpIOClient>(returnNullOnMissingStub: true),
  MockSpec<ProdApiService>(returnNullOnMissingStub: true),
])
ProdApiService getAndRegisterProdApiServiceMock({mock = true}) {
  log.v("getAndRegisterProdApiServiceMock");
  _removeRegistrationIfExists<ProdApiService>();

  final service = mock ? MockProdApiService() : ProdApiService();
  // when(service.historyPluginUrl)
  //     .thenAnswer((realInvocation) => TestData.historyPluginUrl);
  // when(service.getAuthHeader())
  //     .thenAnswer((realInvocation) => TestData.authHeader);
  // when(service.ioClient).thenReturn(getAndRegisterIOClientMock());
  locator.registerSingleton<ProdApiService>(service);
  return service;
}

IOClient getAndRegisterIOClientMock({mock = true}) {
  log.v("getAndRegisterIOClientMock");
  _removeRegistrationIfExists<IOClient>();
  final service = mock ? MockIOClientExtention() : IOClient();
  locator.registerSingleton<IOClient>(service);
  return service;
}

HttpIOClient getAndRegisterHttpIOClientMock({mock = true}) {
  log.v("getAndRegisterHttpIOClientMock");
  _removeRegistrationIfExists<HttpIOClient>();
  final service = mock ? MockHttpIOClient() : HttpIOClient();
  when(service.getIOClient()).thenReturn(getAndRegisterIOClientMock());
  locator.registerSingleton<HttpIOClient>(service);
  return service;
}

//Registers real class NOT the generated mocked version
HistoryService getAndRegisterHistoryService({mock = true}) {
  log.v("getAndRegisterHistoryService");
  _removeRegistrationIfExists<HistoryService>();
  final service = mock ? MockHistoryService() : HistoryService();
  locator.registerSingleton<HistoryService>(service);
  return service;
}

AuthenticationService getAndRegisterAuthenticationService({mock = true}) {
  log.v("getAndRegisterAuthenticationService");
  _removeRegistrationIfExists<AuthenticationService>();
  final service = mock ? MockAuthenticationService() : AuthenticationService();
  when(service.accounts).thenReturn(TestData.accounts);
  locator.registerSingleton<AuthenticationService>(service);
  return service;
}

DiskSpaceService getAndRegisterDiskSpaceService({mock = true}) {
  log.v("getAndRegisterDiskSpaceService");
  _removeRegistrationIfExists<DiskSpaceService>();
  final service = mock ? MockDiskSpaceService() : DiskSpaceService();
  locator.registerSingleton<DiskSpaceService>(service);
  return service;
}

TorrentService getAndRegisterTorrentService({mock = true}) {
  log.v("getAndRegisterTorrentService");
  _removeRegistrationIfExists<TorrentService>();
  final service = mock ? MockTorrentService() : TorrentService();
  locator.registerSingleton<TorrentService>(service);
  return service;
}

DiskFileService getAndRegisterDiskFileService({mock = true}) {
  log.v("getAndRegisterDiskFileService");
  _removeRegistrationIfExists<DiskFileService>();
  final service = mock ? MockDiskFileService() : DiskFileService();
  locator.registerSingleton<DiskFileService>(service);
  return service;
}

UserPreferencesService getAndRegisterUserPreferencesService({mock = true}) {
  log.v("getAndRegisterUserPreferencesService");
  _removeRegistrationIfExists<UserPreferencesService>();
  final service =
      mock ? MockUserPreferencesService() : UserPreferencesService();
  locator.registerSingleton<UserPreferencesService>(service);
  return service;
}

SharedPreferencesService getAndRegisterSharedPreferencesService({mock = true}) {
  log.v("getAndRegisterSharedPreferencesService");
  _removeRegistrationIfExists<SharedPreferencesService>();
  final service =
      mock ? MockSharedPreferencesService() : SharedPreferencesService();
  locator.registerSingleton<SharedPreferencesService>(service);
  return service;
}

NotificationService getAndRegisterNotificationService({mock = true}) {
  log.v("getAndRegisterNotificationService");
  _removeRegistrationIfExists<NotificationService>();
  final service = mock ? MockNotificationService() : NotificationService();
  locator.registerSingleton<NotificationService>(service);
  return service;
}

void registerServices() {
  log.i("registerServices");
  getAndRegisterSharedPreferencesService();
  getAndRegisterNotificationService();
  getAndRegisterUserPreferencesService();
  getAndRegisterAuthenticationService();
  getAndRegisterHistoryService();
  getAndRegisterDiskSpaceService();
  getAndRegisterTorrentService();
  getAndRegisterDiskFileService();
  getAndRegisterIOClientMock();
  getAndRegisterHttpIOClientMock();
  getAndRegisterProdApiServiceMock();
}

void unregisterServices() {
  log.i("unregisterServices");
  _removeRegistrationIfExists<SharedPreferencesService>();
  _removeRegistrationIfExists<NotificationService>();
  _removeRegistrationIfExists<UserPreferencesService>();
  _removeRegistrationIfExists<ProdApiService>();
  _removeRegistrationIfExists<HistoryService>();
  _removeRegistrationIfExists<AuthenticationService>();
  _removeRegistrationIfExists<DiskSpaceService>();
  _removeRegistrationIfExists<TorrentService>();
  _removeRegistrationIfExists<DiskFileService>();
  _removeRegistrationIfExists<IOClient>();
  _removeRegistrationIfExists<HttpIOClient>();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
