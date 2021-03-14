part of localstore;

class DocumentRef implements DocumentRefImpl {
  String _id;
  String get id => _id;

  CollectionRef? _delegate;

  DocumentRef._(this._id, [this._delegate]);

  static final _cache = <String, DocumentRef>{};
  factory DocumentRef(String id, [CollectionRef? delegate]) {
    final key = '${delegate?.path ?? ''}$id';
    return _cache.putIfAbsent(key, () => DocumentRef._(id, delegate));
  }

  String get path => '${_delegate?.path ?? ''}$id';
  final _utils = Utils();

  @override
  CollectionRef collection(String id) {
    return CollectionRef(id, _delegate, this);
  }

  @override
  String toString() {
    return _utils.toString();
  }
}
