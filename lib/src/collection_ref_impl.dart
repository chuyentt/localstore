part of localstore;

abstract class CollectionRefImpl {
  DocumentRef doc([String? id]);
  Stream<Map<String, dynamic>> get stream;
  void dispose();
}
