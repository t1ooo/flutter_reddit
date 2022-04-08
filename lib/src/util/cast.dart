import '../logging/logging.dart';

final _log = Logger('cast');

/// safe type cast
T cast<T>(dynamic v, T defaultValue) {
  if (v is T) {
    return v;
  }
  _log.info('fail to cast: $v to <$T>');
  return defaultValue;
}
