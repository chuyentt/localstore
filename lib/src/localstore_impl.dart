part of localstore;

abstract class LocalstoreImpl {
  CollectionRef collection(String path);
  void dispose();
}
