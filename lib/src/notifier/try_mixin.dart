import '../logging.dart';

class UIException implements Exception {
  UIException(this._message);
  final String _message;
  @override
  String toString() => _message;
}

// TODO: replace to function
// or use late final Logger _log = getLogger(runtimeType.toString());
mixin TryMixin {
  Logger get log;

  Future<T> try_<T>(Future<T> Function() fn, String error) async {
    try {
      return await fn();
    } on Exception catch (e, st) {
      log.error('', e, st);
      throw UIException(error);
      // ignore: avoid_catching_errors
    } on TypeError catch (e, st) {
      log.error('', e, st);
      throw UIException(error);
    }
  }
}
