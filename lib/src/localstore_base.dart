part of '../localstore.dart';

/// This is the entry point for accessing a [Localstore].
///
/// You can obtain an instance by calling [Localstore.instance]. For example:
///
/// ```dart
/// final db = Localstore.instance;
/// ```
///
/// To create an instance with a custom save path or to use the support directory,
/// use the [getInstance] method. For example:
///
/// ```dart
/// final db = Localstore.getInstance(customPath: '/your/custom/path');
/// // or to use the support directory
/// final db = Localstore.getInstance(useSupportDir: true);
/// ```
///
/// Note: When `useSupportDir` is set to `true`, `customPath` must be null or empty.
class Localstore implements LocalstoreImpl {
  final _delegate = DocumentRef._('');
  final _utils = Utils.instance;

  Localstore._();

  static final Localstore _localstore = Localstore._();

  /// Returns an instance using the default [Localstore].
  static Localstore get instance => _localstore;

  /// Returns an instance of [Localstore] with a custom save path or using the support directory.
  /// If `useSupportDir` is true, `customPath` must be null or empty.
  static Localstore getInstance(
      {String? customPath, bool useSupportDir = false}) {
    assert(!(useSupportDir && (customPath != null && customPath.isNotEmpty)),
        "When useSupportDir is true, customPath must be null or empty.");

    if ((customPath == null || customPath.isNotEmpty) && !useSupportDir) {
      return _localstore;
    } else if (customPath != null) {
      _localstore._utils.setCustomSavePath(customPath);
    } else {
      _localstore._utils.setUseSupportDirectory(useSupportDir);
    }
    return _localstore;
  }

  @override
  CollectionRef collection(String path) {
    return CollectionRef(path, null, _delegate);
  }
}
