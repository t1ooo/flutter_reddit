import '../logging.dart';

class UIException implements Exception {
  UIException(this._message);
  String _message;
  String toString() => _message;
}

mixin TryMixin {
  // static final _log = getLogger('TryMixin');
  Logger get log;

  Future<T> try_<T>(Future<T> Function() fn, String error) async {
    try {
      return await fn();
    } on Exception catch (e, st) {
      log.error('', e, st);
      throw UIException(error);
    } on TypeError catch (e, st) {
      log.error('', e, st);
      throw UIException(error);
    }
  }
}
