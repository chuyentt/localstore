part of localstore;

class SetOptions {
  final bool _merge;
  bool get merge => _merge;
  SetOptions({bool merge = false}) : _merge = merge;
}

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
  final _utils = Utils.instance;

  final Map<String?, dynamic> _data = {};

  @override
  Future<dynamic> set(Map<String, dynamic> data, [SetOptions? options]) async {
    options ??= SetOptions();
    if (options.merge) {
      final output = Map<String, dynamic>.from(data);
      Map<String, dynamic>? input = _data[id];
      output.updateAll((key, value) {
        input![key] = value;
      });
      _data[id] = input;
      _utils.set(data, path);
    } else {
      _data[id] = data;
      _utils.set(data, path);
    }
  }

  @override
  Future<Map<String, dynamic>?> get() async {
    return _data[id] ?? await _utils.get(path) ?? {};
  }

  @override
  Future delete() async {
    await _utils.delete(path);
    _data.remove(id);
  }

  @override
  CollectionRef collection(String id) {
    return CollectionRef(id, _delegate, this);
  }

  @override
  String toString() {
    return _utils.toString();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
