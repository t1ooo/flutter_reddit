import '../logging/logging.dart';

class UIException implements Exception {
  UIException(this._message);
  String _message;
  String toString() => _message;
}

abstract class Try {
  static final _log = getLogger('Try');

  Future<T> try_<T>(Future<T> Function() fn, String error) async {
    try {
      return await fn();
    } on Exception catch (e, st) {
      _log.error('', e, st);
      throw UIException(error);
    } on TypeError catch (e, st) {
      _log.error('', e, st);
      throw UIException(error);
    }
  }
}
