import 'dart:io';

// String enumToString(Enum e) {
String enumToString(dynamic e) {
  return e.toString().split('.').last;
}

String enumNToString(Enum? e) {
  if (e == null) {
    return '';
  }
  return enumToString(e);
}
