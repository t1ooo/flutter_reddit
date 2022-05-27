import 'dart:math';

import 'package:flutter/widgets.dart';

Color? colorFromHex(String hex) {
  if (hex == '') {
    return null;
  }
  final value = int.tryParse('FF${hex.replaceFirst('#', '')}', radix: 16);
  if (value != null) {
    return Color(value);
  }
  return null;
}

/// return color generated from string
Color generateColor(String s) {
  const min = 0;
  const max = 0xFFFFFFFF;
  final value = min + Random(s.hashCode).nextInt(max - min);
  return Color(value);
}
