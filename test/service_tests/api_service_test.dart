import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('ApiServiceTests -', () {
    group('StartUp -', () {
      setUp(() => registerServices());
      tearDown(() => unregisterServices());
    });

    group('Update History -', () {
      test(
          'When update history network call made, should populate history items',
          () async {
        //todo Implement Test
      });
    });
  });
}
