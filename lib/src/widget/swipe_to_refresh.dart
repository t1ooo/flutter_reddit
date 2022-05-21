import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style.dart';

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
