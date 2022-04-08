import '../logging/logging.dart';

final _log = Logger('mapGet');

// get value from map and cast to type T
T mapGet<T>(Map data, String key, T defaultValue) {
  final v = data[key];
  if (v == null) {
    _log.info('not found: $key');
    return defaultValue;
  }

  if (!(v is T)) {
    _log.info('fail to cast: {$key: $v} to <$T>');
    return defaultValue;
  }

  return v;
}
