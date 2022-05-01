import 'dart:async';

import 'package:logging/logging.dart';
export 'package:logging/logging.dart'
    show Level, LogRecord, hierarchicalLoggingEnabled;

extension LoggerExt on Logger {
  void error(Object? message, [Object? error, StackTrace? stackTrace]) {
    severe(message, error, stackTrace);
  }
}

void enableHierarchicalLogging() => hierarchicalLoggingEnabled = true;

setLevel(Level level) => _loggerRoot.level;

Logger getLogger(String name) => Logger('app.$name');

final _loggerRoot = Logger('app');

StreamSubscription<LogRecord>? _loggerSub;

void onLogRecord(Function(LogRecord record) fn) {
  if (_loggerSub != null) {
    return;
  }
  // _loggerSub?.cancel();
  // Logger.root.clearListeners();
  _loggerSub = _loggerRoot.onRecord.listen(fn);
}
