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
  Future<Map<String, dynamic>> get(String path,
      [bool? isCollection = false, List<List>? conditions]) async {
    // Fetch the documents for this collection
    if (isCollection != null && isCollection == true) {
      _docDir ??= await _getDocumentDir();
      final _path = '${_docDir?.path}$path';
      final _dir = Directory(_path);
      if (!_dir.existsSync()) {
        _dir.createSync(recursive: true);
      }
      List<FileSystemEntity> entries =
          _dir.listSync(recursive: false).where((e) => e is File).toList();
      if (conditions != null && conditions.first.length > 0) {
        return await _getAll(entries);
        /*
        // With conditions
        entries.forEach((e) async {
          final path = e.path.replaceAll(_docDir!.path, '');
          final file = await _getFile(path);
          _readFile(file!).then((data) {
            if (data is Map<String, dynamic>) {
              _data[path] = data;
            }
          });
        });
        return _data;
        */
      } else {
        return await _getAll(entries);
      }
    } else {
      // Reads the document referenced by this [DocumentRef].
      final file = await _getFile(path);
      final _file = file!.openSync(mode: FileMode.append);
      // if (_file != null) {
      final data = await _readFile(_file);
      // await _file.close();
      if (data is Map<String, dynamic>) {
        final _key = path.replaceAll(RegExp(r'[^\/]+\/?$'), '');
        // ignore: close_sinks
        final storage = _storageCache.putIfAbsent(_key, () => _newStream(_key));
        storage.add(data);
        return data;
      }
      _file.closeSync();
      // }
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
  Stream<Map<String, dynamic>> stream(String path, [List<List>? conditions]) {
    // ignore: close_sinks
    var storage = _storageCache[path];
    if (storage == null) {
      storage = _storageCache.putIfAbsent(path, () => _newStream(path));
    } else {
      _initStream(storage, path);
    }
    return storage.stream;
  }

  Future<Map<String, dynamic>> _getAll(List<FileSystemEntity> entries) async {
    final _data = <String, dynamic>{};
    await Future.forEach(entries, (FileSystemEntity e) async {
      final path = e.path.replaceAll(_docDir!.path, '');
      final file = await _getFile(path);
      final _file = file!.openSync(mode: FileMode.append);
      final data = await _readFile(_file);
      if (data is Map<String, dynamic>) {
        _data[path] = data;
      }
      _file.closeSync();
    });

    return _data;
  }

  /// Streams all file in the path
  StreamController<Map<String, dynamic>> _newStream(String path) {
    final storage = StreamController<Map<String, dynamic>>.broadcast();
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
        final _file = file!.openSync(mode: FileMode.append);
        _readFile(_file).then((data) {
          if (data is Map<String, dynamic>) {
            storage.add(data);
          }
        });
        _file.closeSync();
      });
    } catch (e) {
      return e;
    }
  }

  final _storageCache = <String, StreamController<Map<String, dynamic>>>{};
  final _fileCache = <String, File>{};

  Future<dynamic> _readFile(RandomAccessFile file) async {
    final length = file.lengthSync();
    file.setPositionSync(0);
    final buffer = Uint8List(length);
    file.readIntoSync(buffer);
    try {
      final contentText = utf8.decode(buffer);
      final _data = json.decode(contentText) as Map<String, dynamic>;
      return _data;
    } catch (e) {
      return e;
    }
  }

  Future<File?> _getFile(String path) async {
    if (_fileCache.containsKey(path)) return _fileCache[path];

    _docDir ??= await _getDocumentDir();

    final _path = _docDir?.path;

    final file = File('$_path$path');

    RandomAccessFile? _file;

    if (!file.existsSync()) {
      file.createSync(recursive: true);
      _file = file.openSync(mode: FileMode.append);
    } else {
      _file = file.openSync(mode: FileMode.append);
    }
    _file.closeSync();
    _fileCache.putIfAbsent(path, () => file);

    return file;
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
    final file = await _getFile(path);
    final _file = file!.openSync(mode: FileMode.append);

    _file.lockSync();
    _file.setPositionSync(0);
    _file.writeFromSync(buffer);
    _file.truncateSync(buffer.length);
    _file.closeSync();

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
}
