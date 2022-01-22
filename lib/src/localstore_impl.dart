part of localstore;

/// The interface that other Localstore must extend.
abstract class LocalstoreImpl {
  /// Gets a [CollectionRef] for the specified Localstore path.
  CollectionRef collection(String path);

  /// clears all [CollectionRef]s in the Database and all their [DocumentRef]s essentially resetting the Database
  Future clearAll();
}
