import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'utils_impl.dart';

/// Utils class
class Utils implements UtilsImpl {
  Utils._();
  static final Utils _utils = Utils._();
  static Utils get instance => _utils;

  html.Storage get localStorage => html.window.localStorage;

  @override
  Future<Map<String, dynamic>> get(String path) async {
    final data = await _readFromStorage(path);
    if (data is Map<String, dynamic>) return data;
    return Map<String, dynamic>();
  }

  @override
  Future<dynamic>? set(Map<String, dynamic> data, String path) {
    _writeToStorage(data, path);
  }

  @override
  Future delete(String path) async {
    _deleteFromStorage(path);
  }

  @override
  Stream<Map<String, dynamic>> stream(String path) {
    // ignore: close_sinks
    final storage = _storageCache.putIfAbsent(path, () => _newStream(path));
    return storage.stream;
  }

  /// Streams all file in the path
  StreamController<Map<String, dynamic>> _newStream(String path) {
    final storage = StreamController<Map<String, dynamic>>();
    _initStream(storage, path);

    return storage;
  }

  Future _initStream(
    StreamController<Map<String, dynamic>> storage,
    String path,
  ) async {
    final entries = localStorage.entries;
    entries.forEach((e) {
      print(e.value);
    });
    // entries.forEach((data) async {
    //   print(data);
    //   // if (data is Map<String, dynamic>) {
    //   //   storage.add(data);
    //   // }
    // });
  }

  final _storageCache = <String, StreamController<Map<String, dynamic>>>{};

  Future<dynamic> _readFromStorage(String path) async {
    final data = localStorage.entries.firstWhere(
      (i) => i.key == path,
      orElse: () => MapEntry('', ''),
    );
    if (data != MapEntry('', '')) {
      try {
        final _key = path.replaceAll(RegExp(r'[^\/]+\/?$'), '');
        // ignore: close_sinks
        final storage = _storageCache.putIfAbsent(_key, () => _newStream(_key));
        final _data = json.decode(data.value) as Map<String, dynamic>;
        storage.add(_data);
        return _data;
      } catch (e) {
        return e;
      }
    }
  }

  Future<dynamic> _writeToStorage(
    Map<String, dynamic> data,
    String path,
  ) async {
    final _key = path.replaceAll(RegExp(r'[^\/]+\/?$'), '');
    localStorage.update(
      _key,
      (val) => json.encode({path: data}),
      ifAbsent: () => json.encode({path: data}),
    );

    // ignore: close_sinks
    final storage = _storageCache.putIfAbsent(_key, () => _newStream(_key));
    storage.add(data);
  }

  Future<dynamic> _deleteFromStorage(String path) async {
    localStorage.remove(path);
  }
}
