part of localstore;

/// A [CollectionRef] object can be used for adding documents, getting
/// [DocumentRef]s, and querying for documents (using the methods
/// inherited from [Query]).
class CollectionRef implements CollectionRefImpl {
  String _id;

  /// A string representing the path of the referenced document (relative to the
  /// root of the database).
  String get path => '${_parent?.path ?? ''}${_delegate?.id ?? ''}/$_id/';

  DocumentRef? _delegate;

  CollectionRef? _parent;

  /// The parent [CollectionRef] of this document.
  CollectionRef? get parent => _parent;

  CollectionRef._(this._id, [this._parent, this._delegate]);
  static final _cache = <String, CollectionRef>{};

  /// Returns an instance using the default [CollectionRef].
  factory CollectionRef(String id,
      [CollectionRef? parent, DocumentRef? delegate]) {
    final key = '${parent?.path ?? ''}${delegate?.id ?? ''}/$id/';
    return _cache.putIfAbsent(key, () => CollectionRef._(id, parent, delegate));
  }

  final _utils = Utils.instance;

  @override
  Stream<Map<String, dynamic>> get stream => _utils.stream(path);

  @override
  DocumentRef doc([String? id]) {
    id ??= int.parse(
            '${Random().nextInt(1000000000)}${Random().nextInt(1000000000)}')
        .toRadixString(35)
        .substring(0, 9);
    return DocumentRef(id, this);
  }
}
