import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import 'utils_impl.dart';

class Utils implements UtilsImpl {
  Utils._() {
    _getDocumentDir().then((value) => _docDir = value);
  }
  static final Utils _utils = Utils._();
  static Utils get instance => _utils;

  @override
  Future<Map<String, dynamic>> get(String path) async {
    RandomAccessFile? _file = await _getFile(path);
    if (_file != null) {
      final data = await _readFile(_file);
      if (data is Map<String, dynamic>) {
        final _key = path.replaceAll(RegExp(r'[^\/]+\/?$'), '');
        // ignore: close_sinks
        final storage = _storageCache.putIfAbsent(_key, () => _newStream(_key));
        storage.add(data);
        return data;
      }
    }
    return Map<String, dynamic>();
  }

  @override
  Future<dynamic>? set(Map<String, dynamic> data, String path) {
    _writeFile(data, path);
  }

  @override
  Future delete(String path) async {
    _deleteFile(path);
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
    _docDir ??= await _getDocumentDir();
    final _path = '${_docDir?.path}$path';
    final _dir = Directory(_path);
    try {
      List<FileSystemEntity> entries =
          _dir.listSync(recursive: false).where((e) => e is File).toList();
      entries.forEach((e) async {
        final path = e.path.replaceAll(_docDir!.path, '');
        final file = await _getFile(path);
        _readFile(file!).then((data) {
          if (data is Map<String, dynamic>) {
            storage.add(data);
          }
        });
      });
    } catch (e) {
      return e;
    }
  }

  final _storageCache = <String, StreamController<Map<String, dynamic>>>{};
  final _fileCache = <String, RandomAccessFile>{};

  Future<dynamic> _readFile(RandomAccessFile file) async {
    final length = await file.length();
    file = await file.setPosition(0);
    final buffer = Uint8List(length);
    await file.readInto(buffer);
    try {
      final contentText = utf8.decode(buffer);
      final _data = json.decode(contentText) as Map<String, dynamic>;
      return _data;
    } catch (e) {
      return e;
    }
  }

  Future<RandomAccessFile?> _getFile(String path) async {
    if (_fileCache.containsKey(path)) return _fileCache[path];

    _docDir ??= await _getDocumentDir();

    final _path = _docDir?.path;

    final file = File('$_path$path');

    RandomAccessFile? _file;

    if (await file.exists()) {
      _file = await file.open(mode: FileMode.append);
    } else {
      await file.create(recursive: true);
      _file = await file.open(mode: FileMode.append);
    }

    _fileCache.putIfAbsent(path, () => _file!);

    return _file;
  }

  Directory? _docDir;

  Future<Directory> _getDocumentDir() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      _docDir = dir;
      return dir;
    } catch (error) {
      throw error;
    }
  }

  Future _writeFile(Map<String, dynamic> data, String path) async {
    final serialized = json.encode(data);
    final buffer = utf8.encode(serialized);
    var _file = await _getFile(path);

    _file = await _file!.lock();
    _file = await _file.setPosition(0);
    _file = await _file.writeFrom(buffer);
    _file = await _file.truncate(buffer.length);

    final _key = path.replaceAll(RegExp(r'[^\/]+\/?$'), '');
    // ignore: close_sinks
    final storage = _storageCache.putIfAbsent(_key, () => _newStream(_key));
    storage.add(data);
  }

  Future _deleteFile(String path) async {
    _docDir ??= await _getDocumentDir();
    final _path = _docDir?.path;
    final _file = File('$_path$path');
    _file.exists().then((value) {
      if (value) {
        _file.delete();
        _fileCache.remove(path);
      }
    });
  }

  @override
  void dispose() {
    _storageCache.forEach((key, value) {
      value.close();
    });
    _fileCache.forEach((key, value) {
      value.close();
    });
    _fileCache.clear();
  }
}
