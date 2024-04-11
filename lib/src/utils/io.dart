import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'utils_impl.dart';

class Utils implements UtilsImpl {
  Utils._();
  static final Utils _utils = Utils._();
  static final lastPathComponentRegEx = RegExp(r'[^/\\]+[/\\]?$');
  static Utils get instance => _utils;
  String? _customSavePath;
  bool useSupportDir = false;
  final _storageCache = <String, StreamController<Map<String, dynamic>>>{};
  final _fileCache = <String, File>{};

  @override
  void setCustomSavePath(String path) {
    _customSavePath = path;
    _utils.setCustomSavePath(_customSavePath!);
  }

  @override
  void setUseSupportDirectory(bool useSupportDir) {
    this.useSupportDir = useSupportDir;
  }

  Future<String> getDatabasePath() async {
    Directory directory;

    if (Platform.isIOS) {
      if (useSupportDir) {
        directory = await getApplicationSupportDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
    } else if (Platform.isAndroid) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      // Add other platform-specific directory as needed
      // throw UnsupportedError('This platform is not supported for databases.');
      directory = Directory.current;
    }
    debugPrint(directory.path);

    return directory.path;
  }

  @override
  Future<Map<String, dynamic>?> get(String path,
      [bool? isCollection = false, List<List>? conditions]) async {
    // Fetch the documents for this collection
    if (isCollection != null && isCollection == true) {
      final dbPath = await getDatabasePath();
      final fullPath = _customSavePath ?? dbPath;
      final dir = Directory('$fullPath$path');
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
      List<FileSystemEntity> entries =
          dir.listSync(recursive: false).whereType<File>().toList();
      if (conditions != null && conditions.first.isNotEmpty) {
        return await _getAll(entries);
        /*
        // With conditions
        entries.forEach((e) async {
          final path = e.path.replaceAll(_docDir!.absolute.path, '');
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
      final randomAccessFile = file!.openSync(mode: FileMode.append);
      final data = await _readFile(randomAccessFile);
      randomAccessFile.closeSync();
      if (data is Map<String, dynamic>) {
        final key = path.replaceAll(lastPathComponentRegEx, '');
        // ignore: close_sinks
        final storage = _storageCache.putIfAbsent(key, () => _newStream(key));
        storage.add(data);
        return data;
      }
    }
    return null;
  }

  @override
  Future<dynamic>? set(Map<String, dynamic> data, String path) {
    return _writeFile(data, path);
  }

  @override
  Future delete(String path) async {
    if (path.endsWith(Platform.pathSeparator)) {
      _deleteDirectory(path);
    } else {
      _deleteFile(path);
    }
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

  Future<Map<String, dynamic>?> _getAll(List<FileSystemEntity> entries) async {
    final items = <String, dynamic>{};
    final dbPath = await getDatabasePath();
    final fullPath = _customSavePath ?? dbPath;
    final dir = Directory(fullPath);
    await Future.forEach(entries, (FileSystemEntity e) async {
      final path = e.path.replaceAll(dir.absolute.path, '');
      final file = await _getFile(path);
      final randomAccessFile = await file!.open(mode: FileMode.append);
      final data = await _readFile(randomAccessFile);
      await randomAccessFile.close();

      if (data is Map<String, dynamic>) {
        items[path] = data;
      }
    });

    if (items.isEmpty) return null;
    return items;
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
    final dbPath = await getDatabasePath();
    final fullPath = _customSavePath ?? dbPath;
    final dir = Directory('$fullPath$path');
    try {
      List<FileSystemEntity> entries =
          dir.listSync(recursive: false).whereType<File>().toList();
      for (var e in entries) {
        final filePath = e.path.replaceAll(dir.absolute.path, '');
        final file = await _getFile('$path$filePath');
        final randomAccessFile = file!.openSync(mode: FileMode.append);
        _readFile(randomAccessFile).then((data) {
          randomAccessFile.closeSync();
          if (data is Map<String, dynamic>) {
            storage.add(data);
          }
        });
      }
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> _readFile(RandomAccessFile file) async {
    final length = file.lengthSync();
    file.setPositionSync(0);
    final buffer = Uint8List(length);
    file.readIntoSync(buffer);
    try {
      final contentText = utf8.decode(buffer);
      final data = json.decode(contentText) as Map<String, dynamic>;
      return data;
    } catch (e) {
      return e;
    }
  }

  Future<File?> _getFile(String path) async {
    if (_fileCache.containsKey(path)) return _fileCache[path];

    final fullPath = _customSavePath ?? await getDatabasePath();
    final file = File(fullPath.endsWith(Platform.pathSeparator)
        ? '$fullPath$path'
        : '$fullPath${Platform.pathSeparator}$path');

    if (!file.existsSync()) file.createSync(recursive: true);
    _fileCache.putIfAbsent(path, () => file);

    return file;
  }

  Future _writeFile(Map<String, dynamic> data, String path) async {
    final serialized = json.encode(data);
    final buffer = utf8.encode(serialized);
    final file = await _getFile(path);
    final randomAccessFile = file!.openSync(mode: FileMode.append);

    randomAccessFile.lockSync();
    randomAccessFile.setPositionSync(0);
    randomAccessFile.writeFromSync(buffer);
    randomAccessFile.truncateSync(buffer.length);
    randomAccessFile.unlockSync();
    randomAccessFile.closeSync();

    final key = path.replaceAll(lastPathComponentRegEx, '');
    // ignore: close_sinks
    final storage = _storageCache.putIfAbsent(key, () => _newStream(key));
    storage.add(data);
  }

  Future _deleteFile(String path) async {
    final fullPath = _customSavePath ?? await getDatabasePath();
    final file = File(fullPath.endsWith(Platform.pathSeparator)
        ? '$fullPath$path'
        : '$fullPath${Platform.pathSeparator}$path');

    if (file.existsSync()) {
      file.deleteSync();
      _fileCache.remove(path);
    }
  }

  Future _deleteDirectory(String path) async {
    final fullPath = _customSavePath ?? await getDatabasePath();
    final dir = Directory('$fullPath$path');
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
      _fileCache.removeWhere((key, value) => key.startsWith(path));
    }
  }
}
