part of localstore;

/// The entry point for accessing a [Localstore].
///
/// You can get an instance by calling [Localstore.instance], for example:
///
/// ```dart
/// final db = Localstore.instance;
/// ```
class Localstore implements LocalstoreImpl {
  DocumentRef _delegate = DocumentRef._('');
  Localstore._();
  static final Localstore _localstore = Localstore._();

  /// Returns an instance using the default [Localstore].
  static Localstore get instance => _localstore;

  @override
  CollectionRef collection(String path) {
    return CollectionRef(path, null, _delegate);
  }
}
