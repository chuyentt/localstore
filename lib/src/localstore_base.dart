part of localstore;

/// The entry point for accessing a [Localstore].
///
/// You can get an instance by calling [Localstore.instance], for example:
///
/// ```dart
/// final db = Localstore.instance;
/// ```
///
/// To use a custom save path, you can either create a new Localstore instance
/// with the custom path, or set the custom path on the default instance.
/// For example:
///
/// ```dart
/// final db = Localstore.customPath('/your/custom/path');
/// // or
/// Localstore.instance.setCustomSavePath('/your/custom/path');
/// ```
class Localstore implements LocalstoreImpl {
  final _delegate = DocumentRef._('');
  String? _customSavePath;
  final _utils = Utils.instance;

  Localstore._();
  Localstore.customPath(this._customSavePath) {
    _utils.setCustomSavePath(_customSavePath!);
  }

  static final Localstore _localstore = Localstore._();

  /// Returns an instance using the default [Localstore].
  static Localstore get instance => _localstore;

  @override
  CollectionRef collection(String path) {
    return CollectionRef(path, null, _delegate);
  }

  /// Sets the custom save path for the Localstore instance.
  ///
  /// This method can be used to set a custom save path for the default
  /// Localstore instance.
  ///
  /// ```dart
  /// Localstore.instance.setCustomSavePath('/your/custom/path');
  /// ```
  void setCustomSavePath(String path) {
    _customSavePath = path;
    _utils.setCustomSavePath(_customSavePath!);
  }
}
