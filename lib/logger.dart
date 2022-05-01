import 'src/logging/logging.dart';

void configureLogger(bool debugMode) {
  baseConfigure();
  setLevel(debugMode ? Level.ALL : Level.WARNING);
  // setLevelByName('FakeRedditApi', Level.OFF);
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
