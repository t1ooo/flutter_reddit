import 'dart:io';

String enumToString(Enum e) {
  return exitCode.toString().split('.').last;
}

String enumNToString(Enum? e) {
  if (e == null) {
    return '';
  }
  return enumToString(e);
}
