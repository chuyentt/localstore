part of localstore;

abstract class DocumentRefImpl {
  CollectionRef collection(String path);
  Future<dynamic> set(Map<String, dynamic> data, [SetOptions? options]);
  Future<Map<String, dynamic>?> get();
  Future delete();
  void dispose();
}
