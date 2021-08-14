
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/services/api/prod_api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:rutorrentflutter/services/state_services/history_service.dart';

@GenerateMocks(
  [],
  customMocks:[
    MockSpec<ProdApiService>(returnNullOnMissingStub: true),
  ]
)
ProdApiService getAndRegisterProdApiServiceMock() {
  _removeRegistrationIfExists<ProdApiService>();
  final service = ProdApiService();
  locator.registerSingleton<ProdApiService>(service);
  return service;
}
HistoryService getAndRegisterHistoryServiceMock() {
  _removeRegistrationIfExists<HistoryService>();
  final service = HistoryService();
  locator.registerSingleton<HistoryService>(service);
  return service;
}

void registerServices(){
  getAndRegisterProdApiServiceMock();
  getAndRegisterHistoryServiceMock();
}
void unregisterServices(){
  locator.unregister<ProdApiService>();
  locator.unregister<HistoryService>();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}