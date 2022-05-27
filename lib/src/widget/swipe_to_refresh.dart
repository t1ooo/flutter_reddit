import 'package:flutter/material.dart';
import '../style.dart';

class SwipeToRefresh extends StatelessWidget {
  const SwipeToRefresh({
    Key? key,
    required this.child,
    required this.onRefresh,
  }) : super(key: key);

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: blackColor,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
