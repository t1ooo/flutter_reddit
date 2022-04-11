import '../logging/logging.dart';

final _log = Logger('cast');

/// safe type cast
// T cast<T>(dynamic v, T defaultValue) {
//   if (v is List) {
//     if (v.every((el) => el is T)) {
//       return v as T;
//     } else {
//       _log.info('fail to cast list: $v to <$T>');
//       return defaultValue;
//     }
//   }

//   if (v is T) {
//     return v;
//   } else {
//     _log.info('fail to cast: $v to <$T>');
//     return defaultValue;
//   }
// }

T cast<T>(dynamic v, T defaultValue) {
  try {
    return v as T;
  } on TypeError catch (_) {
    // _log.warning(e);
    _log.info('fail to cast: $v to <$T>');
    return defaultValue;
  }
}
