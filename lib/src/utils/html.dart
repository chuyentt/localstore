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
  Future<Map<String, dynamic>> get(String path,
      [bool? isCollection = false, List<List>? conditions]) async {
    // Fetch the documents for this collection
    if (isCollection != null && isCollection == true) {
      var dataCol = localStorage.entries.singleWhere(
        (e) => e.key == path,
        orElse: () => MapEntry('', ''),
      );
      if (dataCol.key != '') {
        if (conditions != null && conditions.first.length > 0) {
          return _getAll(dataCol);
          /*
          final ck = conditions.first[0] as String;
          final co = conditions.first[1];
          final cv = conditions.first[2];
          // With conditions
          try {
            final mapCol = json.decode(dataCol.value) as Map<String, dynamic>;
            final its = SplayTreeMap.of(mapCol);
            its.removeWhere((key, value) {
              if (value is Map<String, dynamic>) {
                final key = value.keys.contains(ck);
                final check = value[ck] as bool;
                return !(key == true && check == cv);
              }
              return false;
            });
            its.forEach((key, value) {
              final data = value as Map<String, dynamic>;
              _data[key] = data;
            });
            return _data;
          } catch (error) {
            throw error;
          }
          */
        } else {
          return _getAll(dataCol);
        }
      }
    } else {
      final data = await _readFromStorage(path);
      if (data is Map<String, dynamic>) return data;
    }
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
  Stream<Map<String, dynamic>> stream(String path, [List<List>? conditions]) {
    // ignore: close_sinks
    final storage = _storageCache[path] ??
        _storageCache.putIfAbsent(
            path, () => StreamController<Map<String, dynamic>>.broadcast());

    _initStream(storage, path);
    return storage.stream;
  }

  Map<String, dynamic> _getAll(MapEntry<String, String> dataCol) {
    final _data = <String, dynamic>{};
    try {
      final mapCol = json.decode(dataCol.value) as Map<String, dynamic>;
      mapCol.forEach((key, value) {
        final data = value as Map<String, dynamic>;
        _data[key] = data;
      });
      return _data;
    } catch (error) {
      throw error;
    }
  }

  void _initStream(
      StreamController<Map<String, dynamic>> storage, String path) {
    var dataCol = localStorage.entries.singleWhere(
      (e) => e.key == path,
      orElse: () => MapEntry('', ''),
    );
    try {
      if (dataCol.key != '') {
        final mapCol = json.decode(dataCol.value) as Map<String, dynamic>;
        mapCol.forEach((key, value) {
          final _data = value as Map<String, dynamic>;
          storage.add(_data);
        });
      }
    } catch (error) {
      throw error;
    }
  }

  final _storageCache = <String, StreamController<Map<String, dynamic>>>{};

  Future<dynamic> _readFromStorage(String path) async {
    final key = path.replaceAll(RegExp(r'[^\/]+\/?$'), '');
    final data = localStorage.entries.firstWhere(
      (i) => i.key == key,
      orElse: () => MapEntry('', ''),
    );
    if (data != MapEntry('', '')) {
      try {
        return json.decode(data.value) as Map<String, dynamic>;
      } catch (e) {
        return e;
      }
    }
  }

  Future<dynamic> _writeToStorage(
    Map<String, dynamic> data,
    String path,
  ) async {
    final key = path.replaceAll(RegExp(r'[^\/]+\/?$'), '');

    final uri = Uri.parse(path);
    final id = uri.pathSegments.last;
    var dataCol = localStorage.entries.singleWhere(
      (e) => e.key == key,
      orElse: () => MapEntry('', ''),
    );
    try {
      if (dataCol.key != '') {
        final mapCol = json.decode(dataCol.value) as Map<String, dynamic>;
        mapCol[id] = data;
        dataCol = MapEntry(id, json.encode(mapCol));
        localStorage.update(
          key,
          (value) => dataCol.value,
          ifAbsent: () => dataCol.value,
        );
      } else {
        localStorage.update(
          key,
          (value) => json.encode({id: data}),
          ifAbsent: () => json.encode({id: data}),
        );
      }
      // ignore: close_sinks
      final storage = _storageCache[key] ??
          _storageCache.putIfAbsent(
              key, () => StreamController<Map<String, dynamic>>.broadcast());

      storage.sink.add(data);
    } catch (error) {
      throw error;
    }
  }

  Future<dynamic> _deleteFromStorage(String path) async {
    final _key = path.replaceAll(RegExp(r'[^\/]+\/?$'), '');
    final uri = Uri.parse(path);
    final _id = uri.pathSegments.last;
    var dataCol = localStorage.entries.singleWhere(
      (e) => e.key == _key,
      orElse: () => MapEntry('', ''),
    );
    try {
      if (dataCol.key != '') {
        final mapCol = json.decode(dataCol.value) as Map<String, dynamic>;
        mapCol.remove(_id);
        localStorage.update(
          _key,
          (value) => json.encode(mapCol),
          ifAbsent: () => dataCol.value,
        );
      }
    } catch (error) {
      throw error;
    }
  }
}
