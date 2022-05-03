import 'package:flutter/widgets.dart';

Color? colorFromHex(String hex) {
  final value = int.tryParse('FF' + hex.replaceFirst('#', ''), radix: 16);
  if (value != null) {
    return Color(value);
  }
  return null;
}
