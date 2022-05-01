import 'src/logging/logging.dart';

void configureLogger(bool debugMode) {
  enableHierarchicalLogging();
  setLevel(debugMode ? Level.ALL : Level.WARNING);
  onLogRecord((LogRecord record) {
    // ignore: avoid_print
    print(
      '${record.level.name}: '
      '${record.time}: '
      '${record.loggerName}: '
      '${record.message} '
      '${record.error != null ? '${record.error} ' : ''}'
      '${record.stackTrace != null ? '${record.stackTrace}' : ''}',
    );
  });
}
