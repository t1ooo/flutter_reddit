
// final _log = getLogger('cast');

import '../logging/logging.dart';

T cast<T>(dynamic v, T defaultValue, [Logger? log]) {
  try {
    return v as T;
  } on TypeError catch (_) {
    log?.warning('fail to cast: $v to <$T>');
    return defaultValue;
  }
}
