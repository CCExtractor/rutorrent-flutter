// Mocks generated by Mockito 5.2.0 from annotations
// in rutorrentflutter/test/helpers/test_helpers.dart.
// Do not manually edit this file.

import 'dart:async' as _i15;
import 'dart:convert' as _i28;
import 'dart:typed_data' as _i29;
import 'dart:ui' as _i12;

import 'package:awesome_notifications/awesome_notifications.dart' as _i26;
import 'package:flutter/foundation.dart' as _i2;
import 'package:flutter/material.dart' as _i4;
import 'package:hive/hive.dart' as _i5;
import 'package:http/io_client.dart' as _i8;
import 'package:http/src/base_request.dart' as _i27;
import 'package:http/src/io_streamed_response.dart' as _i6;
import 'package:http/src/response.dart' as _i7;
import 'package:mockito/mockito.dart' as _i1;
import 'package:package_info/package_info.dart' as _i22;
import 'package:rutorrentflutter/enums/enums.dart' as _i11;
import 'package:rutorrentflutter/models/account.dart' as _i14;
import 'package:rutorrentflutter/models/disk_file.dart' as _i20;
import 'package:rutorrentflutter/models/disk_space.dart' as _i3;
import 'package:rutorrentflutter/models/history_item.dart' as _i10;
import 'package:rutorrentflutter/models/rss.dart' as _i33;
import 'package:rutorrentflutter/models/rss_filter.dart' as _i34;
import 'package:rutorrentflutter/models/torrent.dart' as _i18;
import 'package:rutorrentflutter/models/torrent_file.dart' as _i32;
import 'package:rutorrentflutter/services/api/http_client_service.dart' as _i30;
import 'package:rutorrentflutter/services/api/prod_api_service.dart' as _i31;
import 'package:rutorrentflutter/services/functional_services/authentication_service.dart'
    as _i13;
import 'package:rutorrentflutter/services/functional_services/disk_space_service.dart'
    as _i16;
import 'package:rutorrentflutter/services/functional_services/notification_service.dart'
    as _i25;
import 'package:rutorrentflutter/services/functional_services/shared_preferences_service.dart'
    as _i23;
import 'package:rutorrentflutter/services/state_services/disk_file_service.dart'
    as _i19;
import 'package:rutorrentflutter/services/state_services/history_service.dart'
    as _i9;
import 'package:rutorrentflutter/services/state_services/torrent_service.dart'
    as _i17;
import 'package:rutorrentflutter/services/state_services/user_preferences_service.dart'
    as _i21;
import 'package:shared_preferences/shared_preferences.dart' as _i24;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeValueNotifier_0<T> extends _i1.Fake implements _i2.ValueNotifier<T> {
}

class _FakeDiskSpace_1 extends _i1.Fake implements _i3.DiskSpace {}

class _FakeTextEditingController_2 extends _i1.Fake
    implements _i4.TextEditingController {}

class _FakeBox_3<E> extends _i1.Fake implements _i5.Box<E> {}

class _FakeIOStreamedResponse_4 extends _i1.Fake
    implements _i6.IOStreamedResponse {}

class _FakeResponse_5 extends _i1.Fake implements _i7.Response {}

class _FakeIOClient_6 extends _i1.Fake implements _i8.IOClient {}

/// A class which mocks [HistoryService].
///
/// See the documentation for Mockito's code generation for more information.
class MockHistoryService extends _i1.Mock implements _i9.HistoryService {
  @override
  _i2.ValueNotifier<List<_i10.HistoryItem>> get torrentsHistoryList =>
      (super.noSuchMethod(Invocation.getter(#torrentsHistoryList),
              returnValue: _FakeValueNotifier_0<List<_i10.HistoryItem>>())
          as _i2.ValueNotifier<List<_i10.HistoryItem>>);
  @override
  _i2.ValueNotifier<List<_i10.HistoryItem>> get displayTorrentHistoryList =>
      (super.noSuchMethod(Invocation.getter(#displayTorrentHistoryList),
              returnValue: _FakeValueNotifier_0<List<_i10.HistoryItem>>())
          as _i2.ValueNotifier<List<_i10.HistoryItem>>);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  dynamic setTorrentHistoryList(List<_i10.HistoryItem>? list) =>
      super.noSuchMethod(Invocation.method(#setTorrentHistoryList, [list]));
  @override
  void setSortPreference(_i11.Sort? newPreference) =>
      super.noSuchMethod(Invocation.method(#setSortPreference, [newPreference]),
          returnValueForMissingStub: null);
  @override
  void addListener(_i12.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i12.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [AuthenticationService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationService extends _i1.Mock
    implements _i13.AuthenticationService {
  @override
  _i2.ValueNotifier<List<_i14.Account>> get accounts =>
      (super.noSuchMethod(Invocation.getter(#accounts),
              returnValue: _FakeValueNotifier_0<List<_i14.Account>>())
          as _i2.ValueNotifier<List<_i14.Account>>);
  @override
  set accounts(dynamic accounts) =>
      super.noSuchMethod(Invocation.setter(#accounts, accounts),
          returnValueForMissingStub: null);
  @override
  set tempAccount(dynamic account) =>
      super.noSuchMethod(Invocation.setter(#tempAccount, account),
          returnValueForMissingStub: null);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i15.Future<_i2.ValueNotifier<List<_i14.Account>>> getAccount() =>
      (super.noSuchMethod(Invocation.method(#getAccount, []),
              returnValue: Future<_i2.ValueNotifier<List<_i14.Account>>>.value(
                  _FakeValueNotifier_0<List<_i14.Account>>()))
          as _i15.Future<_i2.ValueNotifier<List<_i14.Account>>>);
  @override
  _i15.Future<List<_i14.Account?>> saveLogin(_i14.Account? account) =>
      (super.noSuchMethod(Invocation.method(#saveLogin, [account]),
              returnValue: Future<List<_i14.Account?>>.value(<_i14.Account?>[]))
          as _i15.Future<List<_i14.Account?>>);
  @override
  bool matchAccount(_i14.Account? api1, _i14.Account? api2) =>
      (super.noSuchMethod(Invocation.method(#matchAccount, [api1, api2]),
          returnValue: false) as bool);
  @override
  _i15.Future<bool> changePassword(int? index, String? password) =>
      (super.noSuchMethod(Invocation.method(#changePassword, [index, password]),
          returnValue: Future<bool>.value(false)) as _i15.Future<bool>);
  @override
  void deleteAccount(int? index) =>
      super.noSuchMethod(Invocation.method(#deleteAccount, [index]),
          returnValueForMissingStub: null);
  @override
  void logoutAllAccounts() =>
      super.noSuchMethod(Invocation.method(#logoutAllAccounts, []),
          returnValueForMissingStub: null);
  @override
  void removeAccount(int? index) =>
      super.noSuchMethod(Invocation.method(#removeAccount, [index]),
          returnValueForMissingStub: null);
  @override
  void addListener(_i12.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i12.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [DiskSpaceService].
///
/// See the documentation for Mockito's code generation for more information.
class MockDiskSpaceService extends _i1.Mock implements _i16.DiskSpaceService {
  @override
  _i3.DiskSpace get diskSpace =>
      (super.noSuchMethod(Invocation.getter(#diskSpace),
          returnValue: _FakeDiskSpace_1()) as _i3.DiskSpace);
}

/// A class which mocks [TorrentService].
///
/// See the documentation for Mockito's code generation for more information.
class MockTorrentService extends _i1.Mock implements _i17.TorrentService {
  @override
  _i2.ValueNotifier<List<String?>> get listOfLabels =>
      (super.noSuchMethod(Invocation.getter(#listOfLabels),
              returnValue: _FakeValueNotifier_0<List<String?>>())
          as _i2.ValueNotifier<List<String?>>);
  @override
  _i2.ValueNotifier<List<_i18.Torrent>> get activeDownloads =>
      (super.noSuchMethod(Invocation.getter(#activeDownloads),
              returnValue: _FakeValueNotifier_0<List<_i18.Torrent>>())
          as _i2.ValueNotifier<List<_i18.Torrent>>);
  @override
  _i2.ValueNotifier<List<_i18.Torrent>> get torrentsList =>
      (super.noSuchMethod(Invocation.getter(#torrentsList),
              returnValue: _FakeValueNotifier_0<List<_i18.Torrent>>())
          as _i2.ValueNotifier<List<_i18.Torrent>>);
  @override
  _i2.ValueNotifier<List<_i18.Torrent>> get displayTorrentList =>
      (super.noSuchMethod(Invocation.getter(#displayTorrentList),
              returnValue: _FakeValueNotifier_0<List<_i18.Torrent>>())
          as _i2.ValueNotifier<List<_i18.Torrent>>);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  dynamic setListOfLabels(List<String>? labels) =>
      super.noSuchMethod(Invocation.method(#setListOfLabels, [labels]));
  @override
  dynamic changeLabel(String? label) =>
      super.noSuchMethod(Invocation.method(#changeLabel, [label]));
  @override
  dynamic changeFilter(_i11.Filter? filter) =>
      super.noSuchMethod(Invocation.method(#changeFilter, [filter]));
  @override
  dynamic setActiveDownloads(List<_i18.Torrent>? list) =>
      super.noSuchMethod(Invocation.method(#setActiveDownloads, [list]));
  @override
  dynamic setTorrentList(List<_i18.Torrent>? list) =>
      super.noSuchMethod(Invocation.method(#setTorrentList, [list]));
  @override
  dynamic setSortPreference(_i11.Sort? newPreference) => super
      .noSuchMethod(Invocation.method(#setSortPreference, [newPreference]));
  @override
  dynamic removeTorrent(String? hashValue) =>
      super.noSuchMethod(Invocation.method(#removeTorrent, [hashValue]));
  @override
  dynamic removeTorrentWithData(String? hashValue) => super
      .noSuchMethod(Invocation.method(#removeTorrentWithData, [hashValue]));
  @override
  void addListener(_i12.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i12.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [DiskFileService].
///
/// See the documentation for Mockito's code generation for more information.
class MockDiskFileService extends _i1.Mock implements _i19.DiskFileService {
  @override
  _i2.ValueNotifier<List<_i20.DiskFile>> get diskFileList =>
      (super.noSuchMethod(Invocation.getter(#diskFileList),
              returnValue: _FakeValueNotifier_0<List<_i20.DiskFile>>())
          as _i2.ValueNotifier<List<_i20.DiskFile>>);
  @override
  _i2.ValueNotifier<List<_i20.DiskFile>> get diskFileDisplayList =>
      (super.noSuchMethod(Invocation.getter(#diskFileDisplayList),
              returnValue: _FakeValueNotifier_0<List<_i20.DiskFile>>())
          as _i2.ValueNotifier<List<_i20.DiskFile>>);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  dynamic setDiskFileList(List<_i20.DiskFile>? list) =>
      super.noSuchMethod(Invocation.method(#setDiskFileList, [list]));
  @override
  dynamic setSortPreference(_i11.Sort? newPreference) => super
      .noSuchMethod(Invocation.method(#setSortPreference, [newPreference]));
  @override
  void addListener(_i12.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i12.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [UserPreferencesService].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserPreferencesService extends _i1.Mock
    implements _i21.UserPreferencesService {
  @override
  _i4.TextEditingController get searchTextController =>
      (super.noSuchMethod(Invocation.getter(#searchTextController),
              returnValue: _FakeTextEditingController_2())
          as _i4.TextEditingController);
  @override
  set searchTextController(_i4.TextEditingController? _searchTextController) =>
      super.noSuchMethod(
          Invocation.setter(#searchTextController, _searchTextController),
          returnValueForMissingStub: null);
  @override
  bool get showAllAccounts => (super
          .noSuchMethod(Invocation.getter(#showAllAccounts), returnValue: false)
      as bool);
  @override
  set showAllAccounts(bool? _showAllAccounts) =>
      super.noSuchMethod(Invocation.setter(#showAllAccounts, _showAllAccounts),
          returnValueForMissingStub: null);
  @override
  dynamic setShowAllAccounts(bool? showAccounts) => super
      .noSuchMethod(Invocation.method(#setShowAllAccounts, [showAccounts]));
  @override
  dynamic setAllNotification(bool? newVal) =>
      super.noSuchMethod(Invocation.method(#setAllNotification, [newVal]));
  @override
  dynamic setDiskSpaceNotification(bool? newVal) => super
      .noSuchMethod(Invocation.method(#setDiskSpaceNotification, [newVal]));
  @override
  dynamic setAddTorrentNotification(bool? newVal) => super
      .noSuchMethod(Invocation.method(#setAddTorrentNotification, [newVal]));
  @override
  dynamic setDownloadCompleteNotification(bool? newVal) => super.noSuchMethod(
      Invocation.method(#setDownloadCompleteNotification, [newVal]));
  @override
  dynamic setDarkMode(bool? newVal) =>
      super.noSuchMethod(Invocation.method(#setDarkMode, [newVal]));
  @override
  dynamic setPackageInfo(_i22.PackageInfo? newVal) =>
      super.noSuchMethod(Invocation.method(#setPackageInfo, [newVal]));
}

/// A class which mocks [SharedPreferencesService].
///
/// See the documentation for Mockito's code generation for more information.
class MockSharedPreferencesService extends _i1.Mock
    implements _i23.SharedPreferencesService {
  @override
  String get accountsData =>
      (super.noSuchMethod(Invocation.getter(#accountsData), returnValue: '')
          as String);
  @override
  set accountsData(String? _accountsData) =>
      super.noSuchMethod(Invocation.setter(#accountsData, _accountsData),
          returnValueForMissingStub: null);
  @override
  _i5.Box<dynamic> get DB => (super.noSuchMethod(Invocation.getter(#DB),
      returnValue: _FakeBox_3<dynamic>()) as _i5.Box<dynamic>);
  @override
  set DB(_i5.Box<dynamic>? _DB) =>
      super.noSuchMethod(Invocation.setter(#DB, _DB),
          returnValueForMissingStub: null);
  @override
  _i15.Future<_i24.SharedPreferences?> store() =>
      (super.noSuchMethod(Invocation.method(#store, []),
              returnValue: Future<_i24.SharedPreferences?>.value())
          as _i15.Future<_i24.SharedPreferences?>);
  @override
  dynamic saveLogin(List<_i14.Account?>? accounts) =>
      super.noSuchMethod(Invocation.method(#saveLogin, [accounts]));
  @override
  _i15.Future<List<_i14.Account>> fetchSavedLogin() =>
      (super.noSuchMethod(Invocation.method(#fetchSavedLogin, []),
              returnValue: Future<List<_i14.Account>>.value(<_i14.Account>[]))
          as _i15.Future<List<_i14.Account>>);
}

/// A class which mocks [NotificationService].
///
/// See the documentation for Mockito's code generation for more information.
class MockNotificationService extends _i1.Mock
    implements _i25.NotificationService {
  @override
  dynamic handleLocalNotification(_i26.ReceivedAction? receivedNotification) =>
      super.noSuchMethod(
          Invocation.method(#handleLocalNotification, [receivedNotification]));
  @override
  dynamic dispatchLocalNotification(
          {String? key, Map<dynamic, dynamic>? customData}) =>
      super.noSuchMethod(Invocation.method(#dispatchLocalNotification, [],
          {#key: key, #customData: customData}));
}

/// A class which mocks [IOClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockIOClient extends _i1.Mock implements _i8.IOClient {
  @override
  _i15.Future<_i6.IOStreamedResponse> send(_i27.BaseRequest? request) =>
      (super.noSuchMethod(Invocation.method(#send, [request]),
              returnValue: Future<_i6.IOStreamedResponse>.value(
                  _FakeIOStreamedResponse_4()))
          as _i15.Future<_i6.IOStreamedResponse>);
  @override
  void close() => super.noSuchMethod(Invocation.method(#close, []),
      returnValueForMissingStub: null);
  @override
  _i15.Future<_i7.Response> head(Uri? url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(Invocation.method(#head, [url], {#headers: headers}),
              returnValue: Future<_i7.Response>.value(_FakeResponse_5()))
          as _i15.Future<_i7.Response>);
  @override
  _i15.Future<_i7.Response> get(Uri? url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(Invocation.method(#get, [url], {#headers: headers}),
              returnValue: Future<_i7.Response>.value(_FakeResponse_5()))
          as _i15.Future<_i7.Response>);
  @override
  _i15.Future<_i7.Response> post(Uri? url,
          {Map<String, String>? headers,
          Object? body,
          _i28.Encoding? encoding}) =>
      (super.noSuchMethod(
              Invocation.method(#post, [url],
                  {#headers: headers, #body: body, #encoding: encoding}),
              returnValue: Future<_i7.Response>.value(_FakeResponse_5()))
          as _i15.Future<_i7.Response>);
  @override
  _i15.Future<_i7.Response> put(Uri? url,
          {Map<String, String>? headers,
          Object? body,
          _i28.Encoding? encoding}) =>
      (super.noSuchMethod(
              Invocation.method(#put, [url],
                  {#headers: headers, #body: body, #encoding: encoding}),
              returnValue: Future<_i7.Response>.value(_FakeResponse_5()))
          as _i15.Future<_i7.Response>);
  @override
  _i15.Future<_i7.Response> patch(Uri? url,
          {Map<String, String>? headers,
          Object? body,
          _i28.Encoding? encoding}) =>
      (super.noSuchMethod(
              Invocation.method(#patch, [url],
                  {#headers: headers, #body: body, #encoding: encoding}),
              returnValue: Future<_i7.Response>.value(_FakeResponse_5()))
          as _i15.Future<_i7.Response>);
  @override
  _i15.Future<_i7.Response> delete(Uri? url,
          {Map<String, String>? headers,
          Object? body,
          _i28.Encoding? encoding}) =>
      (super.noSuchMethod(
              Invocation.method(#delete, [url],
                  {#headers: headers, #body: body, #encoding: encoding}),
              returnValue: Future<_i7.Response>.value(_FakeResponse_5()))
          as _i15.Future<_i7.Response>);
  @override
  _i15.Future<String> read(Uri? url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(Invocation.method(#read, [url], {#headers: headers}),
          returnValue: Future<String>.value('')) as _i15.Future<String>);
  @override
  _i15.Future<_i29.Uint8List> readBytes(Uri? url,
          {Map<String, String>? headers}) =>
      (super.noSuchMethod(
              Invocation.method(#readBytes, [url], {#headers: headers}),
              returnValue: Future<_i29.Uint8List>.value(_i29.Uint8List(0)))
          as _i15.Future<_i29.Uint8List>);
}

/// A class which mocks [HttpIOClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockHttpIOClient extends _i1.Mock implements _i30.HttpIOClient {}

/// A class which mocks [ProdApiService].
///
/// See the documentation for Mockito's code generation for more information.
class MockProdApiService extends _i1.Mock implements _i31.ProdApiService {
  @override
  _i8.IOClient get ioClient => (super.noSuchMethod(Invocation.getter(#ioClient),
      returnValue: _FakeIOClient_6()) as _i8.IOClient);
  @override
  Map<String, String> getAuthHeader({_i14.Account? currentAccount}) =>
      (super.noSuchMethod(
          Invocation.method(
              #getAuthHeader, [], {#currentAccount: currentAccount}),
          returnValue: <String, String>{}) as Map<String, String>);
  @override
  _i15.Future<bool> testConnectionAndLogin(_i14.Account? account) =>
      (super.noSuchMethod(Invocation.method(#testConnectionAndLogin, [account]),
          returnValue: Future<bool>.value(false)) as _i15.Future<bool>);
  @override
  dynamic irssiLoad(String? function) =>
      super.noSuchMethod(Invocation.method(#irssiLoad, [function]));
  @override
  _i15.Future<void> updateDiskSpace() => (super.noSuchMethod(
      Invocation.method(#updateDiskSpace, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i15.Future<void>);
  @override
  _i15.Stream<List<_i18.Torrent>> getAllAccountsTorrentList() =>
      (super.noSuchMethod(Invocation.method(#getAllAccountsTorrentList, []),
              returnValue: Stream<List<_i18.Torrent>>.empty())
          as _i15.Stream<List<_i18.Torrent>>);
  @override
  _i15.Stream<List<_i18.Torrent?>?> getTorrentList() =>
      (super.noSuchMethod(Invocation.method(#getTorrentList, []),
              returnValue: Stream<List<_i18.Torrent?>?>.empty())
          as _i15.Stream<List<_i18.Torrent?>?>);
  @override
  dynamic stopTorrent(String? hashValue) =>
      super.noSuchMethod(Invocation.method(#stopTorrent, [hashValue]));
  @override
  dynamic removeTorrent(String? hashValue) =>
      super.noSuchMethod(Invocation.method(#removeTorrent, [hashValue]));
  @override
  dynamic removeTorrentWithData(String? hashValue) => super
      .noSuchMethod(Invocation.method(#removeTorrentWithData, [hashValue]));
  @override
  dynamic addTorrent(String? url) =>
      super.noSuchMethod(Invocation.method(#addTorrent, [url]));
  @override
  dynamic addTorrentFile(String? torrentPath) =>
      super.noSuchMethod(Invocation.method(#addTorrentFile, [torrentPath]));
  @override
  dynamic toggleTorrentStatus(_i18.Torrent? torrent) =>
      super.noSuchMethod(Invocation.method(#toggleTorrentStatus, [torrent]));
  @override
  _i15.Future<List<_i10.HistoryItem>> getHistory({int? lastHours}) => (super
          .noSuchMethod(
              Invocation.method(#getHistory, [], {#lastHours: lastHours}),
              returnValue:
                  Future<List<_i10.HistoryItem>>.value(<_i10.HistoryItem>[]))
      as _i15.Future<List<_i10.HistoryItem>>);
  @override
  _i15.Future<List<_i10.HistoryItem>> getAllAccountsHistory({int? lastHours}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #getAllAccountsHistory, [], {#lastHours: lastHours}),
              returnValue:
                  Future<List<_i10.HistoryItem>>.value(<_i10.HistoryItem>[]))
          as _i15.Future<List<_i10.HistoryItem>>);
  @override
  dynamic removeHistoryItem(String? hashValue) =>
      super.noSuchMethod(Invocation.method(#removeHistoryItem, [hashValue]));
  @override
  dynamic setTorrentLabel({String? hashValue, String? label}) =>
      super.noSuchMethod(Invocation.method(
          #setTorrentLabel, [], {#hashValue: hashValue, #label: label}));
  @override
  dynamic removeTorrentLabel({String? hashValue}) => super.noSuchMethod(
      Invocation.method(#removeTorrentLabel, [], {#hashValue: hashValue}));
  @override
  _i15.Future<bool> changePassword(int? index, String? newPassword) => (super
      .noSuchMethod(Invocation.method(#changePassword, [index, newPassword]),
          returnValue: Future<bool>.value(false)) as _i15.Future<bool>);
  @override
  _i15.Future<List<_i20.DiskFile>> getDiskFiles(String? path) =>
      (super.noSuchMethod(Invocation.method(#getDiskFiles, [path]),
              returnValue: Future<List<_i20.DiskFile>>.value(<_i20.DiskFile>[]))
          as _i15.Future<List<_i20.DiskFile>>);
  @override
  _i15.Future<List<_i20.DiskFile>> getAllAccountsDiskFiles(String? path) =>
      (super.noSuchMethod(Invocation.method(#getAllAccountsDiskFiles, [path]),
              returnValue: Future<List<_i20.DiskFile>>.value(<_i20.DiskFile>[]))
          as _i15.Future<List<_i20.DiskFile>>);
  @override
  _i15.Future<List<_i32.TorrentFile>> getFiles(String? hashValue) =>
      (super.noSuchMethod(Invocation.method(#getFiles, [hashValue]),
              returnValue:
                  Future<List<_i32.TorrentFile>>.value(<_i32.TorrentFile>[]))
          as _i15.Future<List<_i32.TorrentFile>>);
  @override
  _i15.Future<List<String>> getTrackers(String? hashValue) =>
      (super.noSuchMethod(Invocation.method(#getTrackers, [hashValue]),
              returnValue: Future<List<String>>.value(<String>[]))
          as _i15.Future<List<String>>);
  @override
  _i15.Future<List<_i33.RSSLabel>> loadRSS() =>
      (super.noSuchMethod(Invocation.method(#loadRSS, []),
              returnValue: Future<List<_i33.RSSLabel>>.value(<_i33.RSSLabel>[]))
          as _i15.Future<List<_i33.RSSLabel>>);
  @override
  _i15.Future<List<_i33.RSSLabel>> loadAllAccountsRSS() =>
      (super.noSuchMethod(Invocation.method(#loadAllAccountsRSS, []),
              returnValue: Future<List<_i33.RSSLabel>>.value(<_i33.RSSLabel>[]))
          as _i15.Future<List<_i33.RSSLabel>>);
  @override
  dynamic removeRSS(String? hashValue) =>
      super.noSuchMethod(Invocation.method(#removeRSS, [hashValue]));
  @override
  dynamic addRSS(String? rssUrl) =>
      super.noSuchMethod(Invocation.method(#addRSS, [rssUrl]));
  @override
  _i15.Future<bool> getRSSDetails(_i33.RSSItem? rssItem, String? labelHash) =>
      (super.noSuchMethod(
          Invocation.method(#getRSSDetails, [rssItem, labelHash]),
          returnValue: Future<bool>.value(false)) as _i15.Future<bool>);
  @override
  _i15.Future<List<_i34.RSSFilter>> getRSSFilters() => (super.noSuchMethod(
          Invocation.method(#getRSSFilters, []),
          returnValue: Future<List<_i34.RSSFilter>>.value(<_i34.RSSFilter>[]))
      as _i15.Future<List<_i34.RSSFilter>>);
  @override
  _i15.Future<List<_i34.RSSFilter>> getAllAccountsRSSFilters() =>
      (super.noSuchMethod(Invocation.method(#getAllAccountsRSSFilters, []),
              returnValue:
                  Future<List<_i34.RSSFilter>>.value(<_i34.RSSFilter>[]))
          as _i15.Future<List<_i34.RSSFilter>>);
}
