import 'dart:async';

import 'package:logging/logging.dart';
export 'package:logging/logging.dart'
    show Level, LogRecord, hierarchicalLoggingEnabled;

extension LoggerExt on Logger {
  void error(Object? message, [Object? error, StackTrace? stackTrace]) {
    severe(message, error, stackTrace);
  }
}

void baseConfigure() {
  hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.OFF;
}

final _loggerRoot = Logger('app');

setLevel(Level level) => _loggerRoot.level = level;

// void setLevelByName(String name, Level level) {
//   for (final e in _loggerRoot.children.entries) {
//     if (e.key == name) {
//       e.value.level = level;
//       break;
//     }
//   }
//   throw Exception('logger not found: $name');
// }

Logger getLogger(String name) => Logger('app.$name');

StreamSubscription<LogRecord>? _loggerSub;

void onLogRecord(Function(LogRecord record) fn) {
  _loggerSub?.cancel();
  _loggerSub = _loggerRoot.onRecord.listen(fn);
}
