part of localstore;

/// The entry point for accessing a [Localstore].
///
/// You can get an instance by calling [Localstore.instance], for example:
///
/// ```dart
/// final db = Localstore.instance;
/// ```
class Localstore implements LocalstoreImpl {
  var _databaseDirectoryCompleter = Completer<Directory>();
  final _delegate = DocumentRef._('');
  static final Localstore _localstore = Localstore._();

  /// Private initializer
  ///
  /// Sets the [_databaseDirectoryCompleter] if not already set through user override
  Localstore._() {
    getApplicationDocumentsDirectory().then((dir) {
      if (!_databaseDirectoryCompleter.isCompleted) {
        _databaseDirectoryCompleter.complete(dir);
      }
    });
  }

  /// Returns an instance using the default [Localstore].
  static Localstore get instance => _localstore;

  @override
  CollectionRef collection(String path) {
    return CollectionRef(path, null, _delegate);
  }

  @override
  Future<Directory> getDatabaseDirectory() => _databaseDirectoryCompleter.future;

  @override
  void setDatabaseDirectory(Directory dir) {
    // complete, or replace the completer if already completed
    final completer = _databaseDirectoryCompleter.isCompleted
        ? Completer<Directory>()
        : _databaseDirectoryCompleter;
    _databaseDirectoryCompleter = completer;
    completer.complete(dir);
  }
}
