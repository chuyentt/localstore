part of localstore;

/// The entry point for accessing a [Localstore].
///
/// You can get an instance by calling [Localstore.instance], for example:
///
/// ```dart
/// final db = Localstore.instance;
/// ```
class Localstore implements LocalstoreImpl {
  final _delegate = DocumentRef._('localstore');
  Localstore._();
  static final Localstore _localstore = Localstore._();

  /// Returns an instance using the default [Localstore].
  static Localstore get instance => _localstore;

  @override
  CollectionRef collection(String path) {
    final newCollection = CollectionRef(path, null, _delegate);
    collections.add(newCollection);
    return newCollection;
  }

  //XXX: this wouldnt suffice since it only contains collections created in this session
  //TODO: get all collections..
  List<CollectionRef> collections = [];

  Future clearAll() async {
    // todo make it work
    _delegate.delete();
    Future.wait(collections.map((doc) => doc.clear()));
  }
}
