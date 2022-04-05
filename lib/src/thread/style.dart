import 'package:flutter/widgets.dart';

EdgeInsets commentPadding([int depth = 0]) {
  const padding = 5.0;
  const commentMaxDepth = 5;
  final leftPadding = (depth <= commentMaxDepth ? depth : 0) * 30.0;

  return EdgeInsets.only(
    left: leftPadding,
    top: padding,
    bottom: padding,
  );
}
