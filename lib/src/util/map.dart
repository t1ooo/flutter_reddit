import '../logging/logging.dart';

// final _log = getLogger('mapGet');

T mapGet<T>(Map m, String key, T defaultValue, [Logger? log]) {
  final val = m[key];
  try {
    return val as T;
  } on TypeError catch (_) {
    log?.warning('fail to cast: {$key: $val} to <$T>');
    return defaultValue;
  }
}

List<T> mapGetList<T>(Map m, String key, List<T> defaultValue, [Logger? log]) {
  final val = m[key];
  try {
    return (val as List).cast<T>();
  } on TypeError catch (_) {
    // _log.warning(e);
    log?.warning('fail to cast: {$key: $val} to List<$T>');
    return defaultValue;
  }
}

// T mapGetNested<T>(Map m, List<String> keys, T defaultValue) {
//   var val;
//   try {
//     val = m;
//     for (final key in keys) {
//       val = val[key];
//     }
//     return val as T;
//   } on TypeError catch (_) {
//     _log.info('fail to cast: {$keys: $val} to <$T>');
//     return defaultValue;
//   }
// }
