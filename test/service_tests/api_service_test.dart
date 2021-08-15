import 'package:flutter_test/flutter_test.dart';
import 'package:rutorrentflutter/models/history_item.dart';
import 'package:rutorrentflutter/services/services_info.dart';
import 'package:rutorrentflutter/services/state_services/history_service.dart';

import '../helpers/test_helpers.dart';

void main() {
 group('ApiServiceTests -', (){

   group('StartUp -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());
   });

  group('Update History -', () {
   test('When update history network call made, should populate history items', () async {

     //TODO Implement Test

   });
  });

  

 });
}