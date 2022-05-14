import 'dart:math';
import 'dart:ui';

Size adjustSize({
  required double maxHeight,
  required double maxWidth,
  required double width,
  required double height,
  double maxScale = 5,
}) {
  final heightScale = maxHeight / height;
  final widthScale = maxWidth / width;
  final scale = min(maxScale, min(heightScale, widthScale));
  return Size(width * scale, height * scale);
}
