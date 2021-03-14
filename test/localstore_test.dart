import 'package:flutter_test/flutter_test.dart';

import 'package:localstore/localstore.dart';

void main() {
  group('Localstore', () {
    final db = Localstore.instance;
    test('create instance', () {
      expect(db, Localstore.instance);
    });
  });
}
