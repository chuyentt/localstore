part of localstore;

/// The interface that other CollectionRef must extend.
abstract class CollectionRefImpl {
  /// Returns a `DocumentRef` with the provided id.
  ///
  /// If no [id] is provided, an auto-generated ID is used.
  ///
  /// The unique key generated is prefixed with a client-generated timestamp
  /// so that the resulting list will be chronologically-sorted.
  DocumentRef doc([String? id]);

  /// Notifies of query results at this collection.
  Stream<Map<String, dynamic>> get stream;
}
