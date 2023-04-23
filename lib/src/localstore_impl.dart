part of localstore;

/// The interface that other Localstore must extend.
abstract class LocalstoreImpl {
  /// Gets a [CollectionRef] for the specified Localstore path.
  CollectionRef collection(String path);

  /// Get the directory where the database is stored
  Future<Directory> getDatabaseDirectory();

  /// Set the directory where the database is stored
  void setDatabaseDirectory(Directory dir);
}
