import 'package:flutter_test/flutter_test.dart';

import 'package:localstore/localstore.dart';

void main() {
  group('Localstore', () {
    final db = Localstore.instance;
    test('creates an instance', () {
      expect(db, Localstore.instance);
    });
    test('creates some collections and documents', () {
      final col = db.collection('mypath');
      final expectedCol = Localstore.instance.collection('mypath');
      expect(col, expectedCol);
      final doc = db.collection('mypath').doc();
      final expectedDoc = Localstore.instance.collection('mypath').doc(doc.id);
      expect(doc, expectedDoc);
      final newCol = col.doc(doc.id).collection('childpath');
      final expectedNewCol = Localstore.instance
          .collection('mypath')
          .doc(doc.id)
          .collection('childpath');
      expect(newCol, expectedNewCol);
      expect(newCol.parent, col);
      expect(newCol.parent?.path, col.path);
      final newDoc = newCol.doc('8rvf1dfxw');
      final expectedNewDoc = db
          .collection('mypath')
          .doc(doc.id)
          .collection('childpath')
          .doc('8rvf1dfxw');
      expect(newDoc, expectedNewDoc);
    });
  });
}
