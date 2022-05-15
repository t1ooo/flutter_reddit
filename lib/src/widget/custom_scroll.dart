import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomScroll extends StatelessWidget {
  const CustomScroll({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: child,
    );
  }
}
