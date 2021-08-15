import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:mockito/mockito.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/services/api/prod_api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:rutorrentflutter/services/functional_services/authentication_service.dart';
import 'package:rutorrentflutter/services/functional_services/disk_space_service.dart';
import 'package:rutorrentflutter/services/functional_services/notification_service.dart';
import 'package:rutorrentflutter/services/functional_services/shared_preferences_service.dart';
import 'package:rutorrentflutter/services/state_services/disk_file_service.dart';
import 'package:rutorrentflutter/services/state_services/history_service.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart';

import 'test_data.dart';
import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<ProdApiService>(returnNullOnMissingStub: true),
  MockSpec<HistoryService>(returnNullOnMissingStub: true),
  MockSpec<AuthenticationService>(returnNullOnMissingStub: true),
  MockSpec<DiskSpaceService>(returnNullOnMissingStub: true),
  MockSpec<TorrentService>(returnNullOnMissingStub: true),
  MockSpec<DiskFileService>(returnNullOnMissingStub: true),
  MockSpec<UserPreferencesService>(returnNullOnMissingStub: true),
  MockSpec<SharedPreferencesService>(returnNullOnMissingStub: true),
  MockSpec<NotificationService>(returnNullOnMissingStub: true),
])
ProdApiService getAndRegisterProdApiServiceMock() {
  print("getAndRegisterProdApiServiceMock");
  _removeRegistrationIfExists<ProdApiService>();
  final service = ProdApiService();
  when(service.historyPluginUrl)
      .thenAnswer((realInvocation) => TestData.historyPluginUrl);
  
  locator.registerSingleton<ProdApiService>(service);
  return service;
}

HistoryService getAndRegisterHistoryServiceMock() {
  print("getAndRegisterHistoryServiceMock");
  _removeRegistrationIfExists<HistoryService>();
  final service = HistoryService();
  locator.registerSingleton<HistoryService>(service);
  return service;
}

AuthenticationService getAndRegisterAuthenticationService() {
  print("getAndRegisterAuthenticationService");
  _removeRegistrationIfExists<AuthenticationService>();
  final service = MockAuthenticationService();
  when(service.accounts)
      .thenAnswer((realInvocation) => TestData.accounts);
  locator.registerSingleton<AuthenticationService>(service);
  return service;
}

DiskSpaceService getAndRegisterDiskSpaceService() {
  print("getAndRegisterDiskSpaceService");
  _removeRegistrationIfExists<DiskSpaceService>();
  final service = MockDiskSpaceService();
  locator.registerSingleton<DiskSpaceService>(service);
  return service;
}

TorrentService getAndRegisterTorrentService() {
  print("getAndRegisterTorrentService");
  _removeRegistrationIfExists<TorrentService>();
  final service = MockTorrentService();
  locator.registerSingleton<TorrentService>(service);
  return service;
}

DiskFileService getAndRegisterDiskFileService() {
  print("getAndRegisterDiskFileService");
  _removeRegistrationIfExists<DiskFileService>();
  final service = MockDiskFileService();
  locator.registerSingleton<DiskFileService>(service);
  return service;
}
UserPreferencesService getAndRegisterUserPreferencesService() {
  print("getAndRegisterUserPreferencesService");
 _removeRegistrationIfExists<UserPreferencesService>();
 final service = MockUserPreferencesService();
 locator.registerSingleton<UserPreferencesService>(service);
 return service;
}
SharedPreferencesService getAndRegisterSharedPreferencesService() {
  print("getAndRegisterSharedPreferencesService");
 _removeRegistrationIfExists<SharedPreferencesService>();
 final service = MockSharedPreferencesService();
 locator.registerSingleton<SharedPreferencesService>(service);
 return service;
}
NotificationService getAndRegisterNotificationService() {
  print("getAndRegisterNotificationService");
 _removeRegistrationIfExists<NotificationService>();
 final service = MockNotificationService();
 locator.registerSingleton<NotificationService>(service);
 return service;
}

void registerServices() {
  getAndRegisterSharedPreferencesService();
  getAndRegisterNotificationService();
  getAndRegisterUserPreferencesService();
  getAndRegisterAuthenticationService();
  getAndRegisterHistoryServiceMock();
  getAndRegisterDiskSpaceService();
  getAndRegisterTorrentService();
  getAndRegisterDiskFileService();
  getAndRegisterProdApiServiceMock();
}

void unregisterServices() {
  locator.unregister<SharedPreferencesService>();
  locator.unregister<NotificationService>();
  locator.unregister<UserPreferencesService>();
  locator.unregister<ProdApiService>();
  locator.unregister<HistoryService>();
  locator.unregister<AuthenticationService>();
  locator.unregister<DiskSpaceService>();
  locator.unregister<TorrentService>();
  locator.unregister<DiskFileService>();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
