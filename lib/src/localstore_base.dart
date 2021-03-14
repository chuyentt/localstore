part of localstore;

/// A simple JSON file-based storage
class Localstore implements LocalstoreImpl {
  DocumentRef _delegate = DocumentRef._('');
  Localstore._();
  static final Localstore _localstore = Localstore._();
  static Localstore get instance => _localstore;

  @override
  CollectionRef collection(String path) {
    return CollectionRef(path, null, _delegate);
  }
}
