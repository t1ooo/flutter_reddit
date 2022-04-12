import '../logging/logging.dart';

final _log = Logger('mapGet');

// get value from map and cast to type T
// T mapGet<T>(Map data, String key, T defaultValue) {
//   final v = data[key];
//   if (v == null) {
//     _log.info('not found: $key');
//     return defaultValue;
//   }

//   if (v is List) {
//     if (v.every((el) => el is T)) {
//       return v as T;
//     } else {
//     _log.info('fail to cast list: {$key: $v} to <$T>');
//       return defaultValue;
//     }
//   }

//   if (!(v is T)) {
//     _log.info('fail to cast: {$key: $v} to <$T>');
//     return defaultValue;
//   }

//   return v;
// }

T mapGet<T>(Map m, String key, T defaultValue) {
  final val = m[key];
  try {
    return val as T;
  } on TypeError catch (_) {
    // _log.warning(e);
    _log.info('fail to cast: {$key: $val} to <$T>');
    return defaultValue;
  }
}

List<T> mapGetList<T>(Map m, String key, List<T> defaultValue) {
  final val = m[key];
  try {
    return val.cast<T>();
  } on TypeError catch (_) {
    // _log.warning(e);
    _log.info('fail to cast: {$key: $val} to List<$T>');
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
