import 'dart:async';

import 'package:logging/logging.dart';
export 'package:logging/logging.dart'
    show Logger, Level, LogRecord, hierarchicalLoggingEnabled;

extension LoggerExt on Logger {
  void error(Object? message, [Object? error, StackTrace? stackTrace]) {
    severe(message, error, stackTrace);
  }
}

void baseConfigure() {
  hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.OFF;
}

final _rootName = 'app';
final _root = Logger(_rootName);

setLevel(Level level) => _root.level = level;

// void setLevelByName(String name, Level level) {
//   for (final e in _loggers.entries) {
//     if (e.key == name) {
//       e.value.level = level;
//       break;
//     }
//   }
//   throw Exception('logger not found: $name');
// }

// void setLevelByName(String name, Level level) {
//   _loggers[name]?.level = level;
// }

void setLevelByName(String name, Level level) {
  // A local, top-level, or class variable that’s declared as final
  // is initialized the first time it’s used.
  // Therefore, we try to set the level, otherwise we set the level
  // during initialization in [getLogger].
  _loggers[name]?.level = level;
  _levels[name] = level;
}

final _levels = <String, Level>{};
final _loggers = <String, Logger>{};

Logger getLogger(String name) {
  print('getLogger: $name');
  final logger = Logger('$_rootName.$name');
  final level = _levels[name];
  if (level != null) {
    logger.level = level;
  }
  _loggers[name] = logger;
  return logger;
}

StreamSubscription<LogRecord>? _loggerSub;

void onLogRecord(Function(LogRecord record) fn) {
  _loggerSub?.cancel();
  _loggerSub = _root.onRecord.listen(fn);
}
