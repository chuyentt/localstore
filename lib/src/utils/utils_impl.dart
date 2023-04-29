// abstract class UtilsImpl {
//   Future<Map<String, dynamic>?> get(String path,
//       [bool? isCollection = false, List<List>? conditions]);
//   Future<dynamic>? set(Map<String, dynamic> data, String path);
//   Future delete(String path);
//   Stream<Map<String, dynamic>> stream(String path, [List<List>? conditions]);
// }

abstract class UtilsImpl {
  /// Retrieves data from the file at the specified path.
  ///
  /// If [isCollection] is `true`, retrieves all data in the collection.
  /// If [conditions] is specified, retrieves only data that matches the conditions.
  ///
  /// If [_customSavePath] is specified, the data will be retrieved from the file
  /// at the custom save path instead of the default save path.
  Future<Map<String, dynamic>?> get(String path,
      [bool? isCollection = false, List<List>? conditions]);

  /// Writes data to the file at the specified path.
  ///
  /// If [_customSavePath] is specified, the data will be written to the file
  /// at the custom save path instead of the default save path.
  Future<dynamic>? set(Map<String, dynamic> data, String path);

  /// Deletes the file at the specified path.
  ///
  /// If [_customSavePath] is specified, the file will be deleted from the custom
  /// save path instead of the default save path.
  Future delete(String path);

  /// Returns a stream that emits data when it changes at the specified path.
  ///
  /// If [conditions] is specified, only data that matches the conditions will
  /// be included in the stream.
  ///
  /// If [_customSavePath] is specified, the stream will watch for changes in the
  /// file at the custom save path instead of the default save path.
  Stream<Map<String, dynamic>> stream(String path, [List<List>? conditions]);

  /// Sets the custom save path for the Utils instance.
  ///
  /// This method can be used to set a custom save path for the Utils instance.
  ///
  /// ```dart
  /// Utils.instance.setCustomSavePath('/your/custom/path');
  /// ```
  void setCustomSavePath(String path);
}
