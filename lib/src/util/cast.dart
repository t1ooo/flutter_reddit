import '../logging/logging.dart';

final _log = Logger('cast');

T cast<T>(dynamic v, T defaultValue) {
  try {
    return v as T;
  } on TypeError catch (_) {
    _log.warning('fail to cast: $v to <$T>');
    return defaultValue;
  }
}
