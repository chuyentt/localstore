library localstore;

/// A simple JSON file-based storage
class Localstore {
  Localstore._();
  static final Localstore _localstore = Localstore._();
  static Localstore get instance => _localstore;
}
