import 'package:flutter/material.dart';

enum AsyncButtonBuilderBehavior {
  /// ignore click when onPressed is executed
  ignore,

  /// disable button when onPressed is executed
  disable,
}

typedef FutureVoidCallback = Future<void> Function();

/// pass onPressed argument to the builder or (empty callback|null) when onPressed is executed
class AsyncButtonBuilder extends StatefulWidget {
  const AsyncButtonBuilder({
    Key? key,
    required this.onPressed,
    required this.builder,
    this.behavior = AsyncButtonBuilderBehavior.ignore,
  }) : super(key: key);

  final FutureVoidCallback onPressed;
  final Widget Function(BuildContext, FutureVoidCallback?) builder;
  final AsyncButtonBuilderBehavior behavior;

  @override
  State<AsyncButtonBuilder> createState() => _AsyncButtonBuilderState();
}

class _AsyncButtonBuilderState extends State<AsyncButtonBuilder> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _fnOnPressed());
  }

  FutureVoidCallback? _fnOnPressed() {
    if (_enabled) return _onPressed;

    switch (widget.behavior) {
      case AsyncButtonBuilderBehavior.ignore:
        return _onPressedIgnore;
      case AsyncButtonBuilderBehavior.disable:
        return null;
    }
  }

  Future<void> _onPressedIgnore() async {/* do nothing */}

  Future<void> _onPressed() async {
    setState(() => _enabled = false);
    await widget.onPressed();
    setState(() => _enabled = true);
  }
}
