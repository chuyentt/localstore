import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:localstore/localstore.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    return ".";
  });

  const MethodChannel channelMacos =
      MethodChannel('plugins.flutter.io/path_provider_macos');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channelMacos, (MethodCall methodCall) async {
    return ".";
  });
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
    test('creates and updates data', () async {
      final data = {'uid': '8rvf1dfxw', 'displayName': 'Chuyen'};
      final doc = db.collection('Users').doc();
      doc.set(data);
      final expectedDoc = db.collection('Users').doc(doc.id);
      expect(doc, expectedDoc);
      final expectedData = await doc.get();
      expect(data, expectedData);
    });

    test('delete a collection', () async {
      final data_1 = {'uid': '7rvf1dfxw', 'displayName': 'Chuyen'};
      final data_2 = {'uid': '8rvf1dfxw', 'displayName': 'Chuyen'};
      final data_3 = {'uid': '9rvf1dfxw', 'displayName': 'Chuyen'};

      await db.collection('collection1').doc(data_1['uid']).set(data_1);
      await db.collection('collection2').doc(data_1['uid']).set(data_1);
      await db.collection('collection2').doc(data_2['uid']).set(data_2);
      await db.collection('collection2').doc(data_3['uid']).set(data_3);
      await db.collection('collection1').delete();
      final expectedDataCol1 = await db.collection('collection1').get();
      debugPrint(expectedDataCol1.toString());
      expect(expectedDataCol1, null);

      // final dataCol2 = await db.collection('collection2').get();
      // expect(true, dataCol2 != null);

      // await db.collection('collection2').delete();
      // final expectedDataCol2 = await db.collection('collection2').get();
      // expect(expectedDataCol2, null);

      // await db.collection('collection2').doc(data_2['uid']).delete();
      // final data = await db.collection('collection2').doc(data_2['uid']).get();
      // expect(data, null);
    });
  });
  group('Localstore getInstance()', () {
    final db = Localstore.getInstance();
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
    test('creates and updates data', () async {
      final data = {'uid': '8rvf1dfxw', 'displayName': 'Chuyen'};
      final doc = db.collection('Users').doc();
      doc.set(data);
      final expectedDoc = db.collection('Users').doc(doc.id);
      expect(doc, expectedDoc);
      final expectedData = await doc.get();
      expect(data, expectedData);
    });

    test('delete a collection', () async {
      final data_1 = {'uid': '7rvf1dfxw', 'displayName': 'Chuyen'};
      final data_2 = {'uid': '8rvf1dfxw', 'displayName': 'Chuyen'};
      final data_3 = {'uid': '9rvf1dfxw', 'displayName': 'Chuyen'};

      await db.collection('collection1').doc(data_1['uid']).set(data_1);
      await db.collection('collection2').doc(data_1['uid']).set(data_1);
      await db.collection('collection2').doc(data_2['uid']).set(data_2);
      await db.collection('collection2').doc(data_3['uid']).set(data_3);
      await db.collection('collection1').delete();
      final expectedDataCol1 = await db.collection('collection1').get();
      debugPrint(expectedDataCol1.toString());
      expect(expectedDataCol1, null);
    });
  });
  group('Localstore getInstance(useSupportDir: true))', () {
    final db = Localstore.getInstance(useSupportDir: true);
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
    test('creates and updates data', () async {
      final data = {'uid': '8rvf1dfxw', 'displayName': 'Chuyen'};
      final doc = db.collection('Users').doc();
      doc.set(data);
      final expectedDoc = db.collection('Users').doc(doc.id);
      expect(doc, expectedDoc);
      final expectedData = await doc.get();
      expect(data, expectedData);
    });

    test('delete a collection', () async {
      final data_1 = {'uid': '7rvf1dfxw', 'displayName': 'Chuyen'};
      final data_2 = {'uid': '8rvf1dfxw', 'displayName': 'Chuyen'};
      final data_3 = {'uid': '9rvf1dfxw', 'displayName': 'Chuyen'};

      await db.collection('collection1').doc(data_1['uid']).set(data_1);
      await db.collection('collection2').doc(data_1['uid']).set(data_1);
      await db.collection('collection2').doc(data_2['uid']).set(data_2);
      await db.collection('collection2').doc(data_3['uid']).set(data_3);
      await db.collection('collection1').delete();
      final expectedDataCol1 = await db.collection('collection1').get();
      debugPrint(expectedDataCol1.toString());
      expect(expectedDataCol1, null);
    });
  });
}
