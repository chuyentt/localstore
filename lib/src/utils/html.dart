import 'dir_impl.dart';

abstract class Dir implements DirImpl {
  Dir() {
    print('Dir instance for the web');
  }

  @override
  String toString() {
    return 'Dir instance for the web';
  }
}
