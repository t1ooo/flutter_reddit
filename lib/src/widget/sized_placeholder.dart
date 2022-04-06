import 'package:flutter/material.dart';

class SizedPlaceholder extends StatelessWidget {
  const SizedPlaceholder({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Placeholder(),
    );
  }
}
