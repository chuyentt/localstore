import 'dart:io';

abstract class UtilsImpl {
  Future<Map<String, dynamic>> get(String path);
  Future<dynamic>? set(Map<String, dynamic> data, String path);
  Future delete(String path);
  Stream<Map<String, dynamic>> stream(String path);
  void dispose();
}
